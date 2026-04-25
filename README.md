# Flyokai documentation

Source for [docs.flyokai.com](https://docs.flyokai.com/), built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/).

## Local preview

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
mkdocs serve
```

Open http://127.0.0.1:8000 — pages live-reload on save.

## Build

```bash
mkdocs build         # output → site/
```

## Deploy

Push to `main`. The `Deploy docs` GitHub Action runs `mkdocs gh-deploy --force`, which builds and pushes the rendered site to the `gh-pages` branch. GitHub Pages serves it at https://docs.flyokai.com/.

## Structure

```
docs/              Markdown source
  index.md         Home
  getting-started.md
  architecture.md
  modules.md
  reference.md
  CNAME            Custom domain marker, copied to site/ on build
mkdocs.yml         Site config: theme, nav, plugins
requirements.txt   Python deps (pinned)
.github/workflows/docs.yml   Build & deploy
```

## Adding a page

1. Create `docs/my-page.md`.
2. Add an entry to the `nav:` block in `mkdocs.yml`.
3. Commit + push.
