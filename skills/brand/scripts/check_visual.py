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
FORBIDDEN = ("script", "foreignObject")


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


def svg_problems(path):
    """What makes an SVG unsafe or unfit to inline: invalid XML, a script,
    an event attribute, a link outside the file, no viewBox."""
    path = Path(path)
    try:
        root = ET.parse(path).getroot()
    except (ET.ParseError, OSError) as e:
        return [f"{path.name}: not a valid SVG ({e})"]
    problems = []
    for el in root.iter():
        tag = el.tag.rsplit("}", 1)[-1]
        if tag in FORBIDDEN:
            problems.append(f"{path.name}: <{tag}> is not allowed")
        for key, value in el.attrib.items():
            name = key.rsplit("}", 1)[-1]
            if name.lower().startswith("on"):
                problems.append(f"{path.name}: event attribute {name} is not allowed")
            if name == "href" and not value.startswith("#"):
                problems.append(f"{path.name}: link outside the file ({value})")
    if root.tag.rsplit("}", 1)[-1] != "svg":
        problems.append(f"{path.name}: the root element is not <svg>")
    if "viewBox" not in root.attrib:
        problems.append(f"{path.name}: no viewBox, the logo will not scale")
    return problems


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
            ratio = contrast(values[fg], values[bg])
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
