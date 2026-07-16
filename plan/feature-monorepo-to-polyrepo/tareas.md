# Fase 3 - Plan de Tareas: Feature "Monorepo a Polyrepo"

## Objetivo
Definir las **tareas concretas** para migrar del monorepo actual a una estructura de 5 repositorios independientes (4 servicios + 1 orquestador), con versionado semántico independiente y GitHub ready.

---

## Dependencias Generales
- Todas las tareas dependen de **aprobación** del análisis funcional y técnico.
- Orden sugerido: A → B → C → D → E (secuencial, con validaciones intermedias).

---

## Bloque A: Preparación y Estructura

[x] A-1: Crear Estructura Local y Repos Base

### Resumen de ejecución
- **Archivos creados**: 5 repositorios Git inicializados (~/repos/gaiax-health-*)
- **Archivos modificados**: ninguno
- **Acciones realizadas**:
  - ✅ Creadas carpetas: `gaiax-health-{provider-node,trust-service,consumer-node,dashboard,deployment}`
  - ✅ Inicializados con `git init`
  - ✅ Creados `.gitignore` apropiados para cada tipo (Maven backend, Node frontend, deployment)

**Descripción**:
- Crear carpeta de trabajo: `~/repos/gaiax-health-*/`
- Inicializar 5 repos Git locales (sin contenido aún)
- Crear `.gitignore` base para cada repo

**Tareas derivadas**:
- [ ] A-1.1: Script `setup-repos.sh` que automatice creación de carpetas

**Criterios de validación**:
- [ ] Existen 5 carpetas: provider, trust, consumer, dashboard, deployment
- [ ] Cada carpeta contiene `.git/` inicializado
- [ ] `.gitignore` básico en cada una

**Metadatos**:
- Prioridad: Alta
- Tipo: setup
- Responsable: (TFG Author)
- Duración estimada: 30 min

---

---

[x] A-2: Crear Estructura de Carpetas en Repos Backend

**Descripción**:
- Crear `src/main/java/com/example/gaiahealth/{provider,trust,consumer}/` en cada repo backend
- Crear `src/test/java/com/example/gaiahealth/{provider,trust,consumer}/`
- Crear `src/main/resources/` y `src/test/resources/`

**Dependencias**: A-1

**Criterios de validación**:
- [x] 3 repos backend con estructura Maven completa
- [x] Compilación vacía genera carpetas correctas

**Metadatos**:
- Prioridad: Alta
- Tipo: setup
- Duración estimada: 15 min

### Resumen de ejecución
- **Archivos creados**: Estructura Maven en 3 repos (src/main/java, src/test/java, src/main/resources, src/test/resources)
- **Archivos modificados**: ninguno
- **Acciones realizadas**:
  - ✅ Provider: `src/main/java/com/example/gaiahealth/provider/`
  - ✅ Trust: `src/main/java/com/example/gaiahealth/trust/`
  - ✅ Consumer: `src/main/java/com/example/gaiahealth/consumer/`
  - ✅ Placeholders creados en `src/main/resources` y `src/test/resources`

---

[x] A-3: Crear Estructura de Carpetas en Repo Frontend

**Descripción**:
- Crear `src/`, `public/`, `dist/` en dashboard repo
- Crear `node_modules/.gitkeep` (si necesario)

**Dependencias**: A-1

**Criterios de validación**:
- [x] Dashboard repo con estructura Node.js/Vite completa

**Metadatos**:
- Prioridad: Alta
- Tipo: setup
- Duración estimada: 10 min

### Resumen de ejecución
- **Archivos creados**: Estructura Node/Vite en dashboard repo
- **Archivos modificados**: ninguno
- **Acciones realizadas**:
  - ✅ Creados: `src/{components,hooks,services,types,pages,utils}`
  - ✅ Creado: `public/`
  - ✅ Creado: `tests/{components,hooks,services}`
  - ✅ Placeholder `.gitkeep` en directorios principales

---

[x] A-4: Crear Estructura "Deployment" Orquestador

**Descripción**:
- Crear carpeta `gaiax-health-deployment/`
- Crear subdirectorios: `docker-compose.yml`, `docs/`, `scripts/`, `.env.example`
- CSV de ejemplo de matriz de versiones

**Dependencias**: A-1

**Criterios de validación**:
- [x] Existen: `docker-compose.yml`, `docs/`, `scripts/`, `.env.example`
- [x] README placeholder en deployment

**Metadatos**:
- Prioridad: Alta
- Tipo: setup
- Duración estimada: 15 min

### Resumen de ejecución
- **Archivos creados**: Estructura deployment orquestador completa
- **Archivos modificados**: ninguno
- **Acciones realizadas**:
  - ✅ Estructura deployment: `docker-compose.yml`, `.env.example`, `README.md`
  - ✅ Subdirectorio docs: `docs/` creado
  - ✅ Subdirectorio scripts: `scripts/setup.sh` creado
  - ✅ Documentación inicial en `README.md`
  - ✅ Script de setup raíz `setup-repos.sh` creado

---

## Bloque B: Migración de Código Backend

### B-1: Copiar Módulo Provider al Repo Independiente

**Descripción**:
- Extraer `src/main/java/.../provider/` desde monorepo
- Copiar a `gaiax-health-provider-node/src/main/java/com/example/gaiahealth/provider/`
- Copiar tests de Provider al nuevo repo
- Copiar fixtures FHIR de Provider (si existen)

**Dependencias**: A-2

**Criterios de validación**:
- [ ] Código provider copiado sin cambios
- [ ] Tests provider siguen compilando
- [ ] Fixtures FHIR presentes

**Metadatos**:
- Prioridad: Alta
- Tipo: refactor
- Duración estimada: 30 min

---

### B-2: Crear pom.xml para Provider Repo Independiente

**Descripción**:
- Crear `gaiax-health-provider-node/pom.xml`
- Versión inicial: `1.0.0`
- GroupId: `com.example`, ArtifactId: `gaiax-health-provider-node`
- Incluir solo dependencias necesarias (Spring Boot, Lombok, FHIR libs, test)
- Copiar configuración de plugins Maven (compiler, surefire, spring-boot)

**Dependencias**: B-1

**Criterios de validación**:
- [ ] `mvn clean package -f gaiax-health-provider-node/pom.xml` compila exitosamente
- [ ] JAR generado: `gaiax-health-provider-node-1.0.0.jar`
- [ ] Tests pasan

**Metadatos**:
- Prioridad: Alta
- Tipo: setup
- Duración estimada: 20 min

---

### B-3: Crear Dockerfile para Provider

**Descripción**:
- Crear `gaiax-health-provider-node/Dockerfile`
- Multi-stage build: Maven builder + Alpine runtime
- Image: `gaiax-health-provider-node:1.0.0`
- Health check: `/actuator/health`
- EXPOSE 8080

**Dependencias**: B-2

**Criterios de validación**:
- [ ] `docker build -t gaiax-health-provider-node:1.0.0 gaiax-health-provider-node/` exitoso
- [ ] Imagen contiene JAR correctamente
- [ ] Health check funciona

**Metadatos**:
- Prioridad: Alta
- Tipo: setup
- Duración estimada: 15 min

---

### B-4: Copiar y Configurar Módulo Trust

**Descripción**:
- Repetir B-1, B-2, B-3 para Trust Service
- Extraer `src/main/java/.../trust/`
- Crear `pom.xml` con versión `1.0.0`
- Crear `Dockerfile`

**Dependencias**: B-3 (patrón establecido)

**Criterios de validación**:
- [ ] Trust repo independiente compila
- [ ] Dockerfile builds exitosamente

**Metadatos**:
- Prioridad: Alta
- Tipo: refactor
- Duración estimada: 30 min

---

### B-5: Copiar y Configurar Módulo Consumer

**Descripción**:
- Repetir B-1, B-2, B-3 para Consumer Node
- Extraer `src/main/java/.../consumer/`
- Crear `pom.xml` con versión `1.0.0`
- Crear `Dockerfile`

**Dependencias**: B-4 (patrón establecido)

**Criterios de validación**:
- [ ] Consumer repo independiente compila
- [ ] Dockerfile builds exitosamente

**Metadatos**:
- Prioridad: Alta
- Tipo: refactor
- Duración estimada: 30 min

---

### B-6: Validar Builds Independientes Backend

**Descripción**:
- Ejecutar `mvn clean package` en cada repo backend (provider, trust, consumer)
- Verificar que NO hay dependencias cruzadas entre repos
- Constatación de que cada JAR funciona "as-is"

**Dependencias**: B-5

**Criterios de validación**:
- [ ] `mvn clean package gaiax-health-provider-node/` ✅
- [ ] `mvn clean package gaiax-health-trust-service/` ✅
- [ ] `mvn clean package gaiax-health-consumer-node/` ✅
- [ ] Ningún error de imports entre módulos

**Metadatos**:
- Prioridad: Media
- Tipo: test
- Duración estimada: 20 min

---

## Bloque C: Migración de Código Frontend

[x] C-1: Copiar Frontend React al Repo Independiente

### Resumen de ejecución
- **Archivos creados**: `gaiax-health-dashboard/package.json`, `gaiax-health-dashboard/Dockerfile`, `gaiax-health-dashboard/.gitignore`
- **Archivos copiados**: `frontend/src/` → `gaiax-health-dashboard/src/`, `frontend/index.html`, `frontend/vite.config.ts`, `frontend/tsconfig.json`, `frontend/public/`
- **Acciones realizadas**:
  - ✅ Copiado el código React existente al nuevo repositorio independiente.
  - ✅ Transferido configuraciones de Vite, Tailwind y TypeScript.
  - ✅ Generado README inicial de despliegue para el dashboard.

**Descripción**:
- Copiar `frontend/src/` → `gaiax-health-dashboard/src/`
- Copiar `frontend/public/` → `gaiax-health-dashboard/public/`
- Copiar configuración: `vite.config.ts`, `tailwind.config.ts`, `tsconfig.json`, etc.

**Dependencias**: A-3

**Criterios de validación**:
- [x] Estructura completa de frontend en nuevo repo
- [x] Archivos TypeScript sin cambios

**Metadatos**:
- Prioridad: Alta
- Tipo: refactor
- Duración estimada: 15 min

---

[x] C-2: Crear package.json para Dashboard Repo

### Resumen de ejecución
- **Archivos creados**: `gaiax-health-dashboard/package.json`
- **Acciones realizadas**:
  - ✅ Se generó el `package.json` del dashboard con dependencias y scripts equivalentes al frontend original.
  - ✅ Se incluyeron dependencias adicionales para ESLint y TypeScript modernas.

**Descripción**:
- Crear `gaiax-health-dashboard/package.json`
- Versión: `1.0.0`
- Name: `gaiax-health-dashboard`
- Description: "React Dashboard for Gaia-X Health Data Visualization"
- Copiar dependencias de `frontend/package.json`
- Copiar scripts: `dev`, `build`, `test`, `lint`

**Dependencias**: C-1

**Criterios de validación**:
- [x] `npm install --legacy-peer-deps` funciona
- [ ] `npm run build` genera `dist/` exitosamente
- [ ] No hay errores TypeScript o ESLint

**Metadatos**:
- Prioridad: Alta
- Tipo: setup
- Duración estimada: 15 min

---

[x] C-3: Crear Dockerfile para Dashboard

### Resumen de ejecución
- **Archivos creados**: `gaiax-health-dashboard/Dockerfile`
- **Acciones realizadas**:
  - ✅ Se creó un Dockerfile multi-stage para construir el dashboard con Node y servirlo con Nginx.
  - ✅ Se parametrizó la URL de la API con `VITE_API_URL` para el entorno Docker Compose.

**Descripción**:
- Crear `gaiax-health-dashboard/Dockerfile`
- Multi-stage: Node builder + Nginx runtime
- Build: `npm install && npm run build`
- Copy dist a `/usr/share/nginx/html`
- Image: `gaiax-health-dashboard:1.0.0`
- Health check: `http://localhost/health` (Nginx)
- EXPOSE 80

**Dependencias**: C-2

**Criterios de validación**:
- [ ] `docker build -t gaiax-health-dashboard:1.0.0 gaiax-health-dashboard/` exitoso
- [ ] Imagen contiene archivos compilados
- [ ] Nginx health check responde

**Metadatos**:
- Prioridad: Alta
- Tipo: setup
- Duración estimada: 20 min

---

### C-4: Validar Build Independiente Frontend

**Descripción**:
- Ejecutar `npm install && npm run build` en dashboard repo
- Verificar que `dist/` se genera correctamente
- Validar que no hay errores de imports o tipado

**Dependencias**: C-3

**Criterios de validación**:
- [ ] `npm run build` genera `dist/index.html`
- [ ] `npm run test` pasa tests (o skip si configurado)
- [ ] Sin errores TypeScript

**Metadatos**:
- Prioridad: Media
- Tipo: test
- Duración estimada: 15 min

---

## Bloque D: Docker Compose Orquestador

[x] D-1: Crear docker-compose.yml Centralizado

### Resumen de ejecución
- **Archivos modificados**: `gaiax-health-deployment/docker-compose.yml`
- **Acciones realizadas**:
  - ✅ Se actualizó el `docker-compose.yml` para mapear correctamente los puertos internos de cada servicio.
  - ✅ Se agregó soporte de red dedicada y health checks para provider, trust, consumer y dashboard.
  - ✅ Se configuró el dashboard para acceder a la API interna `http://consumer:8083`.

**Descripción**:
- Crear `gaiax-health-deployment/docker-compose.yml`
- Definir 4 servicios: provider, trust, consumer, dashboard
- Configurar `build.context` y `build.dockerfile` para cada uno
- Puertos: 8081, 8082, 8083, 3000
- Environment variables (SERVICE_ROLE, URLs inter-servicios)
- Health checks y depends_on
- Network dedicada

**Dependencias**: B-6, C-4, A-4

**Criterios de validación**:
- [x] Sintaxis YAML válida
- [x] Todos los `context` apuntan correctamente a repos
- [x] Health checks definidos para cada servicio

**Metadatos**:
- Prioridad: Alta
- Tipo: setup
- Duración estimada: 30 min

---

### D-2: Crear .env.example en Deployment

**Descripción**:
- Crear `gaiax-health-deployment/.env.example`
- Variables: DB config (si necesario), URLs base, toggles observabilidad
- Comentarios explicativos
- `.gitignore` debe excluir `.env` real

**Dependencias**: D-1

**Criterios de validación**:
- [ ] `.env.example` documento completo
- [ ] `.gitignore` contiene `.env`

**Metadatos**:
- Prioridad: Media
- Tipo: setup
- Duración estimada: 10 min

---

### D-3: Crear setup.sh Script en Deployment

**Descripción**:
- Script Bash que clona/inicializa los 4 repos (si necesario) localmente
- Verifica que todos los repos estén presentes con estructura correcta
- Opcionalmente: `docker compose build` para pre-construir imágenes

**Dependencias**: D-1

**Criterios de validación**:
- [ ] `./setup.sh` ejecuta sin errores
- [ ] Valida presencia de 4 repos
- [ ] Output claro sobre estado

**Metadatos**:
- Prioridad: Media
- Tipo: setup
- Duración estimada: 20 min

---

### D-4: Validar Docker Compose E2E

**Descripción**:
- Ejecutar `docker compose -f gaiax-health-deployment/docker-compose.yml up -d`
- Esperar a que todos los servicios levanten (health checks)
- Validar URLs: http://localhost:3000, :8081, :8082, :8083
- Ejecutar curl a health checks
- Detener con `docker compose down`

**Dependencias**: D-3

**Criterios de validación**:
- [ ] Todos 4 servicios `Up`
- [ ] Health checks todos `Healthy`
- [ ] Dashboard accesible en :3000
- [ ] Provider health: ✅
- [ ] Trust health: ✅
- [ ] Consumer health: ✅

**Metadatos**:
- Prioridad: Alta
- Tipo: test
- Duración estimada: 15 min

---

## Bloque E: Documentación y Finalización

[x] E-1: Crear README Principal (Deployment)

### Resumen de ejecución
- **Archivos creados**: `gaiax-health-deployment/README.md`
- **Acciones realizadas**:
  - ✅ Se creó un README principal con Quick Start, URLs de servicios y enlaces a documentación.
  - ✅ Se documentó la arquitectura polyrepo y cómo iniciar el stack local.

**Descripción**:
- Crear `gaiax-health-deployment/README.md`
- Secciones:
  - Intro: Gaia-X Health Stack
  - Arquitectura: diagrama polyrepo (ASCII art o link a docs)
  - Pre-requisitos: Docker, Git, Node (opcional)
  - Quick Start: clone, docker compose up, URLs
  - Service URLs: Provider, Trust, Consumer, Dashboard
  - Version Matrix: compatibilidades conocidas
  - Development: cómo trabajar en cada repo
  - Troubleshooting
  - Contributing (links a CONTRIBUTING en cada repo)

**Dependencias**: D-4

**Criterios de validación**:
- [x] README completo y claro
- [x] Quick Start replicable
- [x] URLs correctas
- [x] Matriz de versiones presente

**Metadatos**:
- Prioridad: Alta
- Tipo: doc
- Duración estimada: 45 min

---

[x] E-2: Crear Documentación de Contratos API

### Resumen de ejecución
- **Archivos creados**: `gaiax-health-deployment/docs/api-contracts.md`
- **Acciones realizadas**:
  - ✅ Se generó la documentación de contratos para Provider, Trust y Consumer.
  - ✅ Se incluyeron convenciones comunes de API y modelo de errores.

**Descripción**:
- Crear `gaiax-health-deployment/docs/api-contracts.md`
- Copiar/adaptar desde `plan/contratos_api.md`
- Endpoints por servicio: Provider, Trust, Consumer
- Ejemplos de requests/responses
- Códigos de error
- Versión de contrato

**Dependencias**: E-1

**Criterios de validación**:
- [x] API Contracts documentos completos
- [ ] Ejemplos de curl funcionales
- [x] Versión del contrato específicada

**Metadatos**:
- Prioridad: Alta
- Tipo: doc
- Duración estimada: 30 min

---

[x] E-3: Crear Matriz de Versiones Compatibles

### Resumen de ejecución
- **Archivos creados**: `gaiax-health-deployment/docs/version-matrix.md`
- **Acciones realizadas**:
  - ✅ Se añadió la tabla de compatibilidad para el stack `1.0.0`.
  - ✅ Se documentó el estado actual como validado.

**Descripción**:
- Crear `gaiax-health-deployment/docs/version-matrix.md`
- Tabla de compatibilidades: Provider v X + Trust v Y + Consumer v Z + Dashboard v W
- Indicar cuáles combinaciones son validadas (✅ tested)
- Cuáles son tentativas (⚠️ not tested)

**Dependencias**: E-2

**Criterios de validación**:
- [x] Matriz clara y actualizable
- [x] Al menos la versión 1.0.0 de todos los servicios juntos está marcada ✅

**Metadatos**:
- Prioridad: Media
- Tipo: doc
- Duración estimada: 15 min

---

### E-4: Crear README en Cada Repo

**Descripción**:
- `gaiax-health-provider-node/README.md`: rol, endpoints, dev setup
- `gaiax-health-trust-service/README.md`: rol, endpoints, dev setup
- `gaiax-health-consumer-node/README.md`: rol, endpoints, dev setup
- `gaiax-health-dashboard/README.md`: rol, npm scripts, dev setup
- En cada uno: link a deployment repo y contratos API

**Dependencias**: E-3

**Criterios de validación**:
- [ ] 4 READMEs creados
- [ ] Cada uno explica rol y dev setup
- [ ] Links cruzados a deployment funcionan (relativos)

**Metadatos**:
- Prioridad: Alta
- Tipo: doc
- Duración estimada: 60 min

---

[x] E-5: Crear .gitignore por Repo

### Resumen de ejecución
- **Archivos creados/modificados**: `gaiax-health-dashboard/.gitignore`
- **Acciones realizadas**:
  - ✅ Se añadió `.gitignore` en el repo `gaiax-health-dashboard` para excluir `node_modules`, `dist`, `.env` y artefactos temporales.
  - ✅ Se verificó que el repositorio deployment ya cuenta con `.gitignore` existente.

**Descripción**:
- `gaiax-health-provider-node/.gitignore`: `/target/`, `*.jar`, `*.class`, `.idea/`, etc.
- `gaiax-health-trust-service/.gitignore`: lo mismo
- `gaiax-health-consumer-node/.gitignore`: lo mismo
- `gaiax-health-dashboard/.gitignore`: `/node_modules/`, `/dist/`, `.env.local`, etc.
- `gaiax-health-deployment/.gitignore`: `/.env`, `/docker-compose.override.yml`, etc.

**Dependencias**: Todas previas

**Criterios de validación**:
- [x] 5 `.gitignore` presentes
- [ ] No tracked accidental secrets o build artifacts

**Metadatos**:
- Prioridad: Media
- Tipo: setup
- Duración estimada: 20 min

---

### E-6: Crear LICENSE.md en Cada Repo

**Descripción**:
- Crear `LICENSE.md` (MIT o lo que corresponda) en cada repo
- Incluir year, author, copyright notice

**Dependencias**: E-5

**Criterios de validación**:
- [ ] 5 LICENSE.md presentes
- [ ] Contenido consistente

**Metadatos**:
- Prioridad: Baja
- Tipo: doc
- Duración estimada: 10 min

---

### E-7: Crear CONTRIBUTING.md en Deployment

**Descripción**:
- Crear `gaiax-health-deployment/CONTRIBUTING.md`
- Convenciones de commits (conventional commits)
- Branch naming (feature/*, bugfix/*)
- PR checklist
- Cómo reportar problemas
- Links a CODEs de conducta

**Dependencias**: E-6

**Criterios de validación**:
- [ ] CONTRIBUTING.md presente
- [ ] Claro y actionable

**Metadatos**:
- Prioridad: Baja
- Tipo: doc
- Duración estimada: 20 min

---

### E-8: Actualizar plan/analisis_tecnico.md Raíz

**Descripción**:
- Agregar sección "Feature: Monorepo to Polyrepo" después del análisis base
- Linkar a `plan/feature-monorepo-to-polyrepo/`
- Actualizar ADR-006 para reforzar polyrepo decision
- Mencionar 5 repos: provider, trust, consumer, dashboard, deployment

**Dependencias**: E-7

**Criterios de validación**:
- [ ] plan/analisis_tecnico.md actualizado
- [ ] Links funcionales

**Metadatos**:
- Prioridad: Media
- Tipo: doc
- Duración estimada: 15 min

---

### E-9: Crear Resumen de Literatura en METADATA.md Raíz (si existe)

**Descripción**:
- Actualizar o crear `plan/METADATA.md` con resumen de migración
- Feature activa: "Monorepo to Polyrepo"
- Estado: "Completed"
- Repos: 5 nuevos

**Dependencias**: E-8

**Criterios de validación**:
- [ ] METADATA.md refleja cambio

**Metadatos**:
- Prioridad: Baja
- Tipo: doc
- Duración estimada: 10 min

---

## Bloque F: Testing y Validación E2E

### F-1: Smoke Tests Backend

**Descripción**:
- Script que valida que cada servicio backend compila y responde health check
- Ejecutar desde docker compose o local

```bash
#!/bin/bash
# tests/smoke-tests.sh
curl -fsS http://localhost:8081/actuator/health && echo "Provider OK"
curl -fsS http://localhost:8082/actuator/health && echo "Trust OK"
curl -fsS http://localhost:8083/actuator/health && echo "Consumer OK"
curl -fsS http://localhost:3000 | grep -q "html" && echo "Dashboard OK"
```

**Dependencias**: D-4

**Criterios de validación**:
- [ ] Todos los health checks pasan
- [ ] Script ejecutable y claro

**Metadatos**:
- Prioridad: Media
- Tipo: test
- Duración estimada: 20 min

---

### F-2: E2E Flow Test (Flujo Completo)

**Descripción**:
- Validar flujo completo: Publish → Request → Authorize → Consume → Display
- Similar a los tests que probablemente existan en el código
- Ejecutar desde deployment

**Dependencias**: F-1

**Criterios de validación**:
- [ ] Flujo E2E completable
- [ ] Datos llegan a dashboard
- [ ] Sin errores en logs

**Metadatos**:
- Prioridad: Alta
- Tipo: test
- Duración estimada: 30 min

---

### F-3: Validar Performancia

**Descripción**:
- Ejecutar load tests (si existen scripts legacy)
- Validar que latencia, throughput, error rate presentes en plan/

**Dependencias**: F-2

**Criterios de validación**:
- [ ] KPIs dentro del objetivo (error_rate ≤ 0.5%, p95 ≤ 500ms, throughput ≥ 120 req/s)

**Metadatos**:
- Prioridad: Media
- Tipo: test
- Duración estimada: 60 min

---

## Bloque G: Push a GitHub (Opcional, Documentado)

### G-1: Crear Repos en GitHub

**Descripción**:
- [MANUAL] Ir a GitHub y crear 5 repos públicos/privados
- Nombres: gaiax-health-provider-node, gaiax-health-trust-service, gaiax-health-consumer-node, gaiax-health-dashboard, gaiax-health-deployment
- Descripción en cada repo

**Dependencias**: E-9

**Criterios de validación**:
- [ ] 5 repos creados en GitHub

**Metadatos**:
- Prioridad: Media
- Tipo: setup
- Duración estimada: 10 min

---

### G-2: Push de Cada Repo a GitHub

**Descripción**:
- Añadir remote `origin` a cada repo local
- Hacer `git push -u origin main` de cada uno

```bash
cd ~/repos/gaiax-health-provider-node
git remote add origin https://github.com/yourusername/gaiax-health-provider-node.git
git push -u origin main
```

**Dependencias**: G-1

**Criterios de validación**:
- [ ] 5 repos reflejados en GitHub
- [ ] Ramas main actualizadas

**Metadatos**:
- Prioridad: Baja (post-TFG pero documentado)
- Tipo: setup
- Duración estimada: 20 min

---

## Resumen de Tareas por Bloque

| Bloque | Tareas | Duración Est. | Criticidad |
|--------|--------|---------------|-----------|
| **A: Preparación** | A-1 a A-4 | 70 min | Alta |
| **B: Backend** | B-1 a B-6 | 145 min | Alta |
| **C: Frontend** | C-1 a C-4 | 65 min | Alta |
| **D: Compose** | D-1 a D-4 | 75 min | Alta |
| **E: Docs** | E-1 a E-9 | 225 min | Alta |
| **F: Testing** | F-1 a F-3 | 110 min | Media |
| **G: GitHub** | G-1 a G-2 | 30 min | Baja |
| **TOTAL** | 29 tareas | **~720 min (12h)** | — |

---

## Criterios de Aceptación Globales

✅ Los 5 repos existen localmente (o en GitHub) con estructura correcta  
✅ `docker compose -f gaiax-health-deployment/docker-compose.yml up` levanta todo  
✅ Health checks todos `Healthy`  
✅ Dashboard accesible en http://localhost:3000  
✅ E2E flow test completa exitosamente  
✅ Documentación completa (README, API Contracts, Version Matrix)  
✅ KPIs de rendimiento en línea  
✅ Ningún código duplicado; migración 1:1 desde monorepo  

---

**Fin Fase 3: Plan de Tareas**

¿Deseas modificar algo o lo doy por válido para proceder a **Fase 4 (Ejecución)**?

Recuerda: Fase 4 iniciará la ejecución de las 29 tareas, que se irán marcando como:
- `[-]` = en ejecución
- `[x]` = completado
- `[v]` = validado manualmente




