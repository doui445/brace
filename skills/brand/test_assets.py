"""Tests for the brand presentation template in skills/brand/assets/.
Run: python3 -m unittest discover -s skills/brand -p 'test_*.py'"""
import re
import unittest
from pathlib import Path

ASSETS = Path(__file__).resolve().parent / "assets"
SLIDES = ("cover", "route", "compare", "context", "refs", "reco", "doc")
MOCKUPS = ("laptop", "phone", "post", "readme", "hero", "profile")


class DeckTemplateTests(unittest.TestCase):
    def setUp(self):
        self.css = (ASSETS / "deck.css").read_text(encoding="utf-8")
        self.html = (ASSETS / "example.html").read_text(encoding="utf-8")

    def test_every_css_url_points_at_a_shipped_file(self):
        urls = re.findall(r"url\(\s*['\"]?([^'\")]+)['\"]?\s*\)", self.css)
        self.assertTrue(urls)
        for u in urls:
            self.assertTrue((ASSETS / u).is_file(), u)

    def test_works_offline(self):
        for name, text in (("deck.css", self.css), ("example.html", self.html)):
            self.assertNotRegex(text, r"https?://", name)
            self.assertNotRegex(text, r"(?:src|href|url\()\s*=?\s*['\"]?//", name)

    def test_pages_print_as_slides(self):
        self.assertRegex(self.css, r"@page\s*\{[^}]*size:\s*1440px\s+900px")
        self.assertIn('<link rel="stylesheet" href="deck.css">', self.html)

    def test_every_class_is_styled_and_shown(self):
        for cls in SLIDES + MOCKUPS:
            self.assertRegex(self.css, r"\." + cls + r"\b", cls)
            self.assertRegex(self.html, r'class="[^"]*\b' + cls + r'\b', cls)
        for cls in SLIDES:
            self.assertRegex(self.html, r'class="slide ' + cls + r'\b', cls)

    def test_each_font_family_ships_its_licence(self):
        fams = [d for d in (ASSETS / "fonts").iterdir() if d.is_dir()]
        self.assertEqual(sorted(d.name for d in fams), ["fraunces", "inter"])
        for d in fams:
            self.assertTrue((d / "OFL.txt").is_file(), d)
            self.assertTrue(list(d.glob("*.ttf")), d)

    def test_no_em_dash(self):
        self.assertNotIn("—", self.html)
        self.assertNotIn("—", self.css)


if __name__ == "__main__":
    unittest.main()
