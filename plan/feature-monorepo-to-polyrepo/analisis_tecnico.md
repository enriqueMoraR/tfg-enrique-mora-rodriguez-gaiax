# Fase 2 - Análisis Técnico: Feature "Monorepo a Polyrepo"

## Entrada Funcional Aprobada
- Migración de **monorepo** (4 servicios en 1 JAR) a **polyrepo** (4 repos independientes)
- Versionado semántico **independiente** por servicio
- Repo **orquestador centralizado** con Docker Compose, docs y README
- GitHub ready con `.gitignore`, `LICENSE`, `CONTRIBUTING.md`

## Objetivo Técnico
Diseñar la **estrategia de separación de código fuente** y **estructura de repositorios** manteniendo:
- ✅ Reproducibilidad local idéntica (mismo Docker Compose)
- ✅ Contratos API explícitos e versionados
- ✅ Independencia de build/versionado por servicio
- ✅ Facilidad para futuros deployments en producción

---

## Decisiones Técnicas Confirmadas

### DT-001: Estructura de 5 Repositorios

```
GitHub Organization / Local ~/repos/
├── gaiax-health-provider-node/        # Backend: Provider EDC connector
│   ├── src/main/java/com/example/...provider/
│   ├── pom.xml
│   ├── Dockerfile
│   ├── .gitignore
│   ├── README.md
│   ├── LICENSE.md
│   └── CONTRIBUTING.md
│
├── gaiax-health-trust-service/        # Backend: Trust/Policy/IAM
│   ├── src/main/java/com/example/...trust/
│   ├── pom.xml
│   ├── Dockerfile
│   ├── .gitignore
│   ├── README.md
│   ├── LICENSE.md
│   └── CONTRIBUTING.md
│
├── gaiax-health-consumer-node/        # Backend: Consumer EDC connector
│   ├── src/main/java/com/example/...consumer/
│   ├── pom.xml
│   ├── Dockerfile
│   ├── .gitignore
│   ├── README.md
│   ├── LICENSE.md
│   └── CONTRIBUTING.md
│
├── gaiax-health-dashboard/            # Frontend: React + Vite
│   ├── src/
│   ├── package.json
│   ├── Dockerfile
│   ├── .gitignore
│   ├── README.md
│   ├── LICENSE.md
│   └── CONTRIBUTING.md
│
└── gaiax-health-deployment/           # Orquestador: Compose + Docs
    ├── docker-compose.yml
    ├── .env.example
    ├── README.md (PRINCIPAL)
    ├── docs/
    │   ├── api-contracts.md
    │   ├── version-matrix.md
    │   ├── development-setup.md
    │   └── troubleshooting.md
    ├── scripts/
    │   ├── setup.sh
    │   └── start.sh
    ├── LICENSE.md
    ├── CONTRIBUTING.md
    └── .gitignore
```

### DT-002: Versionado Semántico Independiente

Cada servicio mantiene su **propio** `version` en:
- **Backend** (`gaiax-health-{provider,trust,consumer}-node`):
  - Fichero: `pom.xml` → raíz `<version>1.0.0</version>`
  - Tag Git: `v1.0.0`, `v1.0.1`, `v1.1.0`, etc.
  - Docker image: `gaiax-health-provider-node:v1.0.0`

- **Frontend** (`gaiax-health-dashboard`):
  - Fichero: `package.json` → `"version": "1.0.0"`
  - Tag Git: `v1.0.0`
  - Docker image: `gaiax-health-dashboard:v1.0.0`

**Matriz de compatibilidad** (en `gaiax-health-deployment/docs/version-matrix.md`):
```
Provider v1.0.0 + Trust v1.0.0 + Consumer v1.0.0 + Dashboard v1.0.0 = Stack 1.0.0 ✅
Provider v1.0.1 + Trust v1.0.0 + Consumer v1.0.0 + Dashboard v1.0.0 = Stack 1.0.1 ✅
```

### DT-003: Docker Compose "Deployment"

Desde `gaiax-health-deployment/docker-compose.yml`:

```yaml
version: '3.9'
services:
  provider:
    image: gaiax-health-provider-node:v1.0.0  # Especificado explícitamente
    build:
      context: ../gaiax-health-provider-node
      dockerfile: Dockerfile
    ports: [8081:8080]
    environment:
      SERVICE_ROLE: provider

  trust:
    image: gaiax-health-trust-service:v1.0.0
    build:
      context: ../gaiax-health-trust-service
      dockerfile: Dockerfile
    ports: [8082:8080]
    environment:
      SERVICE_ROLE: trust
    depends_on:
      provider:
        condition: service_healthy

  consumer:
    image: gaiax-health-consumer-node:v1.0.0
    build:
      context: ../gaiax-health-consumer-node
      dockerfile: Dockerfile
    ports: [8083:8080]
    environment:
      SERVICE_ROLE: consumer
    depends_on:
      trust:
        condition: service_healthy

  dashboard:
    image: gaiax-health-dashboard:v1.0.0
    build:
      context: ../gaiax-health-dashboard
      dockerfile: Dockerfile
    ports: [3000:80]
    depends_on:
      consumer:
        condition: service_healthy
```

**Nota**: `context: ../` asume estructura en `~/repos/gaiax-health-*/` **cómo se origina desde el deployment**.

### DT-004: Migración de Código (Backend)

**Hoy** (monorepo):
```
src/main/java/com/example/tfgenriquemoragaiax/
├── provider/
│   ├── api/
│   ├── domain/
│   └── ...
├── trust/
│   ├── api/
│   ├── domain/
│   └── ...
└── consumer/
    ├── api/
    ├── domain/
    └── ...
```

**Después** (polyrepo):

`gaiax-health-provider-node/src/main/java/com/example/gaiahealth/provider/`:
```
├── api/
├── domain/
└── ...
```

`gaiax-health-trust-service/src/main/java/com/example/gaiahealth/trust/`:
```
├── api/
├── domain/
└── ...
```

`gaiax-health-consumer-node/src/main/java/com/example/gaiahealth/consumer/`:
```
├── api/
├── domain/
└── ...
```

**Cambios en pom.xml por repo**:
```xml
<!-- gaiax-health-provider-node/pom.xml -->
<groupId>com.example</groupId>
<artifactId>gaiax-health-provider-node</artifactId>
<version>1.0.0</version>
```

### DT-005: Migración de Frontend

**Hoy** (monorepo):
```
frontend/
├── src/
│   ├── components/
│   ├── hooks/
│   ├── services/
│   ├── types/
│   └── pages/
├── package.json
├── vite.config.ts
└── Dockerfile
```

**Después** (`gaiax-health-dashboard/`):
```
├── src/
│   ├── components/
│   ├── hooks/
│   ├── services/
│   ├── types/
│   └── pages/
├── package.json
├── vite.config.ts
├── Dockerfile
├── README.md
├── LICENSE.md
├── .gitignore
└── CONTRIBUTING.md
```

**Cambios en package.json**:
```json
{
  "name": "gaiax-health-dashboard",
  "version": "1.0.0",
  "description": "React Dashboard for Gaia-X Health Data Visualization"
}
```

**Ajuste de build centralizado**:
- El `Dockerfile` del dashboard acepta `VITE_API_URL` como build arg.
- `gaiax-health-deployment/docker-compose.yml` inyecta `http://consumer:8083/api/v1`.
- El dashboard compila con sus devDependencies dentro de la imagen, no solo con dependencias de producción.

### DT-006: Compartición de Artefactos (Contractos API)

**Hoy**: Documentación centralizada en `/plan/contratos_api.md`

**Después**: 
- **Copia** en `gaiax-health-deployment/docs/api-contracts.md` (fuente de verdad)
- Cada repo backend referencia desde su `README.md`:
  ```markdown
  See API contracts in [main deployment repo](../gaiax-health-deployment/docs/api-contracts.md)
  ```
- **FHIR fixtures** (fixtures FHIR de prueba) se replican o referencian desde deployment

### DT-007: Configuración Ambiental (.env)

**Centralizado en `gaiax-health-deployment/.env.example`**:
```env
# Database (si es necesario en futuro)
GAIAX_DB_HOST=db
GAIAX_DB_PORT=5432
GAIAX_DB_NAME=gaiax_health

# Service Base URLs (usados por Docker Compose)
GAIAX_PROVIDER_BASE_URL=http://provider:8080
GAIAX_TRUST_BASE_URL=http://trust:8080
GAIAX_CONSUMER_BASE_URL=http://consumer:8080

# Frontend
VITE_API_URL=http://consumer:8080

# Observabilidad (futuro)
PROMETHEUS_ENABLED=true
OPENTELEMETRY_ENABLED=true
```

Cada servicio puede tener su `.env.example` local también.

---

## Estructura de Dockerfiles

### Backend Dockerfile Pattern (igual para provider, trust, consumer)

```dockerfile
# gaiax-health-provider-node/Dockerfile
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /build/target/*.jar app.jar
HEALTHCHECK --interval=10s --timeout=3s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Frontend Dockerfile

```dockerfile
# gaiax-health-dashboard/Dockerfile
FROM node:18-alpine AS builder
WORKDIR /build
COPY package*.json .
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /build/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
HEALTHCHECK --interval=10s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/health || exit 1
CMD ["nginx", "-g", "daemon off;"]
```

---

## ADR Técnicos

### ADR-006A: Polyrepo con Versionado Independiente
**Motivación**: Cada servicio evoluciona a ritmo diferente. Versionado independiente permite:
- Provider hacer patch bug sin impactar Consumer
- Upgrade gradual de versiones
- CI/CD futuro por servicio

**Consecuencias**:
- (+) Mayor flexibilidad en releases
- (+) Ownership claro por servicio
- (-) Overhead: matriz de compatibilidad hay que mantener
- (-) Testing E2E más crítico (validar compatibilidades)

### ADR-007: Repo Orquestador "Deployment"
**Motivación**: Centralizar Docker Compose, docs y scripts de setup evita duplicación y facilita la orquestación.

**Consecuencias**:
- (+) Single source of truth para E2E deployment
- (+) Docs centralizadas
- (-) Nuevo repo "meta" que hay que clonar primero

### ADR-008: Compatibilidad API Versionada Explícita
**Motivación**: Contratos de API deben ser estables y versionados. Se documenta qué versiones de servicios son compatibles.

**Consecuencias**:
- (+) Contratos claros
- (+) Usuarios saben qué versiones usar juntas
- (-) Requiere disciplina en testing y changelog

---

## Contratos Técnicos (sin cambios, pero replicados)

Los contratos OpenAPI existentes (`plan/contratos_api.md`) se replicarán:
- **Fuente**: `gaiax-health-deployment/docs/api-contracts.md`
- **Refs**: Cada servicio links a deployment

No hay cambios en **interfaces públicas** — es puro refactoring interno.

---

## Observabilidad y Debugging

### Logs Centralizados (Docker Compose)
```bash
docker compose -f gaiax-health-deployment/docker-compose.yml logs -f
docker compose logs -f provider          # Solo provider
docker compose logs -f trust trust       # Solo trust
```

### Health Checks
Cada servicio expone `/actuator/health` (backend) o `/health` (frontend).
Docker Compose valida antes de pasar a siguiente servicio.

---

## Riesgos Técnicos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|-----------|
| Rutas relativas en docker-compose rotas | Media | alto | Documentar setup.sh; testear en CI |
| Versiones incompatibles entre servicios | Baja | Medio | Matriz de versiones en deployment; tests E2E |
| Build time aumenta (4 builds en lugar de 1) | Baja | Bajo | Cachés de build Docker; compilación paralela |
| Cruces de dependencias circulares | Muy baja | Alto | Revisar imports durante migración |

---

## Plan de Transición

**Fase A - Preparación** (sin cambios en main):
- Crear 4 nuevos repos locales/GitHub
- Copiar código (sin modificar)
- Verificar builds independientes
- Crear deployment orchestrator

**Fase B - Validación** (Docker Compose):
- `docker compose up` desde deployment
- Tests E2E (flujo completo)
- Validar URLs (localhost:3000, :8081, etc.)

**Fase C - Cutover**:
- Archivar monorepo actual (conservar como histórico si es necesario)
- GitHub ahora apunta a los 5 repos polyrepo
- Documentación actualizada

**Fase D - Post-migración**:
- Scripts de setup local
- CI/CD incipiente (workflows)

---

## Impacto en Documentación

### `plan/analisis_tecnico.md` (raíz)
- Reforzar ADR-006 (polyrepo decision)
- Agregar links a los 5 repos

### `plan/contratos_api.md`
- Mover a `gaiax-health-deployment/docs/api-contracts.md`
- Keeper link desde `plan/`

### README (TFG raíz)
- Simplificar; referir a `gaiax-health-deployment/README.md` como README principal de deployment

---

## Testing E2E en Polyrepo

Dentro de `gaiax-health-deployment/`:
```bash
# Script que valida compatibilidad
scripts/validate-stack.sh

# Ejecuta:
# 1. docker compose build
# 2. docker compose up
# 3. Smoke tests en Provider API
# 4. Smoke tests en Trust API
# 5. Smoke tests en Consumer API
# 6. E2E flow test
# 7. curl http://localhost:3000 (frontend)
```

---

**Fin Fase 2: Análisis Técnico**

¿Deseas modificar algo o lo doy por válido para continuar a Fase 3 (Tareas)?
