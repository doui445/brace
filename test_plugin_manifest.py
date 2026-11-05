#!/usr/bin/env python3
"""Validates the plugin manifests. Run from the repo root:
    python3 -m unittest test_plugin_manifest
"""
import json
import re
import os
import unittest
from pathlib import Path

REPO = Path(__file__).parent
CLAUDE_HOOK_SCRIPTS = {"session_start.sh", "post_tool_use.sh", "pre_tool_use.sh"}
ANTIGRAVITY_HOOK_SCRIPTS = {"session_start.sh", "post_tool_use.sh"}
CLAUDE_AGENT_TOOLS = {"WebSearch", "WebFetch", "Read", "Write", "Edit", "Glob", "Grep",
                      "mcp__claude-in-chrome__*"}
# Antigravity hangs on an unknown tool name: only names verified in its docs.
AGENTS = ("analyst", "strategist", "copywriter", "creative-director")
ANTIGRAVITY_AGENT_TOOLS = {"search_web", "read_url_content", "view_file", "grep_search",
                           "write_to_file", "replace_file_content"}


def _split_agent(rel):
    """(frontmatter dict, body) of an agent file. Values: str, or list for
    YAML block lists ('  - x'). Enough for these hand-written files."""
    text = (REPO / rel).read_text(encoding="utf-8")
    assert text.startswith("---\n"), rel
    head, body = text[4:].split("\n---\n", 1)
    fm, key = {}, None
    for line in head.splitlines():
        if line.startswith("  - ") and key:
            fm.setdefault(key, [])
            fm[key].append(line[4:].strip())
        elif ":" in line:
            key, val = line.split(":", 1)
            key, val = key.strip(), val.strip()
            fm[key] = val if val else []
    return fm, body


def _load(rel):
    return json.loads((REPO / rel).read_text(encoding="utf-8"))


def _claude_hook_commands():
    h = _load("claude-hooks.json")["hooks"]
    return [hk["command"] for event in h.values() for group in event for hk in group["hooks"]]


class PluginManifestTests(unittest.TestCase):
    def test_manifests_parse(self):
        for rel in (".claude-plugin/plugin.json", ".claude-plugin/marketplace.json",
                    "claude-hooks.json", "hooks.json", "plugin.json"):
            _load(rel)

    def test_plugin_json_has_core_fields(self):
        p = _load(".claude-plugin/plugin.json")
        for k in ("name", "description", "version"):
            self.assertIn(k, p)
        self.assertEqual(p["name"], "brace")
        self.assertEqual(p["hooks"], "./claude-hooks.json")

    def test_versions_are_in_sync(self):
        m = _load(".claude-plugin/marketplace.json")
        entries = {e["name"]: e for e in m["plugins"]}
        self.assertEqual(m["name"], "brace")
        self.assertEqual(entries["brace"]["source"], ".")
        self.assertEqual(entries["brace"]["version"], _load(".claude-plugin/plugin.json")["version"])
        self.assertEqual(entries["brace"]["version"], _load("plugin.json")["version"])
        self.assertEqual(entries["project-tracker"]["source"], "./bridge")

    def test_no_default_hooks_folder(self):
        # Antigravity merges a Claude-format hooks/hooks.json into its own
        # hooks.json, and then no hook fires (verified 2026-10-15).
        self.assertFalse((REPO / "hooks" / "hooks.json").exists())

    def test_claude_hooks_point_at_existing_executables_and_are_quoted(self):
        cmds = _claude_hook_commands()
        self.assertEqual({c.strip('"').rsplit("/", 1)[-1] for c in cmds}, CLAUDE_HOOK_SCRIPTS)
        for c in cmds:
            self.assertTrue(c.startswith('"${CLAUDE_PLUGIN_ROOT}/') and c.endswith('"'), c)
            path = REPO / c.strip('"').replace("${CLAUDE_PLUGIN_ROOT}/", "")
            self.assertTrue(path.is_file(), f"missing: {path}")
            self.assertTrue(os.access(path, os.X_OK), f"not executable: {path}")

    def test_claude_post_tool_use_matches_edit_write_bash(self):
        groups = _load("claude-hooks.json")["hooks"].get("PostToolUse", [])
        self.assertTrue(groups)
        for group in groups:
            self.assertEqual(group.get("matcher"), "Edit|Write|Bash")

    def test_claude_pre_tool_use_matches_edit_write(self):
        groups = _load("claude-hooks.json")["hooks"].get("PreToolUse", [])
        self.assertTrue(groups)
        for group in groups:
            self.assertEqual(group.get("matcher"), "Edit|Write")

    def test_antigravity_hooks_point_at_existing_executables(self):
        h = _load("hooks.json")
        cmds = []
        for block in h.values():
            for event, entries in block.items():
                for e in entries:
                    cmds += [x["command"] for x in e.get("hooks", [])] if "hooks" in e else [e["command"]]
        self.assertEqual({c.rsplit("/", 1)[-1] for c in cmds}, ANTIGRAVITY_HOOK_SCRIPTS)
        for c in cmds:
            path = REPO / c.lstrip("./")
            self.assertTrue(path.is_file(), f"missing: {c}")
            self.assertTrue(os.access(path, os.X_OK), f"not executable: {c}")

    def test_bridge_manifest(self):
        b = _load("bridge/.claude-plugin/plugin.json")
        self.assertEqual(b["name"], "project-tracker")
        entries = {e["name"]: e for e in _load(".claude-plugin/marketplace.json")["plugins"]}
        self.assertEqual(entries["project-tracker"]["version"], b["version"])
        cmd = _load("bridge/hooks/hooks.json")["hooks"]["SessionStart"][0]["hooks"][0]["command"]
        path = REPO / "bridge" / cmd.strip('"').replace("${CLAUDE_PLUGIN_ROOT}/", "")
        self.assertTrue(path.is_file() and os.access(path, os.X_OK), path)

    def test_session_start_hooks_have_a_90s_timeout(self):
        # The plugin swap may spend up to 35 s in CLI calls: the host's
        # default hook timeout must not cut it short.
        for g in _load("claude-hooks.json")["hooks"]["SessionStart"]:
            for hk in g["hooks"]:
                self.assertEqual(hk.get("timeout"), 90)
        for g in _load("bridge/hooks/hooks.json")["hooks"]["SessionStart"]:
            for hk in g["hooks"]:
                self.assertEqual(hk.get("timeout"), 90)
        for e in _load("hooks.json")["brace-session"]["PreInvocation"]:
            self.assertEqual(e.get("timeout"), 90)

    def test_bridge_hook_command_is_quoted(self):
        for g in _load("bridge/hooks/hooks.json")["hooks"]["SessionStart"]:
            for hk in g["hooks"]:
                c = hk["command"]
                self.assertTrue(c.startswith('"${CLAUDE_PLUGIN_ROOT}/') and c.endswith('"'), c)

    def test_config_command_exists(self):
        p = REPO / "commands" / "config.md"
        self.assertTrue(p.is_file())
        self.assertIn("description:", p.read_text(encoding="utf-8"))

    def test_agents_is_a_reserved_skill_name(self):
        # docs/brace/agents/ holds BRACE agents' per-project folders, never a skill.
        self.assertFalse((REPO / "skills" / "agents").exists())

    def test_i18n_has_brand_touchpoints_heading(self):
        # The voice-drift hook finds the Touchpoints section by these values.
        i18n = REPO / "skills" / "track" / "references" / "i18n"
        for code in ("en", "fr"):
            text = (i18n / f"{code}.md").read_text(encoding="utf-8")
            self.assertRegex(text, r"(?m)^- brand\.strategy\.heading\.touchpoints: \S")

    def test_claude_manifest_points_at_the_claude_agent(self):
        self.assertEqual(_load(".claude-plugin/plugin.json").get("agents"),
                         [f"./agents/claude/{name}.md" for name in AGENTS])

    def test_agent_files(self):
        for name in AGENTS:
            with self.subTest(agent=name):
                claude, c_body = _split_agent(f"agents/claude/{name}.md")
                agy, a_body = _split_agent(f"agents/{name}.md")
                for fm in (claude, agy):
                    self.assertEqual(fm.get("name"), name)
                    self.assertTrue(fm.get("description"))
                self.assertTrue(set(t.strip() for t in claude["tools"].split(",")) <= CLAUDE_AGENT_TOOLS)
                self.assertEqual(claude.get("model"), "sonnet")
                self.assertEqual(claude.get("background"), "true")
                self.assertTrue(set(agy["tools"]) <= ANTIGRAVITY_AGENT_TOOLS)
                self.assertEqual(agy.get("subagent"), "true")
                self.assertEqual(agy.get("mainAgent"), "false")
                self.assertEqual(agy.get("model"), "flash")
                self.assertEqual(agy.get("commandExecutionPolicy"), "off")
                # Frontmatter values are plain YAML scalars: a ": " inside one breaks
                # the parser of the host tool.
                for fm in (claude, agy):
                    self.assertNotIn(": ", fm.get("description", ""))
                # One trade, one text: the two bodies must never drift apart.
                self.assertEqual(c_body, a_body)
                self.assertIn(f"docs/brace/agents/{name}/", c_body)
                self.assertNotIn("—", c_body)

    def test_new_agents_report_formats(self):
        for name, head in (("strategist", "# Routes: "), ("copywriter", "# Words: "),
                           ("creative-director", "# Review: ")):
            claude, body = _split_agent(f"agents/claude/{name}.md")
            self.assertIn(head, body, name)
            self.assertEqual([t.strip() for t in claude["tools"].split(",")],
                             ["Read", "Write", "Edit", "Glob", "Grep"], name)

    def test_skills_frontmatter_and_references_exist(self):
        import re
        for skill_md in sorted((REPO / "skills").glob("*/SKILL.md")):
            text = skill_md.read_text(encoding="utf-8")
            self.assertTrue(text.startswith("---\n"), skill_md)
            head = text[4:].split("\n---\n", 1)[0]
            self.assertRegex(head, r"(?m)^name: \S", skill_md)
            self.assertRegex(head, r"(?m)^description: \S", skill_md)
            desc = re.search(r"(?m)^description: (.*)$", head).group(1)
            self.assertNotIn(": ", desc, f"{skill_md}: ': ' breaks the YAML frontmatter")
            for ref in set(re.findall(r"`(references/[a-z0-9_/.-]+\.md)`", text)):
                self.assertTrue((skill_md.parent / ref).is_file(), f"{skill_md}: missing {ref}")

    def test_brand_and_analyst_hold_back_on_a_legacy_project(self):
        # A project still on docs/project-tracker/ (move pending) must never
        # get a docs/brace/ folder from brand or the analyst: the move would
        # then find both folders and stop.
        for rel in ["skills/brand/SKILL.md"] + [f"agents/claude/{n}.md" for n in AGENTS]:
            text = (REPO / rel).read_text(encoding="utf-8")
            self.assertIn("docs/project-tracker/", text, rel)

    def test_brand_stages_are_consistent(self):
        # Every stage a reference sets must be one SKILL.md declares, every
        # declared stage but done is set somewhere, and the stages of 1.0
        # still map onto the new ones (zero breakage on resume).
        import re
        brand = REPO / "skills" / "brand"
        head = (brand / "SKILL.md").read_text(encoding="utf-8")
        declared = re.search(r"`brand_stage: ([a-z |]+)`", head).group(1)
        stages = {x.strip() for x in declared.split("|")}
        self.assertEqual(stages, {"brief", "backstage", "presentation", "adjustments", "delivery", "done"})
        used = set()
        for f in [brand / "SKILL.md"] + sorted((brand / "references").glob("*.md")):
            used |= set(re.findall(r"brand_stage: ([a-z]+)`", f.read_text(encoding="utf-8")))
        self.assertTrue(used <= stages, used - stages)
        self.assertEqual(stages - {"done"}, used & stages - {"done"}, "a declared stage no reference sets")
        legacy = re.search(r"(?m)^`?legacy: (.*?)`?$", head)
        self.assertTrue(legacy, "no legacy: line in SKILL.md")
        for old in ("interview", "foundations", "strategy", "voice", "name", "test"):
            self.assertRegex(legacy.group(1), r"\b" + old + r"\b", old)

    def test_brand_never_asks_the_depth(self):
        for f in sorted((REPO / "skills" / "brand").rglob("*.md")):
            text = " ".join(f.read_text(encoding="utf-8").split())
            self.assertNotIn("sk the depth", text, f)
        self.assertFalse((REPO / "skills" / "brand" / "references" / "interview.md").exists())
        self.assertFalse((REPO / "skills" / "brand" / "references" / "test.md").exists())

    def test_brand_resumes_a_1_0_project_without_redoing_it(self):
        # The legacy stages land in adjustments: a 1.0 project has no route
        # and no BRIEF.md, and its validated files must be kept.
        text = " ".join((REPO / "skills" / "brand" / "references" / "adjustments.md")
                        .read_text(encoding="utf-8").split())
        self.assertIn("## Resumed from 1.0", (REPO / "skills" / "brand" / "references" / "adjustments.md").read_text(encoding="utf-8"))
        self.assertIn("first missing document", text)
        self.assertIn("never redrafted", text)

    def test_presentation_proposes_rather_than_asks(self):
        text = (REPO / "skills" / "brand" / "references" / "presentation.md").read_text(encoding="utf-8")
        for q in ("What does this route promise?", "Which one feels like your product?",
                  "Anything you would not want to see said?"):
            self.assertNotIn(q, text)

    def test_i18n_has_brand_brief_and_sessions(self):
        i18n = REPO / "skills" / "track" / "references" / "i18n"
        for code in ("en", "fr"):
            text = (i18n / f"{code}.md").read_text(encoding="utf-8")
            for key in ("brief.title", "brief.intro", "brief.heading.project", "brief.heading.objectives",
                        "brief.heading.audience", "brief.heading.competitors", "brief.heading.name",
                        "brief.heading.taste", "brief.heading.emotion", "brief.heading.never",
                        "brief.heading.assumptions", "sessions.title", "sessions.intro",
                        "sessions.decided", "sessions.waiting", "sessions.next"):
                self.assertRegex(text, r"(?m)^- brand\." + re.escape(key) + r": \S", f"{code}: {key}")

    def test_analyst_writes_one_report_per_subject(self):
        _, body = _split_agent("agents/claude/analyst.md")
        self.assertIn("one report file per subject", " ".join(body.split()))

    def test_analyst_takes_depth_from_caller_and_finds_references(self):
        for rel in ("agents/claude/analyst.md", "agents/analyst.md"):
            fm, body = _split_agent(rel)
            self.assertNotIn("ask the user for the depth", fm["description"], rel)
            flat = " ".join(body.split())
            self.assertIn("**references**", flat, rel)
            self.assertIn("brands that made a comparable choice", flat, rel)
            self.assertIn("when a browser is available", flat, rel)
        claude, _ = _split_agent("agents/claude/analyst.md")
        self.assertIn("mcp__claude-in-chrome__*", [t.strip() for t in claude["tools"].split(",")])

    def test_claude_agent_folder_is_invisible_to_antigravity(self):
        # Antigravity loads agents/<name>.md and agents/<name>/agent.md: the
        # Claude copies in agents/claude/ must match neither.
        claude_dir = REPO / "agents" / "claude"
        self.assertFalse((claude_dir / "agent.md").exists())
        self.assertFalse((REPO / "agents" / "claude.md").exists())
        for f in claude_dir.glob("*.md"):
            self.assertTrue((REPO / "agents" / f.name).is_file(), f"no Antigravity twin for {f.name}")

    def test_platform_notes_say_every_skill_hooks_run(self):
        for name in ("platform-claude.md", "platform-antigravity.md"):
            text = (REPO / "skills" / "track" / "references" / name).read_text(encoding="utf-8")
            self.assertNotIn("runs `skills/track/hooks/session_start.sh`", text, name)
            self.assertIn("each skill", text, name)

    def test_brand_skill_exists(self):
        self.assertTrue((REPO / "skills" / "brand" / "SKILL.md").is_file())

    def test_i18n_catalogues_have_matching_keys(self):
        import re
        i18n = REPO / "skills" / "track" / "references" / "i18n"
        key_re = re.compile(r"^- ([a-z0-9_.]+):", re.MULTILINE)
        en = key_re.findall((i18n / "en.md").read_text(encoding="utf-8"))
        fr = key_re.findall((i18n / "fr.md").read_text(encoding="utf-8"))
        self.assertEqual(en, fr, "en.md and fr.md must list the same keys in the same order")
        self.assertEqual(len(en), len(set(en)), "duplicate keys in en.md")


if __name__ == "__main__":
    unittest.main()
