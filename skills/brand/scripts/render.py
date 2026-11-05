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
import html
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


def ensure_assets(dst_dir):
    """Copy the house stylesheets and fonts next to an output, if missing."""
    dst_dir = Path(dst_dir)
    dst_dir.mkdir(parents=True, exist_ok=True)
    for name in ("deck.css", "doc.css"):
        if not (dst_dir / name).exists():
            shutil.copy2(ASSETS / name, dst_dir / name)
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

        def link(m):
            label, url = m.group(1), html.unescape(m.group(2))
            if not SAFE_URL.match(url):
                return label
            return f'<a href="{esc(url)}">{label}</a>'

        s = re.sub(r"\[([^\]]+)\]\(([^)\s]+)\)", link, s)
        s = re.sub(r"\*\*(.+?)\*\*", rf"<{bold}>\1</{bold}>", s)
        s = re.sub(r"(?<![*\w])\*(?!\s)(.+?)(?<!\s)\*(?![*\w])", r"<em>\1</em>", s)
        out.append(s)
    return "".join(out)


def _row(line):
    return [c.strip() for c in line.strip().strip("|").split("|")]


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
        for pat, tag in ((r"[-*] (.*)", "ul"), (r"\d+[.)] (.*)", "ol")):
            if re.match(pat, line.lstrip()):
                items = []
                while i < len(lines) and re.match(pat, lines[i].lstrip()):
                    items.append(re.match(pat, lines[i].lstrip()).group(1))
                    i += 1
                out.append(f"<{tag}>" + "".join(f"<li>{inline(x)}</li>" for x in items) + f"</{tag}>")
                break
        else:
            if line.startswith(">"):
                quote = []
                while i < len(lines) and lines[i].startswith(">"):
                    quote.append(lines[i][1:].strip())
                    i += 1
                out.append("<blockquote>" + md_to_html("\n".join(quote)) + "</blockquote>")
                continue
            para = []
            while i < len(lines) and lines[i].strip() and not re.match(r"(#{1,3} |[-*] |\d+[.)] |>|\|)", lines[i].lstrip()):
                para.append(lines[i].strip())
                i += 1
            out.append("<p>" + inline(" ".join(para)) + "</p>")
            continue
    return "\n".join(out)


# --- documents ---------------------------------------------------------------

def render_doc(text):
    meta, body = parse_front_matter(text)
    for key in ("title", "author", "role", "lang"):
        if not meta.get(key):
            raise RenderError(f"front matter needs {key}:")
    lang = meta["lang"] if re.fullmatch(r"[a-z]{2}", meta["lang"]) else "en"
    by = catalogue(lang).get("brand.doc.by", "{name}, {role}")
    sign = esc(by.replace("{name}", meta["author"]).replace("{role}", meta["role"]))
    metas = "".join(
        f'<meta name="brace-{k}" content="{esc(meta[k])}">\n'
        for k in ("author", "role", "meeting", "date") if meta.get(k))
    date = f'<div class="doc-date">{esc(meta["date"])}</div>\n' if meta.get("date") else ""
    return (
        "<!DOCTYPE html>\n"
        f'<html lang="{lang}">\n<head>\n<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
        f"<title>{esc(meta['title'])}</title>\n{metas}"
        '<link rel="stylesheet" href="doc.css">\n</head>\n<body>\n<main class="page">\n'
        f'<header class="doc-head">\n<div class="kicker">BRACE</div>\n<h1>{esc(meta["title"])}</h1>\n{date}</header>\n'
        f'<div class="body">\n{md_to_html(body)}\n</div>\n'
        f'<footer class="doc-sign"><span>{sign}</span><span>BRACE</span></footer>\n'
        "</main>\n</body>\n</html>\n")


# --- decks -------------------------------------------------------------------

FIELDS = {
    "cover": {"meta", "eyebrow", "title", "text", "routes", "on", "foot"},
    "route": {"meta", "eyebrow", "title", "lede", "why", "tagline", "sub", "foot"},
    "context": {"meta", "title", "intro", "foot"},
    "refs": {"meta", "title", "intro", "foot"},
    "reco": {"meta", "eyebrow", "title", "lede", "item", "next", "foot"},
    "doc": {"meta", "title", "intro", "ask", "foot"},
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


def _slide(s, n, total, footer):
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


def render_deck(text):
    meta, slides = parse_deck(text)
    lang = meta.get("lang", "en")
    if not re.fullmatch(r"[a-z]{2}", lang):
        lang = "en"
    total = len(slides)
    dots = "".join(f'<a href="#s{n}"></a>' for n in range(1, total + 1))
    body = "\n".join(_slide(s, n, total, meta.get("footer", "")) for n, s in enumerate(slides, 1))
    return (
        "<!DOCTYPE html>\n"
        f'<html lang="{lang}">\n<head>\n<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
        f"<title>{esc(meta.get('title', ''))}</title>\n"
        '<link rel="stylesheet" href="deck.css">\n</head>\n<body>\n'
        f'<nav class="dots">{dots}</nav>\n\n{body}\n{SCRIPT}</body>\n</html>\n')


# --- command line ------------------------------------------------------------

def main(argv):
    try:
        if len(argv) == 3 and argv[0] in ("doc", "deck"):
            src, dst = Path(argv[1]), Path(argv[2])
            if not src.is_file():
                raise RenderError(f"no such file: {src}")
            text = src.read_text(encoding="utf-8")
            out = render_doc(text) if argv[0] == "doc" else render_deck(text)
            ensure_assets(dst.parent)
            dst.write_text(out, encoding="utf-8")
            return 0
        if len(argv) == 2 and argv[0] == "space":
            root = Path(argv[1])
            dst = root / "docs" / "brace" / "brand" / "index.html"
            out = render_space(root)
            ensure_assets(dst.parent)
            dst.write_text(out, encoding="utf-8")
            return 0
        print(__doc__.strip(), file=sys.stderr)
        return 1
    except RenderError as e:
        print(f"render.py: {e}", file=sys.stderr)
        return 1


def render_space(root):
    raise RenderError("the client space is not available yet")


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
