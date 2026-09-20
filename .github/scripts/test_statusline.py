#!/usr/bin/env python3

import json
import os
from pathlib import Path
import subprocess
import tempfile
import time
import unittest


SCRIPT = Path(__file__).resolve().parents[2] / "home/.claude/statusline.sh"
MODEL = {
    "kind": "weekly_scoped",
    "scope": {"model": {"display_name": "Fable"}},
    "percent": 25,
    "resets_at": None,
}


class UsageRefreshTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="statusline-test.")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.cache_dir = self.root / ".claude/cache"
        self.cache_dir.mkdir(parents=True)
        (self.root / ".claude/.credentials.json").write_text(
            '{"claudeAiOauth":{"accessToken":"dummy-test-token"}}'
        )
        self.cache = self.cache_dir / "model-usage.json"
        self.stamp = self.cache_dir / "model-usage.stamp"
        self.old = json.dumps({
            "fetched_at": int(time.time()) - 4000,
            "models": [{"name": "Fable", "percent": 40, "resets_at": None}],
        })
        self.calls = self.root / "curl-calls.jsonl"
        self.script = self.root / "statusline.sh"
        self.script.write_text(
            SCRIPT.read_text().replace("${HOME}", "${STATUSLINE_TEST_ROOT}")
        )
        bin_dir = self.root / "bin"
        bin_dir.mkdir()
        curl = bin_dir / "curl"
        curl.write_text('''#!/usr/bin/env python3
import json, os, sys
from pathlib import Path
args = sys.argv[1:]
with open(os.environ["STATUSLINE_CURL_CALLS"], "a") as calls:
    calls.write(json.dumps(args) + "\\n")
Path(args[args.index("-o") + 1]).write_text(os.environ["STATUSLINE_RESPONSE"])
sys.stdout.write(os.environ.get("STATUSLINE_HTTP_CODE", "200"))
sys.exit(int(os.environ.get("STATUSLINE_CURL_EXIT", "0")))
''')
        curl.chmod(0o755)
        claude = bin_dir / "claude"
        claude.write_text('''#!/usr/bin/env python3
import os, sys
assert sys.argv[1:] == ["--version"]
print(os.environ.get("STATUSLINE_CLI_VERSION", "9.8.7 (Claude Code)"))
sys.exit(int(os.environ.get("STATUSLINE_CLI_EXIT", "0")))
''')
        claude.chmod(0o755)
        self.env = dict(os.environ, STATUSLINE_TEST_ROOT=str(self.root),
                        STATUSLINE_CURL_CALLS=str(self.calls))
        self.env["PATH"] = str(bin_dir) + os.pathsep + self.env["PATH"]

    def run_script(self, *args, stdin=""):
        result = subprocess.run(
            ["bash", str(self.script), *args], input=stdin, env=self.env,
            text=True, capture_output=True, timeout=5,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, "")
        return result.stdout

    def refresh(self, body, code="200", curl_exit=0):
        self.cache.write_text(self.old)
        self.stamp.unlink(missing_ok=True)
        self.env.update(STATUSLINE_RESPONSE=body, STATUSLINE_HTTP_CODE=code,
                        STATUSLINE_CURL_EXIT=str(curl_exit))
        self.assertEqual(self.run_script("--refresh"), "")
        self.assertTrue(self.stamp.exists())
        self.assertEqual(list(self.cache_dir.glob("*.tmp")), [])
        self.assertEqual(list(self.cache_dir.glob("model-usage.raw.*")), [])

    def render(self):
        return self.run_script(stdin='{"context_window":{"remaining_percentage":80}}')

    def assert_preserved(self):
        self.assertEqual(self.cache.read_text(), self.old)
        self.assertIn("Fable ~60%", self.render())

    def test_client_headers(self):
        self.refresh(json.dumps({"limits": [MODEL]}))
        args = json.loads(self.calls.read_text())
        headers = [args[i + 1] for i, arg in enumerate(args) if arg == "-H"]
        self.assertIn("Authorization: Bearer dummy-test-token", headers)
        self.assertIn("anthropic-beta: oauth-2025-04-20", headers)
        self.assertIn("User-Agent: claude-cli/9.8.7 (external, cli)", headers)

    def test_unavailable_cli_version(self):
        self.env.update(STATUSLINE_CLI_EXIT="127", STATUSLINE_CLI_VERSION="")
        self.refresh(json.dumps({"limits": [MODEL]}))
        self.assertIn("User-Agent: claude-cli/unknown (external, cli)",
                      json.loads(self.calls.read_text()))
        self.assertIn("Fable 75%", self.render())

    def test_valid_usage_updates_models(self):
        self.refresh(json.dumps({"limits": [
            {"kind": "weekly_all", "percent": 10},
            {"kind": "weekly_scoped", "scope": {"surface": {"display_name": "Other"}}},
            MODEL,
        ]}))
        data = json.loads(self.cache.read_text())
        self.assertGreater(data["fetched_at"], json.loads(self.old)["fetched_at"])
        self.assertEqual(data["models"], [{"name": "Fable", "percent": 25, "resets_at": None}])
        self.assertIn("Fable 75%", self.render())

    def test_zero_percent_is_valid(self):
        self.refresh(json.dumps({"limits": [{**MODEL, "percent": 0}]}))
        self.assertIn("Fable 100%", self.render())

    def test_valid_empty_limits_clears_models(self):
        self.refresh('{"limits":[]}')
        self.assertEqual(json.loads(self.cache.read_text())["models"], [])
        self.assertNotIn("Fable", self.render())

    def test_invalid_payloads_preserve_cache(self):
        invalid = [
            "", "  \n", "{", "{}", "null", "[]", '"text"',
            '{"error":{"type":"rate_limit_error"}}',
            '{"error":{"type":"rate_limit_error"},"limits":[]}',
            '{"limits":[]}\n{"limits":[]}',
            '{"limits":null}', '{"limits":{}}', '{"limits":"bad"}',
            '{"limits":[null]}', '{"limits":[42]}', '{"limits":[{}]}',
            '{"limits":[{"kind":42}]}',
        ]
        for percent in (None, "25", True, {}):
            invalid.append(json.dumps({"limits": [{**MODEL, "percent": percent}]}))
        for resets_at in (42, False, {}):
            invalid.append(json.dumps({"limits": [{**MODEL, "resets_at": resets_at}]}))
        for name in (None, 42, {}):
            invalid.append(json.dumps({"limits": [
                {**MODEL, "scope": {"model": {"display_name": name}}},
            ]}))
        for body in invalid:
            with self.subTest(body=body):
                self.refresh(body)
                self.assert_preserved()

    def test_http_errors_preserve_cache(self):
        for code in ("401", "429", "500"):
            with self.subTest(code=code):
                self.refresh(json.dumps({"limits": [MODEL]}), code=code)
                self.assert_preserved()

    def test_failed_transfers_preserve_cache(self):
        for curl_exit in (18, 28):
            for body in ("", '{"limits":[', json.dumps({"limits": [MODEL]})):
                with self.subTest(curl_exit=curl_exit, body=body):
                    self.refresh(body, curl_exit=curl_exit)
                    self.assert_preserved()

    def test_failed_refresh_is_throttled(self):
        self.refresh("", curl_exit=28)
        self.run_script("--refresh")
        self.assertEqual(len(self.calls.read_text().splitlines()), 1)
        self.assert_preserved()


if __name__ == "__main__":
    unittest.main()
