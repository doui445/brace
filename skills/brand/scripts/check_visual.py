#!/usr/bin/env python3
"""Measurable checks on a brand's visual files. Stdlib only.

Usage:
  check_visual.py contrast <fg> <bg>   print the WCAG contrast ratio, as 4.5:1
  check_visual.py brand <dir>          list the problems of a brand folder;
                                       exit 1 when there is any

A brand folder holds logo.svg (and its variants), fonts with their licence
next to them, and brand.css, whose colour pairs to check are declared in
comments: /* pair: --ink on --paper */ (4.5:1), or with "large" (3:1)."""
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

HEX = re.compile(r"#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})\Z")
FONTS = ("*.ttf", "*.otf", "*.woff", "*.woff2")
LICENCES = ("OFL.txt", "OFL*", "LICENSE*", "LICENCE*")
# A logo is inlined into a deck: only plain drawing survives. Anything that
# can run, load or hide markup from the parser is refused.
ALLOWED = {"svg", "g", "path", "rect", "circle", "ellipse", "line", "polyline", "polygon",
           "text", "tspan", "textPath", "defs", "use", "symbol", "title", "desc",
           "linearGradient", "radialGradient", "stop", "clipPath", "mask", "pattern"}
SVG_NS = "http://www.w3.org/2000/svg"
XLINK_NS = "http://www.w3.org/1999/xlink"
URL = re.compile(r"url\(\s*['\"]?\s*([^)'\"\s]*)", re.I)


def _rgb(colour):
    if not HEX.match(colour or ""):
        raise ValueError(f"not a hex colour: {colour!r}")
    h = colour[1:]
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    return [int(h[i:i + 2], 16) / 255 for i in (0, 2, 4)]


def _luminance(colour):
    lin = [c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4 for c in _rgb(colour)]
    return 0.2126 * lin[0] + 0.7152 * lin[1] + 0.0722 * lin[2]


def contrast(fg, bg):
    """The WCAG 2 contrast ratio of two hex colours, rounded to 2 decimals."""
    a, b = sorted((_luminance(fg), _luminance(bg)), reverse=True)
    return round((a + 0.05) / (b + 0.05), 2)


def _parse_svg(path):
    """(root, problems) of an SVG file: root is None when it is refused
    before parsing (a DOCTYPE, an entity, a processing instruction)."""
    path = Path(path)
    try:
        raw = path.read_bytes()
    except OSError as e:
        return None, [f"{path.name}: not readable ({e})"]
    head = raw.decode("utf-8", errors="replace")
    if re.search(r"<!DOCTYPE|<!ENTITY", head, re.I):
        return None, [f"{path.name}: a DOCTYPE or ENTITY is not allowed"]
    if re.search(r"<\?(?!xml[\s?])", head):
        return None, [f"{path.name}: a processing instruction is not allowed"]
    try:
        return ET.fromstring(raw), []
    except ET.ParseError as e:
        return None, [f"{path.name}: not a valid SVG ({e})"]


def svg_problems(path):
    """What makes an SVG unsafe or unfit to inline: invalid XML, a DOCTYPE,
    an entity or processing instruction, an element outside plain drawing,
    an event attribute, a link or url() outside the file, javascript:, no
    viewBox."""
    path = Path(path)
    root, problems = _parse_svg(path)
    if root is None:
        return problems
    for el in root.iter():
        tag = el.tag.rsplit("}", 1)[-1]
        ns = el.tag[1:].split("}", 1)[0] if el.tag.startswith("{") else ""
        if tag not in ALLOWED or ns not in ("", SVG_NS):
            problems.append(f"{path.name}: <{tag}> is not allowed")
        for key, value in el.attrib.items():
            name = key.rsplit("}", 1)[-1]
            low = value.lower().replace(" ", "")
            if name.lower().startswith("on"):
                problems.append(f"{path.name}: event attribute {name} is not allowed")
            if name in ("href", "src") and not value.startswith("#"):
                problems.append(f"{path.name}: link outside the file ({value})")
            if "javascript:" in low or "data:" in low:
                problems.append(f"{path.name}: {name} carries a script or data URL")
            for target in URL.findall(value):
                if not target.startswith("#"):
                    problems.append(f"{path.name}: url() outside the file ({target})")
    if root.tag.rsplit("}", 1)[-1] != "svg":
        problems.append(f"{path.name}: the root element is not <svg>")
    if "viewBox" not in root.attrib:
        problems.append(f"{path.name}: no viewBox, the logo will not scale")
    return problems


SHAPES = {"path", "rect", "circle", "ellipse", "line", "polyline", "polygon"}
FAVICON_MAX_SHAPES = 12
TAB = "#ffffff"  # a favicon without its own background sits on a light tab


def _num(value, default=0.0):
    m = re.match(r"\s*(-?[\d.]+)", value or "")
    return float(m.group(1)) if m else default


def _style(el, key):
    m = re.search(rf"(?:^|;)\s*{key}\s*:\s*([^;]+)", el.attrib.get("style", ""))
    return (m.group(1).strip() if m else el.attrib.get(key, "")).strip()


def favicon_problems(path):
    """Why a favicon would not read at 16 px: a stroke or a shape under one
    pixel once scaled, text, too many shapes, a colour without contrast
    against its own background (or a light tab when it has none)."""
    path = Path(path)
    root, problems = _parse_svg(path)
    if root is None:
        return problems
    box = [_num(x) for x in root.attrib.get("viewBox", "").replace(",", " ").split()]
    if len(box) != 4 or max(box[2:]) <= 0:
        return [f"{path.name}: no viewBox, the favicon cannot be checked at 16 px"]
    w, h = box[2], box[3]
    scale = 16 / max(w, h)
    shapes, bg = [], TAB
    for el in root.iter():
        tag = el.tag.rsplit("}", 1)[-1]
        if tag in ("text", "tspan", "textPath"):
            problems.append(f"{path.name}: text in the favicon is unreadable at 16 px; use the symbol")
        if tag not in SHAPES:
            continue
        fill = _style(el, "fill")
        if (tag == "rect" and not shapes and _num(el.attrib.get("x")) <= 0 and _num(el.attrib.get("y")) <= 0
                and _num(el.attrib.get("width")) >= w and _num(el.attrib.get("height")) >= h and HEX.match(fill)):
            bg = fill  # the favicon's own background
            continue
        shapes.append(el)
    if len(shapes) > FAVICON_MAX_SHAPES:
        problems.append(f"{path.name}: too much detail for 16 px ({len(shapes)} shapes)")
    for el in shapes:
        tag = el.tag.rsplit("}", 1)[-1]
        stroke = _style(el, "stroke")
        if stroke and stroke != "none" and _num(_style(el, "stroke-width"), 1.0) * scale < 1:
            problems.append(f"{path.name}: a <{tag}> stroke is under 1 px at 16 px")
        size = {"circle": 2 * _num(el.attrib.get("r"), 99), "ellipse": 2 * min(_num(el.attrib.get("rx"), 99), _num(el.attrib.get("ry"), 99)),
                "rect": min(_num(el.attrib.get("width"), 99), _num(el.attrib.get("height"), 99))}.get(tag)
        if size is not None and size * scale < 1:
            problems.append(f"{path.name}: a <{tag}> is under 1 px at 16 px")
        for colour in (_style(el, "fill"), stroke):
            if HEX.match(colour or "") and contrast(colour, bg) < 3:
                problems.append(f"{path.name}: {colour} on {bg} has too little contrast for a tab icon "
                                f"({contrast(colour, bg)}:1, needs 3:1)")
    return list(dict.fromkeys(problems))


def clean_svg(path):
    """The SVG as parsed and serialised again (comments and declarations
    gone), for inlining; call svg_problems first."""
    root, problems = _parse_svg(path)
    if root is None:
        raise ValueError("; ".join(problems))
    ET.register_namespace("", SVG_NS)
    ET.register_namespace("xlink", XLINK_NS)
    return ET.tostring(root, encoding="unicode")


def _css_vars(text):
    return dict(re.findall(r"(--[\w-]+)\s*:\s*(#[0-9a-fA-F]{3,6})\b", text))


def check_brand(brand_dir):
    """Every problem of a brand folder, readable; [] when all is well."""
    d = Path(brand_dir)
    problems = []
    if not (d / "logo.svg").is_file():
        problems.append("logo.svg is missing")
    for svg in sorted(d.rglob("*.svg")):
        problems += svg_problems(svg)
    for fav in sorted(d.rglob("favicon*.svg")):
        problems += favicon_problems(fav)
    for pattern in FONTS:
        for font in sorted(d.rglob(pattern)):
            if not any(next(font.parent.glob(lic), None) for lic in LICENCES):
                problems.append(f"{font.relative_to(d)}: no licence file next to the font")
    css = d / "brand.css"
    if css.is_file():
        text = css.read_text(encoding="utf-8", errors="replace")
        values = _css_vars(text)
        for fg, bg, large in re.findall(r"pair:\s*(--[\w-]+)\s+on\s+(--[\w-]+)(\s+large)?", text):
            missing = [v for v in (fg, bg) if v not in values]
            if missing:
                problems.append(f"brand.css: pair {fg} on {bg}: no hex value for {', '.join(missing)}")
                continue
            need = 3.0 if large else 4.5
            try:
                ratio = contrast(values[fg], values[bg])
            except ValueError as e:
                problems.append(f"brand.css: pair {fg} on {bg}: {e}")
                continue
            if ratio < need:
                problems.append(f"brand.css: {fg} on {bg} is {ratio}:1, needs {need}:1")
    return problems


def main(argv):
    try:
        if len(argv) == 3 and argv[0] == "contrast":
            print(f"{contrast(argv[1], argv[2])}:1")
            return 0
        if len(argv) == 2 and argv[0] == "brand":
            problems = check_brand(argv[1])
            for p in problems:
                print(p)
            return 1 if problems else 0
    except ValueError as e:
        print(f"check_visual.py: {e}", file=sys.stderr)
        return 1
    print(__doc__.strip(), file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
