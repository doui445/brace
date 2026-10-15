#!/usr/bin/env python3
"""Validates the plugin manifests. Run from the repo root:
    python3 -m unittest test_plugin_manifest
"""
import json
import os
import unittest
from pathlib import Path

REPO = Path(__file__).parent
CLAUDE_HOOK_SCRIPTS = {"session_start.sh", "post_tool_use.sh"}


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

    def test_claude_post_tool_use_matches_edit_write(self):
        for group in _load("claude-hooks.json")["hooks"].get("PostToolUse", []):
            self.assertEqual(group.get("matcher"), "Edit|Write")

    def test_antigravity_hooks_point_at_existing_executables(self):
        h = _load("hooks.json")
        cmds = []
        for block in h.values():
            for event, entries in block.items():
                for e in entries:
                    cmds += [x["command"] for x in e.get("hooks", [])] if "hooks" in e else [e["command"]]
        self.assertEqual({c.rsplit("/", 1)[-1] for c in cmds}, CLAUDE_HOOK_SCRIPTS)
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
