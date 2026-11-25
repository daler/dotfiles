#!/usr/bin/env python3
"""Print the Unicode codepoints used by asciicast recordings, as a pyftsubset
``--unicodes`` list.

Used by ``docs/regenerate-docs-font.sh`` to subset the Nerd Font shipped with
the docs down to only the glyphs the committed casts actually draw. Deriving the
list from the casts means re-running the regeneration after a new recording
automatically picks up any new glyph; a hardcoded range list would silently drop
it and the docs would render tofu with nothing to warn you.

Usage::

    cast_codepoints.py FILE.cast [FILE.cast ...]
"""

import json
import sys


def codepoints(paths):
    # Always keep printable ASCII + Latin-1: captions, prompts and anything
    # typed in a future recording, so a trivial cast edit doesn't require
    # re-subsetting the font.
    points = set(range(0x20, 0x7F)) | set(range(0xA0, 0x100))

    for path in paths:
        with open(path, encoding="utf-8") as fh:
            for i, line in enumerate(fh):
                line = line.strip()
                # Line 0 is the header; v3 also allows comment/blank lines.
                if not line or i == 0:
                    continue
                try:
                    event = json.loads(line)
                except ValueError:
                    continue
                # [time, type, data]; only "o" (output) reaches the screen.
                # This is the terminal's raw byte stream, so stray characters
                # from escape sequences come along too -- harmless, they are all
                # ASCII and included above anyway.
                if isinstance(event, list) and len(event) > 2 and event[1] == "o":
                    points.update(ord(ch) for ch in str(event[2]))

    return {cp for cp in points if cp >= 0x20 and cp != 0x7F}


def main(argv):
    if len(argv) < 2:
        sys.exit(__doc__)
    points = codepoints(argv[1:])
    if not points:
        sys.exit("no codepoints found in: %s" % " ".join(argv[1:]))
    sys.stdout.write(",".join("U+%04X" % cp for cp in sorted(points)))


if __name__ == "__main__":
    main(sys.argv)
