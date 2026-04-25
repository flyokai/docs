# Flyokai

Flyokai is an async PHP application framework built on [AMPHP 3.x](https://amphp.org/) and the [Revolt event loop](https://revolt.run/).

!!! warning "Documentation under construction"
    This site is being seeded. Pages are placeholders for now — content will land package-by-package.

## What it is

- **Non-blocking by default** — DB, HTTP, filesystem, OpenSearch, channels.
- **Module-based** — every feature lives in its own Composer package under `flyokai/*` and is composed via topological ordering.
- **Multiple application types** — the same module set powers Web, CLI, Worker, Cluster, Task, and Setup binaries.

## Quick links

- [Getting Started](getting-started.md) — install and run a sandbox.
- [Architecture](architecture.md) — bootstrap lifecycle, DI, async patterns.
- [Modules](modules.md) — per-package overview.
- [Reference](reference.md) — DTOs, config, conventions.
