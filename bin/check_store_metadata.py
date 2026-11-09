#!/usr/bin/env python3
"""Check fastlane store texts against App Store / Google Play length limits.

Usage: bin/check_store_metadata.py [metadata_dir]   (default: fastlane/metadata)
Exits non-zero on any violation.
"""

import pathlib
import sys

IOS = {"name.txt": 30, "subtitle.txt": 30, "keywords.txt": 100, "promotional_text.txt": 170,
       "description.txt": 4000, "release_notes.txt": 4000}
ANDROID = {"title.txt": 30, "short_description.txt": 80, "full_description.txt": 4000, "changelogs/default.txt": 500}


def check(base: pathlib.Path, limits: dict[str, int]) -> list[str]:
    errors = []
    for loc in sorted(p for p in base.iterdir() if p.is_dir()):
        for name, limit in limits.items():
            f = loc / name
            if not f.exists():
                errors.append(f"{f}: missing")
                continue
            text = f.read_text(encoding="utf-8").rstrip("\n")
            if not text.strip():
                errors.append(f"{f}: empty")
            if len(text) > limit:
                errors.append(f"{f}: {len(text)} > {limit} chars")
            if name == "keywords.txt" and (", " in text or " ," in text):
                errors.append(f"{f}: spaces around commas")
    return errors


def main() -> int:
    root = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "fastlane/metadata")
    errors = check(root / "ios", IOS) + check(root / "android", ANDROID)
    for e in errors:
        print(e)
    n_ios = sum(1 for p in (root / "ios").iterdir() if p.is_dir())
    n_android = sum(1 for p in (root / "android").iterdir() if p.is_dir())
    print(f"{n_ios} iOS + {n_android} Android locales, {len(errors)} problems")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
