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
        }
        for why, text in bad.items():
            with self.subTest(why):
                self.assertTrue(check_visual.svg_problems(self.svg(text)))

    def test_internal_href_is_fine(self):
        text = ('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 1 1">'
                '<defs><circle id="c" r="1"/></defs><use xlink:href="#c"/></svg>')
        self.assertEqual(check_visual.svg_problems(self.svg(text)), [])

    def test_missing_viewbox(self):
        self.assertIn("viewBox", "\n".join(check_visual.svg_problems(self.svg('<svg xmlns="http://www.w3.org/2000/svg"/>'))))


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

    def test_large_pair_needs_three(self):
        d = self.brand(svgs={"logo.svg": GOOD_SVG},
                       css="/* pair: --a on --b large */\n:root { --a: #777; --b: #fff; }\n")
        self.assertEqual(check_visual.check_brand(d), [])

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


class ExcludeSourcesTests(unittest.TestCase):
    def test_exclude_sources_idempotent(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            subprocess.run(["git", "init", "-q", str(root)], check=True)
            render.exclude_sources(root)
            render.exclude_sources(root)
            text = (root / ".git" / "info" / "exclude").read_text(encoding="utf-8")
            self.assertEqual(text.count("/brand/sources/"), 1)

    def test_sources_command(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            subprocess.run(["git", "init", "-q", str(root)], check=True)
            r = subprocess.run([sys.executable, str(HERE / "render.py"), "sources", str(root)],
                               capture_output=True, text=True)
            self.assertEqual(r.returncode, 0, r.stderr)
            self.assertIn("/brand/sources/", (root / ".git" / "info" / "exclude").read_text(encoding="utf-8"))

    def test_exclude_sources_outside_git(self):
        with tempfile.TemporaryDirectory() as d:
            render.exclude_sources(Path(d))
            self.assertFalse((Path(d) / ".git").exists())


if __name__ == "__main__":
    unittest.main()
