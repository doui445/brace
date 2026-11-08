#!/usr/bin/env python3
"""BRACE brand: render the agency's Markdown into HTML, in the house style.

Usage:
  render.py doc  <src.md> <dst.html>   a written document (benchmark, minutes...)
  render.py deck <src.md> <dst.html>   a presentation (see references/presentation.md)
  render.py space <project-root>       the client space, docs/brace/brand/index.html

Every render copies deck.css, doc.css and fonts/ next to its output when
they are missing. Exit 0 rendered, 1 bad input (message on stderr).
Python 3 standard library only; self-relative (finds its assets and the
i18n catalogues from its own path).
"""
import datetime
import html
import os
import re
import shutil
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ASSETS = HERE.parent / "assets"
I18N = HERE.parents[1] / "track" / "references" / "i18n"


class RenderError(Exception):
    pass


# --- small helpers -----------------------------------------------------------

def esc(text):
    return html.escape(text, quote=True)


def catalogue(lang):
    """The brand.* strings of a language, falling back to English."""
    out = {}
    for code in ("en", lang):
        if not re.fullmatch(r"[a-z]{2}", code or ""):
            continue
        path = I18N / f"{code}.md"
        if not path.is_file():
            continue
        for m in re.finditer(r"(?m)^- (brand\.[a-z0-9_.]+): (.*)$", path.read_text(encoding="utf-8")):
            out[m.group(1)] = m.group(2).strip()
    return out


def parse_front_matter(text):
    """Split '---' front matter (key: value lines) from the body."""
    m = re.match(r"\A---\n(.*?)\n---\n?(.*)\Z", text.replace("\r\n", "\n"), re.S)
    if not m:
        raise RenderError("missing front matter (--- key: value lines --- at the top)")
    meta = {}
    for line in m.group(1).splitlines():
        if not line.strip():
            continue
        k, sep, v = line.partition(":")
        if not sep:
            raise RenderError(f"bad front matter line: {line!r}")
        meta[k.strip()] = v.strip()
    return meta, m.group(2)


def assets_dir(dst):
    """Where an output's stylesheets live: the project's docs/brace/brand/
    folder when the output is inside it (one copy for documents/,
    presentations/ and the client space), else the output's own folder."""
    folder = Path(dst).resolve().parent
    for d in (folder, *folder.parents):
        if d.name == "brand" and d.parent.name == "brace" and d.parent.parent.name == "docs":
            return d
    return folder


def css_href(dst, name):
    return Path(os.path.relpath(assets_dir(dst) / name, Path(dst).resolve().parent)).as_posix()


def ensure_assets(dst_dir):
    """Copy the house stylesheets (refreshed when the shipped ones changed)
    and the fonts (when missing) into a folder."""
    dst_dir = Path(dst_dir)
    dst_dir.mkdir(parents=True, exist_ok=True)
    for name in ("deck.css", "doc.css"):
        shipped = (ASSETS / name).read_bytes()
        target = dst_dir / name
        if not target.exists() or target.read_bytes() != shipped:
            target.write_bytes(shipped)
    if not (dst_dir / "fonts").exists():
        shutil.copytree(ASSETS / "fonts", dst_dir / "fonts")


# --- inline and block Markdown ----------------------------------------------

SAFE_URL = re.compile(r"\A(?:https?://|mailto:|#|[^:]*\Z)", re.I)


def inline(text, bold="strong"):
    """Escaped text with `code`, [links](url), **bold** and *italic*."""
    parts = re.split(r"(`[^`]+`)", text)
    out = []
    for part in parts:
        if part.startswith("`") and part.endswith("`") and len(part) > 1:
            out.append("<code>" + esc(part[1:-1]) + "</code>")
            continue
        s = esc(part)

        def emphasis(t):
            t = re.sub(r"\*\*(.+?)\*\*", rf"<{bold}>\1</{bold}>", t)
            return re.sub(r"(?<![*\w])\*(?!\s)(.+?)(?<!\s)\*(?![*\w])", r"<em>\1</em>", t)

        # Links are set aside first, so that emphasis never reaches a URL.
        links = []

        def link(m):
            label, url = emphasis(m.group(1)), html.unescape(m.group(2))
            links.append(f'<a href="{esc(url)}">{label}</a>' if SAFE_URL.match(url) else label)
            return f"\x00{len(links) - 1}\x00"

        s = re.sub(r"\[([^\]]+)\]\(((?:[^()\s]|\([^()\s]*\))+)\)", link, s)
        s = emphasis(s)
        s = re.sub(r"\x00(\d+)\x00", lambda m: links[int(m.group(1))], s)
        out.append(s)
    return "".join(out)


def _row(line):
    return [c.strip() for c in line.strip().strip("|").split("|")]


LIST_MARKERS = ((re.compile(r"[-*] (.*)"), "ul"), (re.compile(r"\d+[.)] (.*)"), "ol"))


def _marker(line):
    """(tag, item text) when the line starts a list item, else None."""
    for pat, tag in LIST_MARKERS:
        m = pat.match(line.lstrip())
        if m:
            return tag, m.group(1)
    return None


def _list(lines, i):
    """One list from lines[i]: wrapped lines join their item, items indented
    by two spaces or more form one nested level. Returns (html, next i)."""
    tag = _marker(lines[i])[0]
    items = []  # [text, child tag, [child texts]]
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        if not stripped or stripped == "---":
            break
        indent = len(line) - len(line.lstrip())
        mark = _marker(line)
        if mark and (indent < 2 or not items):
            if mark[0] != tag:
                break
            items.append([mark[1], None, []])
        elif mark:
            last = items[-1]
            last[1] = last[1] or mark[0]
            last[2].append(mark[1])
        elif re.match(r"(#{1,3} |>|\|)", line.lstrip()):
            break
        elif items[-1][2]:
            items[-1][2][-1] += " " + stripped
        else:
            items[-1][0] += " " + stripped
        i += 1
    parts = []
    for text, sub, children in items:
        nested = (f"<{sub}>" + "".join(f"<li>{inline(c)}</li>" for c in children) + f"</{sub}>") if children else ""
        parts.append(f"<li>{inline(text)}{nested}</li>")
    return f"<{tag}>" + "".join(parts) + f"</{tag}>", i


def md_to_html(text):
    """The Markdown subset of references/documents.md, as HTML."""
    lines = text.replace("\r\n", "\n").split("\n")
    out, i = [], 0
    while i < len(lines):
        line = lines[i]
        if not line.strip():
            i += 1
            continue
        h = re.match(r"(#{1,3}) (.+)", line)
        if h:
            n = len(h.group(1))
            out.append(f"<h{n}>{inline(h.group(2).strip())}</h{n}>")
            i += 1
            continue
        if line.lstrip().startswith("|") and i + 1 < len(lines) and re.match(r"\s*\|?\s*:?-{2,}", lines[i + 1]):
            head = _row(line)
            i += 2
            rows = []
            while i < len(lines) and lines[i].lstrip().startswith("|"):
                rows.append(_row(lines[i]))
                i += 1
            cells = "".join(f"<th>{inline(c)}</th>" for c in head)
            body = "".join("<tr>" + "".join(f"<td>{inline(c)}</td>" for c in r) + "</tr>" for r in rows)
            out.append(f"<table><thead><tr>{cells}</tr></thead><tbody>{body}</tbody></table>")
            continue
        if line.strip() == "---":
            out.append("<hr>")
            i += 1
            continue
        if _marker(line):
            html_list, i = _list(lines, i)
            out.append(html_list)
            continue
        if line.lstrip().startswith(">"):
            quote = []
            while i < len(lines) and lines[i].lstrip().startswith(">"):
                quote.append(lines[i].lstrip()[1:].strip())
                i += 1
            out.append("<blockquote>" + md_to_html("\n".join(quote)) + "</blockquote>")
            continue
        # The first line always belongs to the paragraph (a stray "|" or
        # "####" is plain text), so the loop always moves on.
        para = [line.strip()]
        i += 1
        while i < len(lines) and lines[i].strip() and lines[i].strip() != "---" and not re.match(r"(#{1,3} |[-*] |\d+[.)] |>|\|)", lines[i].lstrip()):
            para.append(lines[i].strip())
            i += 1
        out.append("<p>" + inline(" ".join(para)) + "</p>")
        continue
    return "\n".join(out)


# --- documents ---------------------------------------------------------------

def render_doc(text, css="doc.css"):
    meta, body = parse_front_matter(text)
    for key in ("title", "author", "role", "lang"):
        if not meta.get(key):
            raise RenderError(f"front matter needs {key}:")
    # The title is the page's h1 already: a first "# <title>" would repeat it.
    head, _, rest = body.lstrip("\n").partition("\n")
    if head.strip() == "# " + meta["title"].strip():
        body = rest
    lang = meta["lang"] if re.fullmatch(r"[a-z]{2}", meta["lang"]) else "en"
    by = catalogue(lang).get("brand.doc.by", "{name}, {role}")
    sign = esc(by.replace("{name}", meta["author"]).replace("{role}", meta["role"]))
    metas = "".join(
        f'<meta name="brace-{k}" content="{esc(meta[k])}">\n'
        for k in ("author", "role", "meeting", "date", "doc", "phase") if meta.get(k))
    date = f'<div class="doc-date">{esc(meta["date"])}</div>\n' if meta.get("date") else ""
    return (
        "<!DOCTYPE html>\n"
        f'<html lang="{lang}">\n<head>\n<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
        f"<title>{esc(meta['title'])}</title>\n{metas}"
        f'<link rel="stylesheet" href="{esc(css)}">\n</head>\n<body>\n<main class="page">\n'
        f'<header class="doc-head">\n<div class="kicker">BRACE</div>\n<h1>{esc(meta["title"])}</h1>\n{date}</header>\n'
        f'<div class="body">\n{md_to_html(body)}\n</div>\n'
        f'<footer class="doc-sign"><span>{sign}</span><span>BRACE</span></footer>\n'
        "</main>\n</body>\n</html>\n")


# --- decks -------------------------------------------------------------------

FIELDS = {
    "cover": {"note", "meta", "eyebrow", "title", "text", "routes", "on", "foot"},
    "route": {"note", "meta", "eyebrow", "title", "lede", "why", "tagline", "sub", "foot"},
    "compare": {"note", "meta", "title", "intro", "head", "row", "foot"},
    "context": {"note", "meta", "title", "intro", "foot"},
    "refs": {"note", "meta", "title", "intro", "foot"},
    "reco": {"note", "meta", "eyebrow", "title", "lede", "item", "next", "foot"},
    "doc": {"note", "meta", "title", "intro", "ask", "foot"},
}
BLOCKS = {
    "laptop hero": {"bar", "brand", "title", "text", "cta", "caption"},
    "laptop readme": {"bar", "file", "name", "tag", "text", "caption"},
    "phone post": {"name", "handle", "text", "card", "url", "caption"},
    "phone profile": {"banner", "name", "handle", "bio", "stats", "caption"},
    "ref": {"mark", "title", "text", "take", "src"},
}
BLOCKS_IN = {"context": ("laptop hero", "laptop readme", "phone post", "phone profile"), "refs": ("ref",)}
KEY = re.compile(r"([a-z]+): (.*)\Z")


class Part:
    def __init__(self, kind):
        self.kind, self.fields, self.blocks, self.body = kind, [], [], []

    def all(self, key):
        return [v for k, v in self.fields if k == key]

    def get(self, key, default=""):
        vals = self.all(key)
        return vals[0] if vals else default


def parse_deck(text):
    meta, body = parse_front_matter(text)
    slides, slide, block = [], None, None
    for n, line in enumerate(body.split("\n"), 1):
        if line.startswith("::: "):
            kind = line[4:].strip()
            if kind not in FIELDS:
                raise RenderError(f"line {n}: unknown slide type {kind!r}")
            slide, block = Part(kind), None
            slides.append(slide)
            continue
        if slide is None:
            if line.strip():
                raise RenderError(f"line {n}: text before the first '::: <type>' line")
            continue
        if line.startswith("@"):
            kind = line[1:].strip()
            if kind not in BLOCKS_IN.get(slide.kind, ()):
                raise RenderError(f"line {n}: block {kind!r} not allowed in a {slide.kind} slide")
            block = Part(kind)
            slide.blocks.append(block)
            continue
        m = KEY.match(line)
        target = block or slide
        allowed = BLOCKS[target.kind] if block else FIELDS[slide.kind]
        if m and m.group(1) in allowed and not (slide.kind == "doc" and slide.body):
            target.fields.append((m.group(1), m.group(2).strip()))
        elif slide.kind == "doc" and block is None:
            slide.body.append(line)
        elif m:
            raise RenderError(f"line {n}: unknown field {m.group(1)!r} in {target.kind}")
        elif line.strip():
            raise RenderError(f"line {n}: expected 'field: value' in {target.kind}")
    if not slides:
        raise RenderError("no slide ('::: <type>' line)")
    return meta, slides


def _lines(value, bold="b"):
    """A title value: ' | ' separates lines."""
    return "<br>".join(inline(x.strip(), bold) for x in value.split(" | "))


def _pair(value):
    a, _, b = value.partition(" | ")
    return a.strip(), b.strip()


def _av(name):
    return esc(name.strip()[:1].upper() or "?")


def _meta(s):
    a, b = _pair(s.get("meta"))
    return f'  <div class="meta"><b>{inline(a, "b")}</b><span>{inline(b, "b")}</span></div>\n'


def _mock(b):
    i = lambda k: inline(b.get(k), "b")  # noqa: E731
    if b.kind.startswith("laptop"):
        if b.kind == "laptop hero":
            inner = (f'          <div class="hero">\n            <div class="brand">{i("brand")}</div>\n'
                     f'            <h1>{i("title")}</h1>\n'
                     + "".join(f"            <p>{inline(t, 'b')}</p>\n" for t in b.all("text"))
                     + f'            <span class="cta">{i("cta")}</span>\n          </div>\n')
        else:
            inner = (f'          <div class="readme">\n            <div class="file">{i("file")}</div>\n'
                     f'            <div class="md">\n              <h1>{i("name")}</h1>\n'
                     f'              <div class="tag">{i("tag")}</div>\n'
                     + "".join(f"              <p>{inline(t, 'b')}</p>\n" for t in b.all("text"))
                     + "            </div>\n          </div>\n")
        device = ('      <div class="laptop">\n        <div class="screen"><div class="view">\n'
                  f'          <div class="bar"><i></i><i></i><i></i>{i("bar")}</div>\n'
                  f'{inner}        </div></div>\n        <div class="base"></div>\n      </div>\n')
    else:
        if b.kind == "phone post":
            inner = (f'        <div class="post">\n          <div class="who"><div class="av">{_av(b.get("name"))}</div>'
                     f'<div><b>{i("name")}</b><span>{i("handle")}</span></div></div>\n'
                     + "".join(f"          <p>{inline(t, 'b')}</p>\n" for t in b.all("text"))
                     + f'          <div class="card"><div class="img">{i("card")}</div><div class="t">{i("url")}</div></div>\n'
                     "        </div>\n")
        else:
            inner = (f'        <div class="profile">\n          <div class="banner">{i("banner")}</div>\n'
                     f'          <div class="body">\n            <div class="av">{_av(b.get("name"))}</div>\n'
                     f'            <h3>{i("name")}</h3>\n            <div class="handle">{i("handle")}</div>\n'
                     f'            <div class="bio">{i("bio")}</div>\n            <div class="stats">{i("stats")}</div>\n'
                     "          </div>\n        </div>\n")
        device = ('      <div class="phone"><div class="in">\n        <div class="notch"></div>\n'
                  f'{inner}      </div></div>\n')
    return f'    <div>\n{device}      <div class="caption">{i("caption")}</div>\n    </div>\n'


def _slide(s, n, total, footer, t=None):
    i = lambda k: inline(s.get(k), "b")  # noqa: E731
    out = _meta(s)
    if s.kind == "cover":
        routes = [r.strip() for r in s.get("routes").split(" | ") if r.strip()]
        on = s.get("on", "1")
        spans = "".join(
            f'<span class="on">{inline(r, "b")}</span>' if str(k) == on else f"<span>{inline(r, 'b')}</span>"
            for k, r in enumerate(routes, 1))
        out += ('  <div class="cover-body">\n'
                f'    <div class="eyebrow">{i("eyebrow")}</div>\n    <h1>{_lines(s.get("title"))}</h1>\n'
                f'    <p>{i("text")}</p>\n'
                + (f'    <div class="routes">{spans}</div>\n' if routes else "")
                + "  </div>\n")
    elif s.kind == "route":
        whys = "".join(
            f"        <div><b>{inline(a, 'b')}</b><p>{inline(b, 'b')}</p></div>\n"
            for a, b in map(_pair, s.all("why")))
        label, quote = _pair(s.get("tagline"))
        out += ('  <div class="route-grid">\n    <div>\n'
                f'      <div class="eyebrow">{i("eyebrow")}</div>\n      <h2>{_lines(s.get("title"))}</h2>\n'
                f'      <p class="lede">{i("lede")}</p>\n      <div class="why">\n{whys}      </div>\n    </div>\n'
                '    <div class="tagline">\n'
                f'      <small>{inline(label, "b")}</small>\n      <blockquote>{inline(quote, "b")}</blockquote>\n'
                f'      <div class="sub">{i("sub")}</div>\n    </div>\n  </div>\n')
    elif s.kind == "compare":
        before, after = _pair(s.get("head"))
        if not s.get("head"):
            t = t or {}
            before = _cap(t.get("brand.lex.before", ""))
            after = _cap(t.get("brand.lex.after", ""))
        rows = ""
        for value in s.all("row"):
            cells = [c.strip() for c in value.split(" | ")] + ["", ""]
            rows += (f'      <tr><th>{inline(cells[0], "b")}</th><td class="before">{inline(cells[1], "b")}</td>'
                     f'<td class="after">{inline(" | ".join(cells[2:]).strip(" |"), "b")}</td></tr>\n')
        out += ('  <div class="head">\n'
                f'    <h2>{_lines(s.get("title"))}</h2>\n    <p>{i("intro")}</p>\n  </div>\n'
                '  <table class="cmp">\n'
                f'    <thead><tr><th></th><th>{inline(before, "b")}</th><th>{inline(after, "b")}</th></tr></thead>\n'
                f"    <tbody>\n{rows}    </tbody>\n  </table>\n")
    elif s.kind in ("context", "refs"):
        out += ('  <div class="head">\n'
                f'    <h2>{_lines(s.get("title"))}</h2>\n    <p>{i("intro")}</p>\n  </div>\n')
        if s.kind == "context":
            out += '  <div class="stage">\n' + "".join(_mock(b) for b in s.blocks) + "  </div>\n"
        else:
            refs = "".join(
                '    <div class="ref">\n'
                f'      <div class="mark">{inline(b.get("mark"), "b")}</div>\n'
                f'      <h3>{inline(b.get("title"), "b")}</h3>\n      <p>{inline(b.get("text"), "b")}</p>\n'
                f'      <div class="take">{inline(b.get("take"), "b")}</div>\n'
                f'      <div class="src">{inline(b.get("src"), "b")}</div>\n    </div>\n'
                for b in s.blocks)
            out += f'  <div class="grid">\n{refs}  </div>\n'
    elif s.kind == "reco":
        items = "".join(f"      <li>{inline(x, 'b')}</li>\n" for x in s.all("item"))
        a, b = _pair(s.get("next"))
        out += ('  <div class="choice">\n    <div>\n'
                f'      <div class="eyebrow">{i("eyebrow")}</div>\n      <h2>{_lines(s.get("title"))}</h2>\n'
                f'      <p class="lede">{i("lede")}</p>\n    </div>\n'
                + (f"    <ol>\n{items}    </ol>\n" if items else "")
                + "  </div>\n"
                + (f'  <div class="verdict"><b>{inline(a, "b")}</b><span>{inline(b, "b")}</span></div>\n' if a else ""))
    elif s.kind == "doc":
        body = md_to_html("\n".join(s.body)).replace("\n", "\n    ")
        out += ('  <div class="sheet">\n'
                f'    <h2>{_lines(s.get("title"))}</h2>\n    <div class="intro">{i("intro")}</div>\n'
                + (f"    {body}\n" if body else "")
                + (f'    <div class="ask">{i("ask")}</div>\n' if s.get("ask") else "")
                + "  </div>\n")
    notes = "".join(
        f'    <aside class="note"><b>{inline(who, "b")}</b> {inline(text, "b")}</aside>\n'
        for who, text in map(_pair, s.all("note")))
    if notes:
        out += f'  <div class="notes">\n{notes}  </div>\n'
    foot = s.get("foot")
    left, mid = _pair(foot) if " | " in foot else (footer, foot)
    out += (f'  <div class="foot"><span>{inline(left, "b")}</span><span>{inline(mid, "b")}</span>'
            f"<span>{n:02d} / {total:02d}</span></div>\n")
    return f'<section class="slide {s.kind}" id="s{n}">\n{out}</section>\n'


SCRIPT = """<script>
  document.addEventListener('keydown', function (e) {
    var s = Array.prototype.slice.call(document.querySelectorAll('.slide'));
    var i = s.findIndex(function (x) { return Math.abs(x.getBoundingClientRect().top) < innerHeight / 2; });
    if (['ArrowDown', 'ArrowRight', 'PageDown', ' '].indexOf(e.key) >= 0) { e.preventDefault(); s[Math.min(i + 1, s.length - 1)].scrollIntoView({ behavior: 'smooth' }); }
    if (['ArrowUp', 'ArrowLeft', 'PageUp'].indexOf(e.key) >= 0) { e.preventDefault(); s[Math.max(i - 1, 0)].scrollIntoView({ behavior: 'smooth' }); }
  });
</script>
"""


def render_deck(text, css="deck.css"):
    meta, slides = parse_deck(text)
    lang = meta.get("lang", "en")
    if not re.fullmatch(r"[a-z]{2}", lang):
        lang = "en"
    total = len(slides)
    dots = "".join(f'<a href="#s{n}"></a>' for n in range(1, total + 1))
    t = catalogue(lang)
    body = "\n".join(_slide(s, n, total, meta.get("footer", ""), t) for n, s in enumerate(slides, 1))
    return (
        "<!DOCTYPE html>\n"
        f'<html lang="{lang}">\n<head>\n<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
        f"<title>{esc(meta.get('title', ''))}</title>\n"
        f'<link rel="stylesheet" href="{esc(css)}">\n</head>\n<body>\n'
        f'<nav class="dots">{dots}</nav>\n\n{body}\n{SCRIPT}</body>\n</html>\n')


# --- command line ------------------------------------------------------------

def main(argv):
    try:
        if len(argv) == 3 and argv[0] in ("doc", "deck"):
            src, dst = Path(argv[1]), Path(argv[2])
            if not src.is_file():
                raise RenderError(f"no such file: {src}")
            try:
                text = src.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                raise RenderError(f"{src} is not UTF-8 text")
            if argv[0] == "doc":
                out = render_doc(text, css_href(dst, "doc.css"))
            else:
                out = render_deck(text, css_href(dst, "deck.css"))
            dst.parent.mkdir(parents=True, exist_ok=True)
            ensure_assets(assets_dir(dst))
            dst.write_text(out, encoding="utf-8")
            return 0
        if len(argv) == 2 and argv[0] == "space":
            root = Path(argv[1])
            dst = root / "docs" / "brace" / "brand" / "index.html"
            out = render_space(root)
            ensure_assets(assets_dir(dst))
            dst.write_text(out, encoding="utf-8")
            write_shortcut(root, space_data(root))
            return 0
        print(__doc__.strip(), file=sys.stderr)
        return 1
    except (RenderError, OSError) as e:
        print(f"render.py: {e}", file=sys.stderr)
        return 1


# The client documents and their form, as in references/documents.md
# (a test keeps the two equal). Minutes are client documents too, kept apart.
CLIENT_DOCS = {
    "proposal": "read", "brief": "read", "benchmark": "read", "personas": "presented",
    "routes": "presented", "audit": "presented", "platform": "presented",
    "editorial-guide": "read", "manifesto": "presented", "test-plan": "read",
    "transition": "read", "announcement": "read", "creative-brief": "read",
}
# The phases a mission is built from, in order ("visual" comes in a later release).
PHASES = ("contact", "framing", "strategy", "platform", "visual", "delivery")

MEETING_LEX = {"0": "contact", "1": "workshop", "2": "recommendation", "3": "platform", "4": "delivery"}


def _read(path):
    """A tracking file's text, never failing on a bad byte; "" if absent."""
    try:
        return path.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return ""


def _front(path):
    """The front matter of a tracking file, values without comment or quotes."""
    try:
        meta = parse_front_matter(_read(path))[0]
    except RenderError:
        return {}
    return {k: re.sub(r"\s+#.*$", "", v).strip().strip("\"'") for k, v in meta.items()}


def _mission(brief):
    """The first paragraph under the brief's first section: the mission."""
    m = re.search(r"(?m)^## .*\n+((?:(?!#)\S.*\n?)+)", _read(brief))
    return " ".join(m.group(1).split()) if m else ""


def _doc_info(path):
    text = path.read_text(encoding="utf-8", errors="replace")
    meta = dict(re.findall(r'<meta name="brace-([a-z]+)" content="([^"]*)">', text))
    m = re.search(r"<title>(.*?)</title>", text, re.S)
    title = html.unescape(m.group(1)) if m else path.stem
    return {k: html.unescape(v) for k, v in meta.items()}, title


def _cap(text):
    return text[:1].upper() + text[1:]


MEETING_PHASE = {"0": "contact", "1": "framing", "2": "strategy", "3": "platform", "4": "delivery"}


def _last(text, key):
    """The value of the last "- <key>: " line of SESSIONS.md, or ""."""
    found = re.findall(rf"(?m)^- {re.escape(key)}:[ \t]*(.*?)\s*$", text)
    return found[-1] if found else ""


def _section(text, key):
    """The body under the "## " heading named by catalogue key `key`, in
    English or French, up to the next "## " heading; "" when absent."""
    names = {catalogue(c).get(key, "").strip().lower() for c in ("en", "fr")} - {""}
    body, inside = [], False
    for line in text.replace("\r\n", "\n").split("\n"):
        if line.startswith("## "):
            if inside:
                break
            inside = line[3:].strip().lower() in names
            continue
        if inside:
            body.append(line)
    return "\n".join(body).strip()


def _first_paragraph(text):
    """The first plain paragraph of a section (never a list, table, quote or heading)."""
    for block in re.split(r"\n[ \t]*\n", text):
        raw = [x for x in block.split("\n") if x.strip()]
        lines = [x.strip() for x in raw]
        # An indented block is the continuation of a list item, not a paragraph.
        if lines and not raw[0][:1].isspace() and not (_marker(lines[0]) or re.match(r"(#|>|\|)", lines[0])):
            return " ".join(lines)
    return ""


def _doc_kind(path, meta):
    """(document type, date, version) of a rendered document."""
    m = re.match(r"(\d{4}-\d{2}-\d{2})-(.+)$", path.stem)
    date, rest = (m.group(1), m.group(2)) if m else ("", path.stem)
    if re.fullmatch(r"minutes(-\d+)?", rest):
        return "minutes", date, 0
    v = re.fullmatch(r"(.+?)-(\d+)", rest)
    kind, version = (v.group(1), int(v.group(2))) if v else (rest, 1)
    return meta.get("doc") or kind, date, version


def space_data(root):
    """What the client space shows, read from the project's files."""
    root = Path(root)
    brand = root / "docs" / "brace" / "brand"
    status = _front(root / "docs" / "brace" / "STATUS.md")
    sessions = _read(brand / "SESSIONS.md")
    lang = _last(sessions, "language")
    docs_dir = brand / "documents"
    if not re.fullmatch(r"[a-z]{2}", lang):
        # A mission from before the "- language:" line: its documents say it.
        for path in sorted(docs_dir.glob("*.html"), reverse=True) if docs_dir.is_dir() else ():
            m = re.search(r'<html lang="([a-z]{2})"', _read(path))
            if m:
                lang = m.group(1)
                break
    if not re.fullmatch(r"[a-z]{2}", lang):
        lang = status.get("language", "")
    if not re.fullmatch(r"[a-z]{2}", lang):
        lang = "en"
    t = catalogue(lang)
    stage = status.get("brand_stage", "")
    # Before the "- brand:" line, the brief's title carries the brand's name.
    titled = re.search(r"(?m)^# .+? \u2014 (.+?)\s*$", _read(brand / "BRIEF.md"))
    name = _last(sessions, "brand") or (titled.group(1) if titled else "") or status.get("project", "") or root.name

    mission = ""
    if stage == "done":
        mission = _first_paragraph(_section(_read(brand / "FOUNDATIONS.md"), "brand.foundations.heading.purpose"))
    if not mission:
        mission = _first_paragraph(_section(_read(brand / "BRIEF.md"), "brand.brief.heading.project"))

    # Documents: client documents only, the latest version of each type.
    latest, minutes = {}, []
    for path in sorted(docs_dir.glob("*.html")) if docs_dir.is_dir() else ():
        meta, title = _doc_info(path)
        kind, date, version = _doc_kind(path, meta)
        phase = meta.get("phase") or MEETING_PHASE.get(meta.get("meeting", ""), "")
        item = {"name": path.name, "title": title, "author": meta.get("author", ""), "phase": phase,
                "form": CLIENT_DOCS.get(kind, "read"), "date": date}
        if kind == "minutes":
            minutes.append(item)
        elif kind in CLIENT_DOCS and (kind not in latest or (date, version) >= latest[kind][0]):
            latest[kind] = ((date, version), item)
    documents = sorted((x for _, x in latest.values()),
                       key=lambda d: (PHASES.index(d["phase"]) if d["phase"] in PHASES else len(PHASES), d["date"], d["name"]))

    # Meetings: the entries marked held, named by their phase. In a mission
    # begun before plans and held lines (no "- plan:"), the entries before
    # the first held one are listed as they were; any other entry without
    # held is the team's work, not a meeting.
    entries = re.split(r"(?m)^## ", sessions)[1:]
    first = next((n for n, e in enumerate(entries) if re.search(r"(?m)^- held:", e)), len(entries))
    if _last(sessions, "plan"):
        first = 0  # a mission with a plan writes held lines from its first meeting
    meetings = [{"title": e.split("\n", 1)[0].strip(), "phase": "", "held": "", "minutes": ""}
                for e in entries[:first]]
    unused = sorted(minutes, key=lambda m: (m["date"], m["name"]))
    for e in entries[first:]:
        when = _last(e, "held")
        if not when:
            continue
        phase = _last(e, "phase")
        heading = e.split("\n", 1)[0].strip()
        title = t.get(f"brand.phase.{phase}", "") or re.sub(r"^\d{4}-\d{2}-\d{2}\s*", "", heading)
        # Its minutes: the first unused ones of its phase, dated on or after it.
        mine = next((m for m in unused if m["phase"] == phase and m["date"] >= when[:10]), None)
        if mine:
            unused.remove(mine)
        meetings.append({"title": title, "phase": phase, "held": when, "minutes": mine["name"] if mine else ""})
    loose = unused

    nxt = ""
    when = _last(sessions, "meeting")
    last_held = re.findall(r"(?m)^- held:[ \t]*(.*?)\s*$", sessions)
    try:
        at = datetime.datetime.strptime(when, "%Y-%m-%d %H:%M")
        done = datetime.datetime.strptime(last_held[-1], "%Y-%m-%d %H:%M") if last_held else None
        if at > datetime.datetime.now() and (done is None or at > done):
            nxt = when
    except ValueError:
        nxt = ""

    decks = sorted(p.name for p in (brand / "presentations").glob("*.html")
                   if p.name != "draft.html") if (brand / "presentations").is_dir() else []
    return {"lang": lang, "brand": name, "mission": mission, "next": nxt, "meetings": meetings,
            "loose_minutes": loose, "documents": documents, "decks": decks, "stage": stage,
            "delivered": stage == "done"}


# The brand at a glance, in the client space: (block title key, brand file,
# section heading key). A later release adds its own lines (logo, palette, type).
BRAND_BLOCKS = (
    ("brand.space.block.purpose", "FOUNDATIONS.md", "brand.foundations.heading.purpose"),
    ("brand.space.block.positioning", "STRATEGY.md", "brand.strategy.heading.positioning"),
    ("brand.space.block.emotion", "FOUNDATIONS.md", "brand.foundations.heading.emotion"),
    ("brand.space.block.tagline", "VOICE.md", "brand.voice.heading.tagline"),
    ("brand.space.block.lexicon", "VOICE.md", "brand.voice.heading.lexicon"),
)

TABS_SCRIPT = """<script>
  (function () {
    var tabs = Array.prototype.slice.call(document.querySelectorAll('[role="tab"]'));
    function show(tab) {
      tabs.forEach(function (t) {
        var on = t === tab;
        t.setAttribute('aria-selected', on ? 'true' : 'false');
        t.tabIndex = on ? 0 : -1;
        document.getElementById(t.getAttribute('aria-controls')).hidden = !on;
      });
    }
    tabs.forEach(function (t, i) {
      t.addEventListener('click', function () { show(t); });
      t.addEventListener('keydown', function (e) {
        var k = e.key === 'ArrowRight' ? 1 : e.key === 'ArrowLeft' ? -1 : 0;
        if (k) { var n = tabs[(i + k + tabs.length) % tabs.length]; show(n); n.focus(); }
      });
    });
    document.body.classList.add('tabbed');
    show(tabs.filter(function (t) { return t.getAttribute('aria-selected') === 'true'; })[0] || tabs[0]);
  })();
</script>
"""


def _glance(section):
    """A section in one look: its first quote (a positioning statement), else
    its first table (a tagline and its lines), else its first block."""
    blocks = [b.strip("\n") for b in re.split(r"\n[ \t]*\n(?=\S)", section.strip()) if b.strip()]
    for start in (">", "|"):
        found = [b for b in blocks if b.lstrip().startswith(start)]
        if found:
            return found[0]
    return blocks[0] if blocks else ""


def _brand_blocks(brand, t):
    """The brand at a glance: one (title, html) per brand block with content."""
    out = []
    for title_key, name, heading_key in BRAND_BLOCKS:
        body = _section(_read(brand / name), heading_key)
        if body:
            out.append((t.get(title_key, ""), md_to_html(_glance(body))))
    return out


def render_space(root):
    """The client space: tabs for home, meetings, documents, presentations
    and, once the platform is written, the brand at a glance."""
    root = Path(root)
    data = space_data(root)
    t = catalogue(data["lang"])
    none = f'<p class="none">{esc(t.get("brand.space.none", ""))}</p>'

    home = []
    if data["next"]:
        home.append(f'<h2>{esc(t.get("brand.space.next", ""))}</h2>\n<p class="next">{esc(data["next"])}</p>')
    if data["mission"]:
        home.append(f'<p class="mission">{inline(data["mission"])}</p>')

    meetings = []
    for m in data["meetings"]:
        when = f' <span class="by">{esc(m["held"])}</span>' if m["held"] else ""
        link = (f' <a href="documents/{esc(m["minutes"])}">{esc(_cap(t.get("brand.lex.minutes", "")))}</a>'
                if m["minutes"] else "")
        meetings.append(f"<li>{inline(m['title'])}{when}{link}</li>")
    meetings_html = ("<ul>" + "".join(meetings) + "</ul>") if meetings else ""
    if data["loose_minutes"]:
        meetings_html += "<ul>" + "".join(
            f'<li><a href="documents/{esc(m["name"])}">{esc(m["title"])}</a></li>' for m in data["loose_minutes"]) + "</ul>"

    documents, phase = [], None
    for d in data["documents"]:
        if d["phase"] != phase:
            if phase is not None:
                documents.append("</ul>")
            phase = d["phase"]
            label = t.get(f"brand.phase.{phase}", "")
            documents.append((f"<h3>{esc(label)}</h3>" if label else "") + "<ul>")
        by = f' <span class="by">{esc(d["author"])}</span>' if d["author"] else ""
        documents.append(f'<li><a href="documents/{esc(d["name"])}">{esc(d["title"])}</a>{by}</li>')
    if documents:
        documents.append("</ul>")

    decks = "".join(f'<li><a href="presentations/{esc(x)}">{esc(x[:-5])}</a></li>' for x in data["decks"])
    blocks = _brand_blocks(root / "docs" / "brace" / "brand", t)

    panels = [("home", "\n".join(home)), ("meetings", meetings_html),
              ("documents", "\n".join(documents)), ("presentations", f"<ul>{decks}</ul>" if decks else "")]
    if blocks:
        panels.append(("brand", "\n".join(
            f'<div class="block"><h3>{esc(title)}</h3>\n{body}</div>' for title, body in blocks)))
    selected = "brand" if blocks and data["delivered"] else "home"
    tabs = "".join(
        f'<button role="tab" id="tab-{name}" aria-controls="p-{name}" '
        f'aria-selected="{"true" if name == selected else "false"}">{esc(t.get(f"brand.space.tab.{name}", name))}</button>'
        for name, _ in panels)
    sections = "\n".join(
        f'<section class="panel" role="tabpanel" id="p-{name}" aria-labelledby="tab-{name}">\n'
        f'<h2 class="panel-title">{esc(t.get(f"brand.space.tab.{name}", name))}</h2>\n{body or none}\n</section>'
        for name, body in panels)

    title = t.get("brand.space.title", "{project}").replace("{project}", data["brand"])
    return (
        "<!DOCTYPE html>\n"
        f'<html lang="{data["lang"]}">\n<head>\n<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
        f"<title>{esc(title)}</title>\n"
        '<link rel="stylesheet" href="doc.css">\n</head>\n<body>\n<main class="page">\n'
        f'<header class="doc-head">\n<div class="kicker">BRACE</div>\n<h1>{esc(title)}</h1>\n</header>\n'
        f'<nav class="tabs" role="tablist">{tabs}</nav>\n'
        f'<div class="body space">\n{sections}\n</div>\n</main>\n{TABS_SCRIPT}</body>\n</html>\n')


SHORTCUT_TARGET = "docs/brace/brand/index.html"
SHORTCUT_MARK = f'content="0; url={SHORTCUT_TARGET}"'


def _shortcut_name(root, data):
    """The shortcut's file name: the brand's name, cleaned for a file system."""
    def clean(text):
        text = re.sub(r'[/\\:*?"<>|\x00-\x1f\x7f]', "", text)
        return " ".join(text.split()).strip(" .")
    name = clean(data["brand"]) or clean(Path(root).name) or "brand"
    short = catalogue(data["lang"]).get("brand.space.short", "client space")
    return f"{name} - {short}.html"


def _exclude_line(name):
    """A file at the repository's root, as a literal gitignore pattern."""
    return "/" + re.sub(r'([\\\[\]!#*?])', r"\\\1", name)


def _exclude(root, add=(), drop=()):
    """Add or drop lines of .git/info/exclude, only when .git is a folder."""
    git = Path(root) / ".git"
    if not git.is_dir():
        return
    path = git / "info" / "exclude"
    lines = _read(path).split("\n") if path.is_file() else []
    kept = [x for x in lines if x not in drop]
    kept += [x for x in add if x not in kept]
    while kept and not kept[-1]:
        kept.pop()
    if kept != [x for x in lines if x] or drop:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text("\n".join(kept) + ("\n" if kept else ""), encoding="utf-8")


def write_shortcut(root, data):
    """During the mission, a small page at the project root that opens the
    client space (a redirect, not a link: file:// resolves relative paths
    from the link itself); removed once the brand is delivered. Kept out of
    git through .git/info/exclude, never the client's .gitignore."""
    root = Path(root)
    old = [p for p in root.glob("*.html") if p.is_file() and SHORTCUT_MARK in _read(p)]
    name = None if data["delivered"] else _shortcut_name(root, data)
    for p in old:
        if p.name != name:
            p.unlink()
    _exclude(root, drop=[_exclude_line(p.name) for p in old if p.name != name])
    if name is None:
        return None
    target = root / name
    target.write_text(
        "<!DOCTYPE html>\n"
        f'<html lang="{data["lang"]}">\n<head>\n<meta charset="utf-8">\n'
        f'<meta http-equiv="refresh" {SHORTCUT_MARK}>\n'
        f"<title>{esc(name[:-5])}</title>\n</head>\n<body>\n"
        f'<p><a href="{SHORTCUT_TARGET}">{esc(name[:-5])}</a></p>\n</body>\n</html>\n', encoding="utf-8")
    _exclude(root, add=[_exclude_line(name)])
    return target


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
