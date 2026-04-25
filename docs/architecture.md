# Architecture

!!! info "Placeholder"
    Detailed sections coming. Outline below mirrors the project's `CLAUDE.md`.

## Bootstrap lifecycle

1. `Bootstrap\Registry::addModule()` is invoked for each module via Composer autoload.
2. `Bootstrap\RootBootstrap` is instantiated with an `ApplicationType` (Setup, Cluster, Worker, Task, Web, Cli).
3. **Init phase** — every matching module's `init()` registers DI config files.
4. **Build phase** — Amp Injector `Application` is built from merged definitions.
5. **Bootstrap phase** — every matching module's `bootstrap()` runs against the live container.

## Async never blocks

- `Amp\delay()` instead of `sleep()`.
- `Amp\async()` for concurrent work.
- All I/O (DB, HTTP, filesystem, OpenSearch, channels) is non-blocking by default.
- HTTP handlers, CLI commands, and request handlers run inside fibers.

## Default DB driver

`AsyncMysqliConnectionPool` is the default `ConnectionPool` (in-process cooperative concurrency via `MYSQLI_ASYNC`). Switch to `AsyncPdoConnectionPool` (worker pools) or `AmpConnectionPool` (`amphp/mysql`) by overriding the alias in your project's `diconfig.php`.
