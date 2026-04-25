# Getting Started

!!! info "Placeholder"
    Walkthroughs will land here as packages stabilize. Below is the bare-minimum sandbox install for early adopters.

## Sandbox install

```bash
git clone <flyokai-sandbox-repo> flyokai
cd flyokai
composer install

vendor/bin/flyok-setup install \
    --db-host=… --db-user=… --db-pass=… --db-name=… --base-url=…

php bin/flyok-setup upgrade
php bin/flyok-cluster start
```

## Editions

Downstream projects don't use the sandbox — they pull one of:

- `flyokai/webapi-edition` — HTTP API server.
- `flyokai/data-service-edition` — async data service.

Pick the edition that matches your deployment shape.
