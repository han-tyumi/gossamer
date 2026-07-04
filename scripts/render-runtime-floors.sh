#!/usr/bin/env bash
# Render runtime-floor badges into README.md from runtime.toml.
#
# Replaces the content between marker comments. Idempotent — safe to run
# multiple times. Lefthook runs this on changes to runtime.toml.
#
# Marker pair (each marker on its own line):
#   <!-- floors-badges:start --> ... <!-- floors-badges:end -->

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FLOORS="$ROOT/runtime.toml"

read_floor() {
    grep "^$1 *= *\"" "$FLOORS" | sed 's/.*"\(.*\)".*/\1/'
}

NODE=$(read_floor nodejs)
DENO=$(read_floor deno)
BUN=$(read_floor bun)

# Shields.io split-style badges to match the Hex badges above: default
# dark-grey label on the left, brand-color value on the right. Each badge
# links to its runtime homepage.
render_badges() {
    cat <<EOF
[![Node.js](https://img.shields.io/badge/Node.js-%3E%3D%20${NODE}-339933?logo=nodedotjs&logoColor=fff)](https://nodejs.org/)
[![Deno](https://img.shields.io/badge/Deno-%3E%3D%20${DENO}-70ffaf?logo=deno&logoColor=fff)](https://deno.com/)
[![Bun](https://img.shields.io/badge/Bun-%3E%3D%20${BUN}-fbf0df?logo=bun&logoColor=fff)](https://bun.sh/)
EOF
}

# Replace lines between START and END markers (exclusive) with the given
# content file's contents. Uses awk to preserve everything outside untouched.
replace_between() {
    file=$1
    marker=$2
    content_file=$3

    tmp=$(mktemp)
    awk -v marker="$marker" -v contentfile="$content_file" '
        BEGIN {
            skip = 0
            n = 0
            while ((getline line < contentfile) > 0) {
                content[n++] = line
            }
            close(contentfile)
        }
        $0 ~ ("<!-- floors-" marker ":start -->") {
            print
            for (i = 0; i < n; i++) print content[i]
            skip = 1
            next
        }
        $0 ~ ("<!-- floors-" marker ":end -->") {
            print
            skip = 0
            next
        }
        !skip { print }
    ' "$file" >"$tmp"
    mv "$tmp" "$file"
}

badges_file=$(mktemp)
render_badges >"$badges_file"
replace_between "$ROOT/README.md" badges "$badges_file"
rm -f "$badges_file"

# Canonicalize the rewritten Markdown so spacing matches deno fmt — avoids
# a race with the parallel deno-format lefthook hook.
deno fmt -q "$ROOT/README.md" 2>/dev/null || true

echo "Rendered floors → README.md"
