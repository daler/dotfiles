#!/bin/bash

# Regenerate the subset Nerd Font webfonts used by the embedded asciinema casts
# (see docs/asciinema_ext.py and the @font-face rules in
# docs/_static/custom.css).
#
# Why this exists: asciinema-player renders the recording as HTML text, so the
# *browser* has to have the Nerd Font glyphs. The casts contain private-use
# codepoints (Powerline separators, Codicons, Material Design icons in plane
# 15) that no system font covers, so the font has to be shipped with the docs.
#
# The full JetBrainsMono Nerd Font Mono is far too large to commit, so this
# subsets it down to exactly the codepoints that appear in the committed .cast
# files. Deriving the codepoint list from the casts (rather than hardcoding
# ranges) means re-running this after a new recording automatically picks up any
# new glyphs -- a hardcoded range list would silently drop them and you'd get
# tofu in the docs with nothing to warn you.
#
# Run this after adding or re-recording a cast, then commit the woff2 files:
#
#   ./docs/regenerate-docs-font.sh
#   # or, equivalently:
#   cd docs && make regenerate
#
# Requires pyftsubset (fonttools) with brotli for woff2 output:
#
#   conda create -n fonttools -c conda-forge fonttools brotli && conda activate fonttools
#   # or: pip install 'fonttools[woff]'

set -eo pipefail

# Pinned so the committed woff2 is reproducible-ish and so a Nerd Fonts release
# that renumbers codepoints (v2 -> v3 moved thousands of them) can't silently
# change the docs. Bump deliberately, re-run, eyeball the casts in a browser.
NERD_FONTS_VERSION="v3.5.1"

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONT_DIR="$HERE/_static/fonts"
# Faces the player actually asks for: it uses font-weight:bold for bold/bright
# cells, and a synthesized (smeared) bold looks bad on box-drawing characters.
FACES=(Regular Bold Italic)

if ! command -v pyftsubset > /dev/null; then
    echo "ERROR: pyftsubset not found. Install fonttools first:" >&2
    echo "  conda create -n fonttools -c conda-forge fonttools brotli" >&2
    echo "  # or: pip install 'fonttools[woff]'" >&2
    exit 1
fi

# Spelled out rather than using `mapfile`, which is bash 4+ and so missing from
# the bash 3.2 that macOS ships.
CASTS=()
while IFS= read -r cast; do
    CASTS+=("$cast")
done < <(find "$HERE" -name '*.cast' -not -path '*/_build/*' | sort)
if [ ${#CASTS[@]} -eq 0 ]; then
    echo "ERROR: no .cast files found under $HERE" >&2
    exit 1
fi
echo "Casts:"
printf '  %s\n' "${CASTS[@]}"

# Collect every codepoint printed by the recordings. Kept in a separate script
# because bash 3.2 (macOS) cannot parse a heredoc inside $(...).
UNICODES="$(python3 "$HERE/cast_codepoints.py" "${CASTS[@]}")"
echo "Codepoints: $(awk -F, '{print NF}' <<< "$UNICODES")"

# The release archive is ~128 MB, so it's cached (keyed on version) rather than
# downloaded into a temp dir every run. Deliberately *not* under docs/_build,
# which `make clean` deletes -- re-downloading 128 MB because you cleaned the
# HTML build is exactly what this cache exists to avoid. Override with
# FONT_CACHE_DIR.
CACHE_DIR="${FONT_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles-docs-fonts}"
ZIP="$CACHE_DIR/JetBrainsMono-$NERD_FONTS_VERSION.zip"
UNPACKED="$CACHE_DIR/JetBrainsMono-$NERD_FONTS_VERSION"
mkdir -p "$CACHE_DIR"

URL="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION/JetBrainsMono.zip"
if [ -s "$ZIP" ]; then
    echo "Using cached $ZIP"
else
    echo "Downloading $URL"
    # Download to a temp name so an interrupted transfer doesn't leave a
    # truncated zip that later runs would happily treat as cached.
    curl -fL --retry 3 --progress-bar -o "$ZIP.part" "$URL"
    mv "$ZIP.part" "$ZIP"
fi

if [ ! -d "$UNPACKED" ]; then
    unzip -q -o "$ZIP" -d "$UNPACKED.part"
    mv "$UNPACKED.part" "$UNPACKED"
fi

mkdir -p "$FONT_DIR"

for face in "${FACES[@]}"; do
    # "NerdFontMono" is the single-width variant. This matters: asciinema-player
    # lays out runs of text rather than positioning each cell absolutely, so an
    # icon drawn 1.5-2 cells wide (the default "NerdFont"/"NerdFontPropo"
    # variants) shoves the rest of the line out of alignment.
    src="$(find "$UNPACKED" -name "JetBrainsMonoNerdFontMono-$face.ttf" | head -1)"
    if [ -z "$src" ]; then
        echo "ERROR: JetBrainsMonoNerdFontMono-$face.ttf not in the release archive." >&2
        echo "       Asset layout may have changed in $NERD_FONTS_VERSION; check:" >&2
        find "$UNPACKED" -name '*Mono-*.ttf' -exec basename {} \; | head >&2
        exit 1
    fi

    # PfEd is a FontForge-private table (glyph comments and the like) that the
    # Nerd Fonts patcher leaves behind. pyftsubset doesn't know how to subset
    # it, so it drops it anyway but warns; dropping it explicitly keeps the
    # output clean so real warnings are visible. Browsers never look at it.
    out="$FONT_DIR/JetBrainsMonoNFM-$face.woff2"
    pyftsubset "$src" \
        --unicodes="$UNICODES" \
        --layout-features='' \
        --no-hinting \
        --desubroutinize \
        --drop-tables+=PfEd \
        --flavor=woff2 \
        --output-file="$out"
    echo "Wrote $out ($(du -h "$out" | cut -f1))"
done

# Committing the font makes us a redistributor, so ship its license.
license="$(find "$UNPACKED" \( -name 'OFL.txt' -o -name 'LICENSE*' \) | head -1)"
if [ -n "$license" ]; then
    cp "$license" "$FONT_DIR/LICENSE.txt"
    echo "Wrote $FONT_DIR/LICENSE.txt (from $(basename "$license"))"
else
    echo "WARNING: no license file in the archive; add it to $FONT_DIR by hand." >&2
fi

echo
echo "Done. Now: cd docs && make html, and check the casts in a browser."
echo "(Font archive cached in $CACHE_DIR; safe to delete, but it's a 128 MB re-download.)"
