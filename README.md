# Flyokai documentation

Source for [docs.flyokai.com](https://docs.flyokai.com/), built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/).

**This repo holds only the renderer** — config, theme, CI. The Markdown content is **synced from [`flyokai/flyokai`](https://github.com/flyokai/flyokai)** at build time. Editing `docs/*.md` here has no effect; the next sync overwrites it.

## How it works

```
flyokai/flyokai (private)        flyokai/docs (this repo, public)        gh-pages → docs.flyokai.com
└─ README.md                     ├─ mkdocs.yml                            ├─ index.html
└─ docs/                         ├─ requirements.txt                       ├─ getting-started/
   ├─ getting-started.md         ├─ bin/sync-docs.sh                      ├─ architecture/
   ├─ architecture.md            └─ .github/workflows/docs.yml             └─ ...
   └─ ...                                  │
        │                                  │
        └────────── sync ─────► docs/ (generated, gitignored)
                                           │
                                           └── mkdocs gh-deploy ──►
```

The `Deploy docs` GitHub Action runs:

1. **Daily at 04:00 UTC** (cron) — picks up upstream doc edits.
2. **On push to `main`** of this repo — picks up theme/config changes.
3. **On manual trigger** (`workflow_dispatch`) — for ad-hoc rebuilds.

Each run clones `flyokai/flyokai@main`, executes `bin/sync-docs.sh`, then `mkdocs gh-deploy --force`.

## Editing documentation

Don't edit files here. Edit them upstream:

```bash
cd /path/to/flyokai/flyokai
# edit docs/architecture.md, README.md, etc.
git commit -am "docs: clarify bootstrap lifecycle"
git push origin main
```

The site rebuilds within 24 hours (next cron tick), or trigger immediately:

```bash
gh workflow run --repo flyokai/docs "Deploy docs"
```

## Local preview

Sync once from your local sandbox checkout, then run mkdocs:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Sync from a local clone (any flyokai/flyokai working copy works).
FLYOKAI_SOURCE_DIR=/www/flyokai/flyokai/vendor/flyokai/flyokai \
    bin/sync-docs.sh

mkdocs serve
# open http://127.0.0.1:8000
```

`mkdocs serve` live-reloads on save — but remember, those edits are in the *generated* `docs/` directory and will be lost on the next sync. Use it to preview, not to author.

## CI configuration

The workflow needs read access to `flyokai/flyokai` (private). Setup:

1. **Generate a fine-grained PAT** at <https://github.com/settings/personal-access-tokens/new>:
   - **Resource owner**: `flyokai`
   - **Repository access**: *Only select repositories* → `flyokai/flyokai`
   - **Permissions**: *Repository permissions* → **Contents: Read-only**
   - **Expiration**: 1 year (or shorter — set a calendar reminder)
2. **Add as a repo secret** in this repo's *Settings → Secrets and variables → Actions*:
   - **Name**: `FLYOKAI_DOCS_TOKEN`
   - **Value**: the `github_pat_…` string from step 1
3. The next workflow run will succeed. Trigger one manually with `gh workflow run "Deploy docs"`.

When `flyokai/flyokai` becomes public, the secret is no longer required — the clone step works anonymously. The workflow will keep working with or without the token; you can delete it for hygiene at that point.

## Repo layout

```
mkdocs.yml                       Site config: theme, nav, plugins
requirements.txt                 Python deps (pinned)
bin/sync-docs.sh                 Pulls README + docs/ from flyokai/flyokai, rewrites cross-package links
.github/workflows/docs.yml       Build + deploy pipeline
.gitignore                       Ignores docs/ (generated) and site/ (built)
```
