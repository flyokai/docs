# Reference

!!! info "Placeholder"
    Authoritative reference (config keys, DTO shapes, CLI flags) will live here.

## Application types

| Type | Bootstrap | Use case |
|---|---|---|
| `Setup` | `SetupBootstrap` | First-time install, migrations |
| `Cluster` | `ClusterBootstrap` | Multi-process supervisor |
| `Worker` | `WorkerBootstrap` (extends Web) | Worker process |
| `Task` | `TaskBootstrap` | One-off task execution |
| `Web` | `WebBootstrap` | HTTP server |
| `Cli` | `CliBootstrap` | Console commands |

## DI config files

Each module ships `config/diconfig*.php` files, scoped by application type:

- `diconfig.php` — base
- `diconfig_web.php`
- `diconfig_cli.php`
- `diconfig_cluster.php`
- `diconfig_worker.php`
- `diconfig_setup.php`
