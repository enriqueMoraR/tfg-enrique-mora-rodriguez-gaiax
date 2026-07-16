# Fase 1 - Análisis Funcional: Feature "Monorepo a Polyrepo"

## Contexto
Actualmente, el proyecto **TFG Gaia-X Salud** compilar los **4 servicios en un JAR único**:
- 3 servicios backend (Provider, Trust, Consumer) — Sun Spring Boot JAR
- 1 frontend React — Servido por Nginx en Docker

**Necesidad identificada**: Separar en **4 repositorios independientes** para facilitar:
- Versionado semántico independiente por servicio
- Pipelines CI/CD aislados
- Equipos especializados (en contexto profesional)
- Mantenimiento a largo plazo post-TFG

## Objetivo Funcional Principal
Migrar de **monorepo** (un JAR multi-role) a **polyrepo** (4 repos independientes) sin perder funcionalidad, manteniendo **reproducibilidad local** y posibilidad de deployar en **GitHub**.

## Alcance Funcional de la Feature
1. **Segmentación de código fuente**:
   - `gaiax-health-provider-node` — Repo independiente (backend provider)
   - `gaiax-health-trust-service` — Repo independiente (backend trust)
   - `gaiax-health-consumer-node` — Repo independiente (backend consumer)
   - `gaiax-health-dashboard` — Repo independiente (frontend React)

2. **Repo orquestador** (`gaiax-health-deployment`):
   - `docker-compose.yml` centralizado
   - `README.md` con instrucciones de desplegarse E2E
   - Documentación de contratos API y versionado
   - Scripts de setup local

3. **Versionado independiente**:
   - Cada repo: `v1.0.0`, `v1.0.1`, etc. (semántico propio)
   - Compatibilidad de contratos API garantizada entre versiones

4. **GitHub readiness**:
   - `.gitignore`, `LICENSE.md` por repo
   - `CONTRIBUTING.md` en el repo orquestador
   - Workflow básico de sincronización local → GitHub

## Fuera de Alcance de esta Feature
- CI/CD automatizado en GitHub Actions (se plantea como roadmap post-TFG)
- Container registry privado (DockerHub/GitHub Packages)
- Helm charts o Kubernetes manifests (sin requisito en MVP)
- Federación de repos en organización GitHub (solo se documentará estructura)

## Actores y Responsabilidades
1. **Desarrollador local** (TFG):
   - Clona los 4 repos localmente
   - Estructura carpetas: `~/repos/gaiax-health-*/`
   - Ejecuta `docker compose` desde el repo orquestador

2. **CI/CD (futuro)**:
   - Build independiente por servicio/frontend
   - Versionado semántico automático

3. **Gestor de releases** (humano):
   - Define qué versiones de cada repo son compatibles
   - Documenta matriz en `gaiax-health-deployment`

## Flujos Funcionales

### FF1 - Setup Local Post-Migración
1. Clonar 4 repos desde local/GitHub
2. Posicionar en carpetas: `~/repos/gaiax-health-provider-node/`, etc.
3. Ejecutar `docker compose` desde `gaiax-health-deployment/`
4. Servicios levantan correctamente (mismo behavior que hoy)

### FF2 - Versionado Independiente
1. Provider hace release `v1.1.0` (cambio en contrato API)
2. Consumer y Trust NO necesitan cambiar si contrato es compatible
3. Docker Compose referencia versiones específicas por servicio

### FF3 - Desarrollo Local por Servicio
1. Dev modifica código en `gaiax-health-provider-node/`
2. Hace `mvn clean package` local
3. Construye imagen Docker: `gaiax-health-provider-node:local-v1.0.0`
4. Docker Compose levanta con esa imagen

### FF4 - Push a GitHub
1. Dev empuja rama feature a GitHub `gaiax-health-provider-node`
2. (Futuro) Workflow automático valida tests y crea release
3. Imagen se taguea `v1.x.x` y está disponible

## Requisitos Funcionales

- **RF-01**: Cada servicio backend debe compilable en repo independiente
- **RF-02**: Frontend React debe compilable en repo independiente
- **RF-03**: Docker Compose del orquestador levanta todo sin cambios en funcionamiento
- **RF-04**: Cada repo versionado independientemente (semántico)
- **RF-05**: README en repo orquestador explica cómo clonar, compilar y desplegar
- **RF-06**: Contratos API (OpenAPI) documentados y versionados
- **RF-07**: Setup local reproducible (same behavior que monorepo actual)

## Criterios de Aceptación

1. ✅ Los 4 repos **clonables y compilables** independientemente
2. ✅ `docker compose up` desde `gaiax-health-deployment/` **levanta los 4 servicios sin cambios**
3. ✅ README en deployment explica:
   - Estructura de los 4 repos
   - Comandos de setup local
   - URLs de acceso (localhost:3000, :8081, :8082, :8083)
   - Matriz de compatibilidad de versiones
4. ✅ `.gitignore`, `LICENSE`, `CONTRIBUTING.md` en cada repo
5. ✅ Cada repo contiene su propio `pom.xml` / `package.json`
6. ✅ **Sin regresiones**: mismos KPIs de rendimiento que hoy

## Impacto en Estructuras Existentes

### Plan Raíz
- Actualizar `analisis_tecnico.md` raíz: ADR-006 refuerza decisión polyrepo
- Actualizar `analisis_funcional.md` raíz con referencia a feature

### Docker-Compose
- Actual `docker-compose.yml` → se mueve a `gaiax-health-deployment/docker-compose.yml`
- Build context apunta a rutas correctas en polyrepo

### Documentación
- `plan/contratos_api.md` → se replica en `gaiax-health-deployment/docs/api-contracts.md`
- README (TFG raíz) → README principal va a `gaiax-health-deployment/README.md`

## Riesgos Funcionales y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|--------|-----------|
| Incompatibilidad entre versiones de servicios | Media | Alto | Matriz de compatibilidad documentada; tests E2E en deployment |
| Pérdida de conocimiento técnico en separación | Baja | Medio | Documentación de contratos y ADR en cada repo |
| Overhead de coordinación local durante desarrollo | Baja | Bajo | Scripts bash de setup; Docker Compose abstrae complejidad |

## Pregunta Funcional Pendiente
- ¿Queremos gitignore estricto para evitar secrets? → Sí, usar `/.env.local`, `/.env.production`

---

## Propuesta para README Deployment

El README en `gaiax-health-deployment/` debe incluir:
1. **Titulo**: " Gaia-X Salud — Deployment & Orchestration"
2. **Arquitectura**: diagrama polyrepo
3. **Pre-requisitos**: Docker, Git
4. **Quick Start**:
   ```bash
   # Clone all repos
   ./setup.sh

   # Start all services
   docker compose up -d

   # Access dashboard
   open http://localhost:3000
   ```
5. **Service URLs**: Provider, Trust, Consumer, Frontend
6. **Version Matrix**: compatibilidades garantizadas
7. **Development**: Cómo trabajar en cada repo
8. **Troubleshooting**: problemas comunes

---

## Impacto por Feature

### feature-cobertura-tests
- Tests E2E pueden referir a repos independientes
- Setup local debe usar mismo Docker Compose del deployment
- Documentación de fixtures FHIR centralizada

### feature-dashboard-pacientes
- Frontend aislado; deployment lo orquesta
- Cambios en componentes React no impactan otros servicios

---

**Fin Fase 1: Análisis Funcional**

¿Deseas modificar algo o lo doy por válido para continuar a Fase 2 (Análisis Técnico)?
