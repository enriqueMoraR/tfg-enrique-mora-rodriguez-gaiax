# Gaia-X Health workspace

Repositorio de trabajo con la estructura multirepo del proyecto Gaia-X Health.

## Proyectos
- `gaiax-health-consumer-node/`
- `gaiax-health-dashboard/`
- `gaiax-health-deployment/`
- `gaiax-health-provider-node/`
- `gaiax-health-trust-service/`

## Material compartido
- `POSTMAN.md`

## Quick Start

```bash
cd gaiax-health-deployment
docker compose up -d --build
```

## Explorar la Base de Datos (DBeaver)

Puedes conectarte a la base de datos PostgreSQL localmente usando clientes como DBeaver con las siguientes credenciales:
- **Host**: `localhost` (o `127.0.0.1`)
- **Puerto**: `5432`
- **Base de datos**: `gaiax_health`
- **Usuario**: `gaiax`
- **Contraseña**: `gaiax`