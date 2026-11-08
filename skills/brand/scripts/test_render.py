"""Tests for skills/brand/scripts/render.py.
Run: python3 -m unittest discover -s skills/brand/scripts -p 'test_*.py'"""
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import render  # noqa: E402

ASSETS = HERE.parent / "assets"
SCRIPT = HERE / "render.py"


def doc(body, **fm):
    meta = {"title": "Benchmark", "author": "Bruno", "role": "research analyst",
            "lang": "en", "meeting": "2", "date": "2026-11-05"}
    meta.update(fm)
    head = "".join(f"{k}: {v}\n" for k, v in meta.items())
    return f"---\n{head}---\n\n{body}\n"


def run(*args):
    return subprocess.run([sys.executable, str(SCRIPT), *args], capture_output=True, text=True)


class RenderDeckTests(unittest.TestCase):
    def test_example_md_renders_to_example_html(self):
        md = (ASSETS / "example.md").read_text(encoding="utf-8")
        html = (ASSETS / "example.html").read_text(encoding="utf-8")
        self.assertEqual(render.render_deck(md), html)

    def test_unknown_slide_type_exits_1(self):
        with tempfile.TemporaryDirectory() as d:
            src = Path(d) / "deck.md"
            src.write_text("---\ntitle: T\nlang: en\nfooter: F\n---\n\n::: nope\ntitle: x\n", encoding="utf-8")
            r = run("deck", str(src), str(Path(d) / "deck.html"))
            self.assertEqual(r.returncode, 1)
            self.assertIn("nope", r.stderr)

    def test_unknown_field_exits_1(self):
        with tempfile.TemporaryDirectory() as d:
            src = Path(d) / "deck.md"
            src.write_text("---\ntitle: T\nlang: en\nfooter: F\n---\n\n::: route\ntittle: x\n", encoding="utf-8")
            self.assertEqual(run("deck", str(src), str(Path(d) / "o.html")).returncode, 1)

    def test_deck_escapes_html(self):
        md = "---\ntitle: T\nlang: en\nfooter: F\n---\n\n::: cover\ntitle: a <script>x</script> & \"q\"\n"
        out = render.render_deck(md)
        self.assertNotIn("<script>x", out)
        self.assertIn("a &lt;script&gt;x&lt;/script&gt; &amp; &quot;q&quot;", out)


CMP = "---\ntitle: T\nlang: en\nfooter: F\n---\n\n::: compare\nmeta: Route 1 | Before and after\ntitle: What changes\nintro: And what stays.\nhead: Today | Tomorrow\n"


class CompareSlideTests(unittest.TestCase):
    def test_compare_slide(self):
        out = render.render_deck(CMP + "row: Promise | Track your time | Nothing to rebuild\nrow: Tone | Busy | Calm\n")
        self.assertIn('<section class="slide compare"', out)
        self.assertEqual(out.count('<td class="before">'), 2)
        self.assertEqual(out.count('<td class="after">'), 2)
        self.assertIn("<th>Promise</th>", out)
        self.assertIn("Nothing to rebuild", out)
        self.assertIn("<th>Today</th>", out)
        self.assertIn("What changes", out)

    def test_compare_row_with_two_parts(self):
        with tempfile.TemporaryDirectory() as d:
            src = Path(d) / "deck.md"
            src.write_text(CMP + "row: a | b\n", encoding="utf-8")
            r = run("deck", str(src), str(Path(d) / "o.html"))
            self.assertEqual(r.returncode, 0, r.stderr)
            self.assertIn('<td class="after"></td>', (Path(d) / "o.html").read_text(encoding="utf-8"))

    def test_compare_escapes(self):
        out = render.render_deck(CMP + "row: x | <b> | &\n")
        self.assertIn('<td class="before">&lt;b&gt;</td>', out)
        self.assertIn('<td class="after">&amp;</td>', out)


class CompareMinorTests(unittest.TestCase):
    def test_table_class_differs_from_the_slide(self):
        out = render.render_deck(CMP + "row: a | b | c\n")
        self.assertIn('<table class="cmp">', out)
        self.assertNotIn('<table class="compare">', out)

    def test_head_defaults_to_the_catalogue(self):
        md = "---\ntitle: T\nlang: fr\nfooter: F\n---\n\n::: compare\ntitle: x\nrow: a | b | c\n"
        out = render.render_deck(md)
        self.assertIn("<th>Aujourd'hui</th><th>Demain</th>", out.replace("&#x27;", "'"))


class RenderDocTests(unittest.TestCase):
    def test_doc_signature_and_meta(self):
        out = render.render_doc(doc("## Who else\n\nText."))
        self.assertIn('<meta name="brace-author" content="Bruno">', out)
        self.assertIn('<meta name="brace-meeting" content="2">', out)
        self.assertIn("Bruno, research analyst", out)
        self.assertIn("<title>Benchmark</title>", out)

    def test_escapes_html(self):
        out = render.render_doc(doc('a <b> & "c"'))
        self.assertIn("a &lt;b&gt; &amp; &quot;c&quot;", out)
        self.assertNotIn("<b>", out)

    def test_utf8_and_lang(self):
        out = render.render_doc(doc("Été à Noël.", lang="fr", role="analyste"))
        self.assertIn('<html lang="fr">', out)
        self.assertIn("Été à Noël.", out)
        self.assertIn("Bruno, analyste", out)

    def test_table_list_quote_link(self):
        body = ("| A | B |\n|---|---|\n| 1 | 2 |\n\n- a\n- b\n\n1. one\n\n> q\n\n"
                "See [the routes](2026-11-05-routes.html), **bold**, *it*, `code`.")
        out = render.render_doc(doc(body))
        self.assertIn("<table>", out)
        self.assertIn("<th>A</th>", out)
        self.assertIn("<td>2</td>", out)
        self.assertIn("<ul><li>a</li><li>b</li></ul>", out)
        self.assertIn("<ol><li>one</li></ol>", out)
        self.assertIn("<blockquote><p>q</p></blockquote>", out)
        self.assertIn('<a href="2026-11-05-routes.html">the routes</a>', out)
        self.assertIn("<strong>bold</strong>", out)
        self.assertIn("<em>it</em>", out)
        self.assertIn("<code>code</code>", out)

    def test_no_script_link(self):
        out = render.render_doc(doc("[x](javascript:alert(1))"))
        self.assertNotIn('href="javascript', out)

    def test_offline(self):
        md = (ASSETS / "example.md").read_text(encoding="utf-8")
        for out in (render.render_deck(md), render.render_doc(doc("Plain text."))):
            self.assertNotIn("http", out)

    def test_no_em_dash_in_templates(self):
        out = render.render_doc(doc("Text."))
        self.assertNotIn("—", out)

    def test_assets_copied(self):
        with tempfile.TemporaryDirectory() as d:
            src = Path(d) / "src.md"
            src.write_text(doc("Text."), encoding="utf-8")
            dst = Path(d) / "out" / "benchmark.html"
            r = run("doc", str(src), str(dst))
            self.assertEqual(r.returncode, 0, r.stderr)
            for rel in ("benchmark.html", "deck.css", "doc.css", "fonts/inter/Inter.ttf"):
                self.assertTrue((dst.parent / rel).is_file(), rel)

    def test_missing_front_matter_exits_1(self):
        with tempfile.TemporaryDirectory() as d:
            src = Path(d) / "src.md"
            src.write_text("No front matter.", encoding="utf-8")
            self.assertEqual(run("doc", str(src), str(Path(d) / "o.html")).returncode, 1)


def project(d, sessions=None, docs=(), decks=(), lang="en"):
    root = Path(d) / "proj"
    brand = root / "docs" / "brace" / "brand"
    (brand / "documents").mkdir(parents=True)
    (brand / "presentations").mkdir()
    (root / "docs" / "brace" / "STATUS.md").write_text(
        f"---\nproject: tally\nlanguage: {lang}\nbrand_stage: adjustments\n---\n", encoding="utf-8")
    if sessions is not None:
        (brand / "SESSIONS.md").write_text(sessions, encoding="utf-8")
    for name, meeting, title in docs:
        (brand / "documents" / name).write_text(render.render_doc(doc("Text.", meeting=meeting, title=title)), encoding="utf-8")
    for name in decks:
        (brand / "presentations" / name).write_text("<html></html>", encoding="utf-8")
    return root


def md_in_subprocess(text):
    code = "import sys; sys.path.insert(0, sys.argv[1]); import render; print(render.md_to_html(sys.argv[2]))"
    return subprocess.run([sys.executable, "-c", code, str(HERE), text], capture_output=True, text=True, timeout=5)


class MarkdownEdgeTests(unittest.TestCase):
    def test_line_starts_never_hang(self):
        cases = ["| not a table\nnext", "Text\n| pipe line", "|a|\n|-|", "   > indented quote"]
        for prefix in ("|", ">", " >", "#", "####", "-", "1.", "*", "1)"):
            cases += [prefix, prefix + " text", "text\n" + prefix, prefix + "\ntext"]
        for text in cases:
            try:
                r = md_in_subprocess(text)
            except subprocess.TimeoutExpired:
                self.fail(f"md_to_html hangs on {text!r}")
            self.assertEqual(r.returncode, 0, (text, r.stderr))

    def test_indented_quote_is_a_quote(self):
        self.assertIn("<blockquote><p>q</p></blockquote>", md_in_subprocess("   > q").stdout)

    def test_emphasis_never_touches_a_url(self):
        out = render.inline("[x](http://a.com/**b**/c) and [y](https://e.com/a_*b*_c)")
        self.assertIn('href="http://a.com/**b**/c"', out)
        self.assertIn('href="https://e.com/a_*b*_c"', out)
        self.assertIn("<strong>t</strong>", render.inline("[**t**](x.html)"))


class RenderSpaceTests(unittest.TestCase):
    def test_space_lists_documents_by_meeting(self):
        with tempfile.TemporaryDirectory() as d:
            root = project(d, docs=(("2026-11-05-benchmark.html", "2", "Competitive benchmark"),
                                    ("2026-11-06-platform.html", "3", "Brand platform")))
            out = render.render_space(root)
            self.assertIn('href="documents/2026-11-05-benchmark.html"', out)
            self.assertIn("Competitive benchmark", out)
            self.assertIn("Brand platform", out)
            self.assertIn("strategic recommendation", out.lower())
            self.assertIn("brand platform", out.lower())
            self.assertLess(out.index("Competitive benchmark"), out.index("Brand platform"))

    def test_space_next_meeting(self):
        with tempfile.TemporaryDirectory() as d:
            root = project(d, sessions="# S\n\n## 2026-11-05 Workshop\n\n- meeting: 2026-11-06 09:00\n\n"
                                       "## 2026-11-06 Recommendation\n\n- meeting: 2099-11-07 10:00\n")
            out = render.render_space(root)
            self.assertIn("2099-11-07 10:00", out)
            self.assertIn("2026-11-05 Workshop", out)
            self.assertIn("Your brand, tally", out)

    def test_space_empty_project(self):
        with tempfile.TemporaryDirectory() as d:
            root = project(d)
            r = run("space", str(root))
            self.assertEqual(r.returncode, 0, r.stderr)
            out = (root / "docs" / "brace" / "brand" / "index.html").read_text(encoding="utf-8")
            self.assertIn("Nothing here yet.", out)
            self.assertTrue((root / "docs" / "brace" / "brand" / "doc.css").is_file())

    def test_space_lists_presentations_not_draft(self):
        with tempfile.TemporaryDirectory() as d:
            root = project(d, decks=("2026-11-06-strategy.html", "draft.html"))
            out = render.render_space(root)
            self.assertIn('href="presentations/2026-11-06-strategy.html"', out)
            self.assertNotIn("draft.html", out)

    def test_space_in_french(self):
        with tempfile.TemporaryDirectory() as d:
            root = project(d, lang="fr")
            out = render.render_space(root)
            self.assertIn('<html lang="fr">', out)
            self.assertIn("Ta marque, tally", out)


class RenderSpaceMinorTests(unittest.TestCase):
    def test_past_meeting_is_not_shown_as_next(self):
        with tempfile.TemporaryDirectory() as d:
            root = project(d, sessions="# S\n\n- meeting: 2001-01-01 10:00\n")
            out = render.render_space(root)
            self.assertNotIn("2001-01-01 10:00", out)
            self.assertNotIn("Next meeting", out)

    def test_status_value_with_a_comment(self):
        with tempfile.TemporaryDirectory() as d:
            root = project(d)
            (root / "docs" / "brace" / "STATUS.md").write_text(
                '---\nproject: tally  # the tool\nlanguage: "fr"  # owner\n---\n', encoding="utf-8")
            out = render.render_space(root)
            self.assertIn('<html lang="fr">', out)
            self.assertIn("Ta marque, tally<", out)

    def test_tracking_file_not_utf8_still_renders(self):
        with tempfile.TemporaryDirectory() as d:
            root = project(d)
            (root / "docs" / "brace" / "brand" / "SESSIONS.md").write_bytes(b"# S\n\n## 2026 \xff entry\n")
            r = run("space", str(root))
            self.assertEqual(r.returncode, 0, r.stderr)
            self.assertNotIn("Traceback", r.stderr)

    def test_source_not_utf8_exits_1_with_a_message(self):
        with tempfile.TemporaryDirectory() as d:
            src = Path(d) / "src.md"
            src.write_bytes(b"---\ntitle: \xff\n---\n")
            r = run("doc", str(src), str(Path(d) / "o.html"))
            self.assertEqual(r.returncode, 1)
            self.assertNotIn("Traceback", r.stderr)
            self.assertIn("UTF-8", r.stderr)

    def test_space_shows_the_mission_and_links_the_minutes(self):
        with tempfile.TemporaryDirectory() as d:
            root = project(d, sessions="# S\n\n## 2026-11-05 Workshop\n",
                           docs=(("2026-11-05-minutes-1.html", "1", "Minutes of the workshop"),
                                 ("2026-11-05-benchmark.html", "2", "Competitive benchmark")))
            (root / "docs" / "brace" / "brand" / "BRIEF.md").write_text(
                "# BRAND BRIEF\n\nIntro line.\n\n## The project\n\nA small tool that logs your hours.\n\n## Who it is for\n\nFreelancers.\n",
                encoding="utf-8")
            out = render.render_space(root)
            self.assertIn("A small tool that logs your hours.", out)
            meetings = out.split("Our meetings")[1].split("Your documents")[0]
            self.assertIn('href="documents/2026-11-05-minutes-1.html"', meetings)
            documents = out.split("Your documents")[1]
            self.assertNotIn("minutes-1", documents)
            self.assertIn("Competitive benchmark", documents)


class SharedAssetsTests(unittest.TestCase):
    def test_one_copy_of_the_assets_per_brand_folder(self):
        with tempfile.TemporaryDirectory() as d:
            brand = Path(d) / "p" / "docs" / "brace" / "brand"
            src = Path(d) / "src.md"
            src.write_text(doc("Text."), encoding="utf-8")
            dst = brand / "documents" / "x.html"
            self.assertEqual(run("doc", str(src), str(dst)).returncode, 0)
            deck_src = Path(d) / "deck.md"
            deck_src.write_text("---\ntitle: T\nlang: en\nfooter: F\n---\n\n::: cover\ntitle: x\n", encoding="utf-8")
            deck = brand / "presentations" / "draft.html"
            self.assertEqual(run("deck", str(deck_src), str(deck)).returncode, 0)
            self.assertIn('href="../doc.css"', dst.read_text(encoding="utf-8"))
            self.assertIn('href="../deck.css"', deck.read_text(encoding="utf-8"))
            self.assertTrue((brand / "fonts" / "inter" / "Inter.ttf").is_file())
            self.assertFalse((brand / "documents" / "fonts").exists())
            self.assertFalse((brand / "presentations" / "fonts").exists())


if __name__ == "__main__":
    unittest.main()
