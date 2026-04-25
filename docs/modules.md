# Modules

!!! info "Placeholder"
    Per-package pages will be added one at a time, sourced from each package's `README.md`.

## Layers

### Core framework — `flyokai/*`

| Package | Role |
|---|---|
| `application` | Bootstrap, HTTP server, CLI, DB pooling |
| `data-mate` | `Dto` interface, `Draft` / `Solid` / `GreyData` markers |
| `composition` | Topological module ordering |
| `generic` | PHP generics support |
| `amp-mate` | Async filesystem and AMPHP helpers |
| `service-data` / `data-service` | Inter-service DTOs and channel-based async dispatch |
| `user` | Authentication |
| `oauth-server` | OAuth 2.0 |
| `indexer` | Search/indexing |
| `symfony-console` | Async-aware Symfony Console |
| `magento-dto` / `magento-amp-mate` | Magento integration |

### Async infrastructure — `wtsergo/*`

| Package | Role |
|---|---|
| `amphp-injector` | DI container with weavers |
| `revolt-event-loop` | Event loop |
| `laminas-db` family | Async DB adapters |
| `amp-data-pipeline` | Stream-based concurrent processing |
| `amp-channel-dispatcher` | Inter-process messaging |
| `amp-csv-reader` | Async CSV |
| `amp-opensearch` | Async OpenSearch |

### Business logic — `unirgy/*`

| Package | Role |
|---|---|
| `service-connector` | Magento 2 connector |
| `license-*` | License management |
| `rapidflow-*` | Data import/export service |
