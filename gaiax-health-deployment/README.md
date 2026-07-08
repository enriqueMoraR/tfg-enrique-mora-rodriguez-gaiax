# gaiax-health-deployment

This repository contains the deployment configuration for the Gaia-X Health project, a polyrepo stack designed to demonstrate a federated health data exchange ecosystem. It uses Docker Compose to orchestrate the deployment of several microservices, including a provider node, a consumer node, a trust service, and a dashboard. The entire stack is designed to showcase how data can be exchanged in a secure and trusted manner, following the principles of data sovereignty and consent management.

## Repositories
- `gaiax-health-provider-node`
- `gaiax-health-trust-service`
- `gaiax-health-consumer-node`
- `gaiax-health-dashboard`
- `gaiax-health-deployment`

## Quick Start

```bash
cd gaiax-health-deployment
docker compose up -d --build
```

The stack starts in this order:

1. `postgres`
2. `provider`
3. `trust`
4. `consumer`
5. `dashboard`

## Service URLs
- PostgreSQL: localhost:5432
- Provider: http://localhost:8081
- Trust: http://localhost:8082
- Consumer: http://localhost:8083
- Dashboard: http://localhost:3000
- FHIR proxy exposed by the dashboard: http://localhost:3000/api/fhir

## Documentation
- API contracts: `docs/api-contracts.md`
- Consent and sovereignty contract: `docs/consent-contract.md`
- Version matrix: `docs/version-matrix.md`
- Development setup: `docs/development-setup.md`
- Troubleshooting: `docs/troubleshooting.md`
- Postman E2E collection: `../documentacion/postman/gaiax-health-e2e.postman_collection.json`

## Notes
- The dashboard build uses `VITE_FHIR_API_URL=/api/fhir` and Nginx proxies that path to the internal provider service.
- `".env.example"` is an optional template for local frontend overrides; the current Docker Compose stack does not require copying it before startup.
- The provider initializes PostgreSQL from `gaiax-health-provider-node/src/main/resources/init_db.sql`.
- The trust and consumer services expose host ports `8082` and `8083`, while the containers listen on `8080`.
- The dashboard also proxies `/api/health/provider`, `/api/health/trust` and `/api/health/consumer` for manual verification and Postman.
- The deployment repo is the entry point for local polyrepo execution.
- For manual E2E verification, import `../documentacion/postman/gaiax-health-e2e.postman_collection.json` or use `POSTMAN.md` at the repo root.