"""Tests for skills/brand/scripts/check_visual.py.
Run: python3 -m unittest discover -s skills/brand/scripts -p 'test_*.py'"""
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import check_visual  # noqa: E402
import render  # noqa: E402

GOOD_SVG = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10"><circle cx="5" cy="5" r="4"/></svg>'


class ContrastTests(unittest.TestCase):
    def test_contrast_black_white(self):
        self.assertEqual(check_visual.contrast("#000", "#fff"), 21.0)

    def test_contrast_is_symmetric(self):
        self.assertEqual(check_visual.contrast("#fff", "#000"), 21.0)

    def test_contrast_mid(self):
        self.assertAlmostEqual(check_visual.contrast("#777777", "#ffffff"), 4.48, places=2)

    def test_bad_colour(self):
        for bad in ("red", "#12", "#gggggg", ""):
            with self.assertRaises(ValueError):
                check_visual.contrast(bad, "#fff")


class SvgTests(unittest.TestCase):
    def setUp(self):
        self._d = tempfile.TemporaryDirectory()
        self.addCleanup(self._d.cleanup)
        self.dir = Path(self._d.name)

    def svg(self, text, name="a.svg"):
        p = self.dir / name
        p.write_text(text, encoding="utf-8")
        return p

    def test_good_svg(self):
        self.assertEqual(check_visual.svg_problems(self.svg(GOOD_SVG)), [])

    def test_hostile_svgs(self):
        bad = {
            "script": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"><script>x</script></svg>',
            "on": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1" onload="x"/>',
            "href": '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 1 1">'
                    '<use xlink:href="http://e.x/a.svg#a"/></svg>',
            "foreign": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"><foreignObject/></svg>',
            "xml": '<svg><unclosed></svg>',
            "pi": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"><?foo > <img src=x onerror=alert(1)> ?></svg>',
            "doctype": '<!DOCTYPE svg [<!ENTITY a "> <img src=x onerror=alert(2)>">]><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"/>',
            "animate": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"><a><animate attributeName="href" values="javascript:alert(3)"/></a></svg>',
            "style-import": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"><style>@import url(https://e.x/a.css);</style></svg>',
            "embed": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"><embed src="https://e.x/a"/></svg>',
            "url-attr": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"><rect fill="url(https://e.x/a#b)"/></svg>',
        }
        for why, text in bad.items():
            with self.subTest(why):
                self.assertTrue(check_visual.svg_problems(self.svg(text)))

    def test_gradient_reference_is_fine(self):
        text = ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"><defs><linearGradient id="g">'
                '<stop offset="0" stop-color="#000"/></linearGradient></defs><rect fill="url(#g)"/></svg>')
        self.assertEqual(check_visual.svg_problems(self.svg(text)), [])

    def test_xml_declaration_is_fine(self):
        self.assertEqual(check_visual.svg_problems(self.svg('<?xml version="1.0" encoding="UTF-8"?>' + GOOD_SVG)), [])

    def test_internal_href_is_fine(self):
        text = ('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 1 1">'
                '<defs><circle id="c" r="1"/></defs><use xlink:href="#c"/></svg>')
        self.assertEqual(check_visual.svg_problems(self.svg(text)), [])

    def test_missing_viewbox(self):
        self.assertIn("viewBox", "\n".join(check_visual.svg_problems(self.svg('<svg xmlns="http://www.w3.org/2000/svg"/>'))))


FAV = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">{}</svg>'


class FaviconTests(unittest.TestCase):
    def setUp(self):
        self._d = tempfile.TemporaryDirectory()
        self.addCleanup(self._d.cleanup)

    def fav(self, inner):
        p = Path(self._d.name) / "favicon.svg"
        p.write_text(FAV.format(inner), encoding="utf-8")
        return check_visual.favicon_problems(p)

    def test_good_favicon(self):
        self.assertEqual(self.fav('<circle cx="16" cy="16" r="12" fill="#1F2A44"/>'), [])

    def test_thin_stroke(self):
        # 1.5 units on a 32-unit box is 0.75 px at 16 px: it vanishes.
        probs = "\n".join(self.fav('<circle cx="16" cy="16" r="12" fill="none" stroke="#000" stroke-width="1.5"/>'))
        self.assertIn("16 px", probs)

    def test_text_in_favicon(self):
        self.assertIn("text", "\n".join(self.fav('<text x="2" y="20" fill="#000">tally</text>')))

    def test_too_many_shapes(self):
        shapes = "".join(f'<rect x="{i}" y="0" width="1" height="32" fill="#000"/>' for i in range(0, 30, 2))
        self.assertIn("detail", "\n".join(self.fav(shapes)))

    def test_tiny_dot(self):
        self.assertIn("16 px", "\n".join(self.fav('<circle cx="16" cy="16" r="0.8" fill="#000"/>')))

    def test_low_contrast_on_white(self):
        self.assertIn("contrast", "\n".join(self.fav('<circle cx="16" cy="16" r="12" fill="#eeeeee"/>')))

    def test_contrast_against_own_background(self):
        inner = '<rect x="0" y="0" width="32" height="32" fill="#1F2A44"/><circle cx="16" cy="16" r="8" fill="#ffffff"/>'
        self.assertEqual(self.fav(inner), [])


class BrandTests(unittest.TestCase):
    def brand(self, svgs=None, fonts=None, css=None):
        self._d = tempfile.TemporaryDirectory()
        self.addCleanup(self._d.cleanup)
        d = Path(self._d.name) / "brand"
        d.mkdir()
        for name, text in (svgs or {}).items():
            (d / name).write_text(text, encoding="utf-8")
        for name, data in (fonts or {}).items():
            (d / name).parent.mkdir(parents=True, exist_ok=True)
            (d / name).write_bytes(data)
        if css is not None:
            (d / "brand.css").write_text(css, encoding="utf-8")
        return d

    def test_brand_ok(self):
        d = self.brand(svgs={"logo.svg": GOOD_SVG},
                       fonts={"fonts/x/X.ttf": b"0", "fonts/x/OFL.txt": b"licence"},
                       css="/* pair: --ink on --paper */\n:root { --ink: #000; --paper: #fff; }\n")
        self.assertEqual(check_visual.check_brand(d), [])

    def test_brand_problems(self):
        d = self.brand(svgs={"mark.svg": '<svg xmlns="http://www.w3.org/2000/svg"/>'},
                       fonts={"fonts/x/X.ttf": b"0"},
                       css="/* pair: --a on --b */\n:root { --a: #777; --b: #fff; }\n")
        probs = "\n".join(check_visual.check_brand(d))
        for needle in ("logo.svg", "viewBox", "licence", "4.5"):
            self.assertIn(needle, probs)

    def test_brand_checks_the_favicon(self):
        d = self.brand(svgs={"logo.svg": GOOD_SVG,
                             "favicon.svg": FAV.format('<text x="2" y="20" fill="#000">t</text>')})
        self.assertIn("favicon.svg", "\n".join(check_visual.check_brand(d)))

    def test_large_pair_needs_three(self):
        d = self.brand(svgs={"logo.svg": GOOD_SVG},
                       css="/* pair: --a on --b large */\n:root { --a: #777; --b: #fff; }\n")
        self.assertEqual(check_visual.check_brand(d), [])

    def test_bad_hex_reports_the_pair_and_goes_on(self):
        d = self.brand(css="/* pair: --a on --b */\n:root { --a: #abcd; --b: #fff; }\n")
        probs = "\n".join(check_visual.check_brand(d))
        self.assertIn("--a", probs)
        self.assertIn("logo.svg", probs)  # the other checks still ran

    def test_pair_with_unknown_variable(self):
        d = self.brand(svgs={"logo.svg": GOOD_SVG}, css="/* pair: --a on --zz */\n:root { --a: #000; }\n")
        self.assertIn("--zz", "\n".join(check_visual.check_brand(d)))

    def test_cli(self):
        d = self.brand(svgs={"mark.svg": GOOD_SVG})
        script = HERE / "check_visual.py"
        r = subprocess.run([sys.executable, str(script), "brand", str(d)], capture_output=True, text=True)
        self.assertEqual(r.returncode, 1)
        self.assertIn("logo.svg", r.stdout)
        r = subprocess.run([sys.executable, str(script), "contrast", "#000", "#fff"], capture_output=True, text=True)
        self.assertEqual((r.returncode, r.stdout.strip()), (0, "21.0:1"))


class IgnoreSourcesTests(unittest.TestCase):
    def test_gitignore_created_and_idempotent(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            render.ignore_sources(root)
            render.ignore_sources(root)
            self.assertEqual((root / ".gitignore").read_text(encoding="utf-8").count("/brand/sources/"), 1)

    def test_gitignore_kept_and_appended(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            (root / ".gitignore").write_text("node_modules/", encoding="utf-8")
            render.ignore_sources(root)
            self.assertEqual((root / ".gitignore").read_text(encoding="utf-8"), "node_modules/\n/brand/sources/\n")

    def test_sources_command(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            r = subprocess.run([sys.executable, str(HERE / "render.py"), "sources", str(root)],
                               capture_output=True, text=True)
            self.assertEqual(r.returncode, 0, r.stderr)
            self.assertIn("/brand/sources/", (root / ".gitignore").read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
