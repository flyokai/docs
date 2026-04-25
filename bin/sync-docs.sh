#!/usr/bin/env bash
# Sync framework docs from a flyokai/flyokai checkout into this repo's docs/ tree.
#
# Usage (local dev):
#   FLYOKAI_SOURCE_DIR=/www/flyokai/flyokai/vendor/flyokai/flyokai bin/sync-docs.sh
#
# Usage (CI): the workflow clones flyokai/flyokai to /tmp/flyokai-source and
# exports FLYOKAI_SOURCE_DIR=/tmp/flyokai-source before invoking this script.
#
# This is the **only** way content lands under docs/. Do not hand-edit docs/*.md;
# the next sync will overwrite them. Edit upstream in flyokai/flyokai instead.

set -euo pipefail

SRC="${FLYOKAI_SOURCE_DIR:?Set FLYOKAI_SOURCE_DIR to a flyokai/flyokai checkout root}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$REPO_ROOT/docs"

[[ -d "$SRC/docs" ]] || { echo "Error: $SRC/docs not found" >&2; exit 1; }
[[ -f "$SRC/README.md" ]] || { echo "Error: $SRC/README.md not found" >&2; exit 1; }

# Wipe and recreate so deleted upstream pages disappear from the site.
rm -rf "$DEST"
mkdir -p "$DEST"

# Strip the agent cross-reference banner that appears as a single
# `> User docs → ... · Agent quick-ref → ... · Agent deep dive → ...` line.
strip_agent_nav() {
    sed -E '/^> User docs →.*Agent quick-ref →.*Agent deep dive →/d' "$1"
}

# Cross-package links point at sibling repos that aren't part of this site.
# Rewrite them to absolute GitHub URLs so they resolve, instead of 404'ing.
# Patterns handled:
#   ../../<pkg>/README.md[#anchor]                 → github.com/flyokai/<pkg>/blob/main/README.md
#   ../../<pkg>/AGENTS.md (and CHANGELOG/CONTRIBUTING/SECURITY)
#   ../../<pkg>/.agents/{skills,commands}/<x>.md   → blob/main/.agents/...
#   ../.agents/{skills,commands}/<x>.md            → flyokai/flyokai blob/main/.agents/...
#   ../README.md                                   → index.md (this site's home page)
rewrite_links() {
    # Patterns assume the link content is the entire `(...)` of a markdown link.
    # Order matters: cross-package agent links (pattern 2) must run before the
    # bare `.agents/...` rewrite (pattern 3), otherwise the latter would catch
    # the shared suffix.
    sed -E \
        -e 's@\((\.\./)+([a-z][a-z0-9_-]*)/(README|AGENTS|CHANGELOG|CONTRIBUTING|SECURITY)\.md(#[a-z0-9_-]+)?\)@(https://github.com/flyokai/\2/blob/main/\3.md\4)@g' \
        -e 's@\((\.\./)+([a-z][a-z0-9_-]*)/\.agents/(skills|commands)/([a-z0-9_-]+)\.md\)@(https://github.com/flyokai/\2/blob/main/.agents/\3/\4.md)@g' \
        -e 's@\((\.\./)*\.agents/(skills|commands)/([a-z0-9_-]+)\.md\)@(https://github.com/flyokai/flyokai/blob/main/.agents/\2/\3.md)@g' \
        -e 's@\((\.\./)+\.github/([^)]+)\)@(https://github.com/flyokai/flyokai/blob/main/.github/\2)@g' \
        -e 's@\(\.\./README\.md\)@(index.md)@g'
}

# Home page sourced from the framework's README.md.
# Its links like (docs/cli.md) need to become (cli.md) because the docs
# tree is flattened on this site — there is no `docs/` subdir.
strip_agent_nav "$SRC/README.md" \
    | sed -E 's@\(docs/([a-z][a-z0-9_-]*\.md)\)@(\1)@g' \
    | rewrite_links \
    > "$DEST/index.md"

# All framework docs/*.md — already use sibling-relative links, no rewrite needed,
# except for cross-package links which we rewrite the same way.
for f in "$SRC/docs"/*.md; do
    strip_agent_nav "$f" | rewrite_links > "$DEST/$(basename "$f")"
done

# Non-md files mkdocs copies verbatim — the CNAME marks the custom domain.
echo "docs.flyokai.com" > "$DEST/CNAME"

echo "Synced from: $SRC"
echo "Files in $DEST:"
ls "$DEST"
