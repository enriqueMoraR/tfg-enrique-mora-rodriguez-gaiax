# Fase 2 - Analisis tecnico

## Entrada funcional aprobada
Este analisis tecnico implementa el alcance funcional definido en Fase 1:
- MVP de espacio de datos salud con 3 participantes.
- Flujo extremo a extremo: publicacion -> solicitud -> autorizacion -> consumo.
- Dos casos clinicos FHIR en MVP: tension arterial y frecuencia cardiaca.
- Pruebas de carga sobre volumen minimo de 10.000 eventos.
- Estrategia confirmada: `EDC-first`.

## Objetivo tecnico
Disenar una arquitectura ejecutable, modular y medible que permita demostrar soberania de datos, control de acceso y escalabilidad en un escenario Gaia-X compatible.

## Decisiones de estructura confirmadas
1. Estrategia de repositorio: tres repositorios separados (uno por servicio) y un repositorio adicional de orquestación para el despliegue.
2. Impacto en build:
- Cada repositorio mantiene su propio ciclo de build/versionado.
- Se requiere contrato API versionado y compatible entre repos.
3. Impacto en despliegue:
- Imagen y pipeline independientes por servicio.
- Orquestacion E2E centralizada via Docker Compose/Kubernetes con version matrix.
4. Feature de migración: la separación se gestiona mediante `feature-monorepo-to-polyrepo`, con documentación técnica en `plan/feature-monorepo-to-polyrepo/analisis_tecnico.md` y backlog en `plan/feature-monorepo-to-polyrepo/tareas.md`.

## Baseline de seguridad y observabilidad confirmada
1. Seguridad MVP:
- OAuth2 `client_credentials` con JWT firmado y validado entre servicios.
- Autorizacion basada en scopes/roles emitidos por `gaiax-health-trust-service`.
- API keys descartadas para el baseline oficial.
2. Observabilidad MVP:
- Logging estructurado en JSON con `trace_id` y `request_id`.
- Metricas Prometheus via endpoints de actuator.
- Trazas distribuidas con OpenTelemetry y muestreo para pruebas de carga.

## Arquitectura objetivo (MVP)
```
[gaiax-health-provider-node] <--> [gaiax-health-trust-service] <--> [gaiax-health-consumer-node]
             |                               |                                  |
      EDC Connector                   Policy + IAM + Audit                 EDC Connector
             +------------------------ Infra compartida --------------------+
                    (DB, mensajeria opcional, logs, metricas, traces)
```

## Proyectos IntelliJ definidos
1. `gaiax-health-provider-node`
- Rol: publicar datasets y metadatos FHIR.
- Base: EDC connector provider.
- Capacidades iniciales:
  - Registro de dataset.
  - Publicacion en catalogo del dominio.
  - Endpoint de transferencia controlada.

2. `gaiax-health-trust-service`
- Rol: capa de confianza/compliance para el MVP.
- Capacidades iniciales:
  - Gestion de identidad y rol basico.
  - Evaluacion de politicas de acceso.
  - Auditoria de solicitudes y decisiones.

3. `gaiax-health-consumer-node`
- Rol: solicitar acceso y consumir datasets autorizados.
- Base: EDC connector consumer.
- Capacidades iniciales:
  - Solicitud de acceso con finalidad.
  - Consumo de datos autorizado.
  - Job de postproceso analitico basico.

## Modelo de componentes tecnicos
1. Identity/IAM
- MVP: OAuth2 `client_credentials` con JWT firmado por el trust-service.
- Evolucion: DID/VC y trust anchors Gaia-X.

2. Policy enforcement
- Motor de reglas inicial (rol + finalidad + dataset).
- Politicas versionadas y auditables.

3. Catalogue
- MVP: catalogo integrado en conectores EDC (provider y consumer lo consultan via APIs de catalogo).
- Evolucion: catalogo federado desacoplado.

4. Data exchange
- Negociacion/aceptacion de acceso y transferencia a traves de conectores EDC.
- Registro obligatorio de eventos de intercambio.

5. Compliance/Audit
- Log estructurado de operaciones:
  - publicacion de dataset
  - solicitud de acceso
  - decision de politica
  - transferencia/consumo

## Contratos tecnicos iniciales
Documento detallado de contratos y validaciones:
- `plan/contratos_api.md`

### Provider
- `POST /datasets/fhir`: alta de dataset FHIR.
- `GET /datasets`: consulta de datasets publicados.

### Trust
- `POST /access-requests`: crear solicitud de acceso.
- `GET /access-requests/{id}`: estado de solicitud.
- `POST /policies/validate`: evaluacion explicita de politica.

### Consumer
- `POST /consumption-jobs`: iniciar consumo de dataset autorizado.
- `GET /consumption-jobs/{id}`: estado y resultado.

## Datos y estandares
- Formato principal MVP: FHIR R4.
- Casos del MVP:
  - `Observation` de tension arterial.
  - `Observation` de frecuencia cardiaca.
- Evolucion prevista: mapeo hacia OMOP/CDM para analitica secundaria.

## Estrategia de despliegue
1. Entorno local (obligatorio para MVP)
- Docker Compose con los 3 servicios y dependencias.
- Objetivo: reproducibilidad para desarrollo y defensa.

2. Entorno escalado (iteracion de rendimiento)
- Kubernetes para pruebas comparativas.
- Escalado horizontal por servicio para identificar cuellos de botella.

## Estrategia de pruebas
1. Pruebas funcionales tecnicas
- Smoke tests por servicio.
- Prueba E2E del flujo completo.

2. Pruebas de contrato
- Validacion de payloads FHIR y respuestas API.

3. Pruebas de carga
- Dataset base >= 10.000 eventos.
- Escenarios:
  - base (1 replica por servicio)
  - escalado provider
  - escalado trust
  - escalado consumer
- Metricas:
  - latencia p50/p95/p99 (objetivo `p95 <= 500 ms`)
  - throughput (objetivo `>= 120 req/s` en baseline)
  - error rate (objetivo `<= 0.5%` en baseline)
  - CPU/memoria por servicio

## Observabilidad
- Logging estructurado JSON con correlacion de peticiones (`trace_id`, `request_id`).
- Metricas de aplicacion/JVM exportadas para Prometheus.
- Trazabilidad de flujo entre servicios con OpenTelemetry.

## ADR tecnicos
### ADR-001 - Arquitectura en 3 proyectos IntelliJ
Se separan provider, trust y consumer para aislar responsabilidades y permitir escalado independiente.

### ADR-002 - EDC-first como stack base
EDC se elige por modularidad, separacion control/data plane y alineacion con stack Java.

### ADR-003 - FHIR-first para el MVP
Se inicia con FHIR por disponibilidad de datos y rapidez de validacion funcional.

### ADR-004 - Catalogo integrado en conectores en MVP
Se prioriza simplicidad inicial; catalogo federado se posterga a iteracion posterior.

### ADR-005 - Seguridad incremental
Autenticacion y politicas basicas en MVP, evolucionando a DID/VC y trust framework completo.

### ADR-006 - Tres repositorios separados
Cada servicio (provider, trust, consumer) se mantiene en repositorio independiente para aislar releases, ownership y pipelines.

### ADR-007 - Baseline OAuth2 + observabilidad intermedia
El MVP adopta OAuth2 `client_credentials` (JWT) y observabilidad intermedia (logs JSON, Prometheus, OpenTelemetry) para soportar diagnostico de rendimiento con KPIs exigentes.

## Riesgos tecnicos y mitigaciones
1. Curva de aprendizaje EDC
- Mitigacion: comenzar por un MVD y extender modulos solo cuando el flujo base sea estable.

2. Complejidad de compliance completa Gaia-X
- Mitigacion: fasear capacidades avanzadas para no bloquear el objetivo de escalabilidad del TFG.

3. Sobrecoste operacional de 3 servicios desde el inicio
- Mitigacion: automatizar arranque local y mantener contratos simples y versionados.

4. Incompatibilidades de tooling (Java 25 / Spring Boot 4)
- Mitigacion: validar build y dependencias al inicio de implementacion.

5. Mayor coste de coordinacion por multi-repo
- Mitigacion: governance de contratos (OpenAPI), versionado semantico y pipeline de compatibilidad cruzada.

## Impacto tecnico en README.md
El README final debe incluir:
1. Arquitectura tecnica con los 3 proyectos.
2. Responsabilidades de cada servicio.
3. Guia de arranque local (compose) y escenario de pruebas.
4. KPIs de rendimiento y criterios de aceptacion tecnica.
5. ADR relevantes y limites del MVP.

## Decisiones pendientes (media criticidad)
1. (ninguna en seguridad/observabilidad para MVP actual).

## Integracion e impactos por feature
### feature-cobertura-tests
- Objetivo tecnico: introducir una estrategia de pruebas en tres niveles (unitario, funcional, sistema) usando fixtures FHIR reales.
- Documento de referencia: `plan/feature-cobertura-tests/analisis_tecnico.md`.
- Integracion con arquitectura actual:
  - no cambia contratos API publicos;
  - incrementa cobertura sobre `provider`, `trust` y `consumer`;
  - anade verificacion E2E automatizada dentro del propio repo.

### feature-dashboard-pacientes
- Objetivo tecnico: frontend React/Vite para consulta de pacientes con snapshot local de 20 registros y detalle clicable.
- Documento de referencia: `plan/feature-dashboard-pacientes/analisis_tecnico.md`.
- Integracion con arquitectura actual:
  - usa `gaiax-health-dashboard/src/data/preloadedPatients.ts` generado desde fixtures FHIR del consumer;
  - renderiza `PreloadedPatientsTable` debajo del buscador;
  - mantiene `searchPatients(query)` como fallback para busquedas manuales;
  - no cambia los contratos API del backend;
  - añade una capa de demo local sin acoplar el dashboard a una carga inicial remota.

### feature-monorepo-to-polyrepo (NUEVA)
- Objetivo tecnico: migrar de monorepo (1 JAR multi-role) a polyrepo (5 repos independientes: provider, trust, consumer, dashboard, deployment).
- Documento de referencia: `plan/feature-monorepo-to-polyrepo/analisis_tecnico.md`.
- Integracion con arquitectura actual:
  - refuerza ADR-006 (separacion de repos como decision arquitectonica);
  - introduce versionado semantico independiente por servicio;
  - centraliza orquestacion en repo "deployment" con Docker Compose;
  - mantiene contratos API sin cambios (refactoring puro);
  - facilita futuros deployments en produccion y teams distribuidos.
- Timeline: ~12h (29 tareas en 4 bloques de ejecucion).

### feature-gaiax-health-hardening (NUEVA)
- Objetivo tecnico: incorporar validacion FHIR/IPS estricta, PEP/PDP con consentimiento granular, identidad federada OIDC/SIOP, minimizacion de datos en dashboard y despliegue con controles de soberania.
- Documento de referencia: `plan/feature-gaiax-health-hardening/analisis_tecnico.md`.
- Integracion con arquitectura actual:
  - `provider`: validacion FHIR estricta en entrada, metadatos de soberania y exposicion minima de payloads;
  - `trust-service`: modelo de consentimiento por tiempo/proposito/receptor y evaluacion de politicas como PDP;
  - `consumer-node`: propagacion de identidad federada, uso de permisos emitidos y bloqueo si no existe consentimiento vigente;
  - `dashboard`: consultas reducidas con `_summary`/`_elements` o equivalente y superficie visual que muestra consentimiento y provenance;
  - `deployment`: red segregada, TLS, secretos, trazabilidad y, si procede, adaptador de conector federado;
  - mantiene los contratos API como base, pero endurece validaciones y seguridad de extremo a extremo.

### feature-fhir-observation
- Objetivo tecnico: ampliar el contrato del stack para aceptar `Observation` directas con metadatos FHIR de provenance y soberania, manteniendo compatibilidad con `Bundle`.
- Documento de referencia: `plan/feature-fhir-observation/analisis_tecnico.md`.
- Integracion con arquitectura actual:
  - `provider`: valida `Observation` directa y conserva la compatibilidad con bundles;
  - `consumer`: mantiene contexto clinico como `issued`, `device`, `performer` y `bodySite`;
  - `dashboard`: amplía tipos y transformadores para mostrar el nuevo recurso real sin perder minimizacion;
  - `tests/fixtures`: incorpora el JSON real del usuario como caso de contrato;
  - mantiene el flujo E2E actual, pero con payloads mas fieles al dominio sanitario.

### feature-analisis-mediciones
- Objetivo tecnico: nueva pantalla analitica en React para explorar tendencias, distribuciones y comparaciones sobre grandes volúmenes de observaciones FHIR.
- Documento de referencia: `plan/feature-analisis-mediciones/analisis_tecnico.md`.
- Integracion con la arquitectura actual:
  - reutiliza el proxy `/api/fhir` del dashboard para leer `Patient` y `Observation`;
  - introduce una capa de adaptacion FHIR a un modelo analitico compacto;
  - desacopla la logica de estadisticas de los componentes visuales;
  - usa ECharts por su soporte nativo para grandes volúmenes, zoom, boxplot y scatter plot;
  - mantiene la navegacion y el estilo del dashboard existente.

### feature-clean-architecture
- Objetivo tecnico: introducir una separacion real de capas en backend y una organizacion por features en frontend.
- Documento de referencia: `plan/feature-clean-architecture/analisis_tecnico.md`.
- Integracion con la arquitectura actual:
  - `provider`, `trust` y `consumer` adoptan la estructura `api / application / domain / infrastructure`;
  - los controllers pasan a ser adaptadores delgados;
  - la logica de negocio se concentra en casos de uso y dominio;
  - el dashboard se reorganiza en `features` y `shared` sin modificar el contrato E2E;
  - la migracion se ejecuta de forma incremental para evitar roturas de compatibilidad.

### feature-analisis-mediciones
- Objetivo tecnico preliminar: nueva pantalla analitica en React para explorar tendencias, distribuciones y comparaciones sobre grandes volúmenes de observaciones FHIR.
- Documento de referencia: `plan/feature-analisis-mediciones/analisis_funcional.md`.
- Integracion prevista con la arquitectura actual:
  - capa de adaptacion FHIR para normalizar `Bundle` y `Observation` a un modelo analitico;
  - capa de analisis para medias, mediana, desviacion, percentiles e IQR;
  - visualizacion con ECharts para lineas, histogramas, box plots y scatter plots;
  - persistencia del estado de filtros en URL;
  - soporte para exportacion PNG/CSV y estados vacios/skeleton loaders;
  - reutilizacion de la fuente de datos ya disponible en el dashboard sin romper la vista operativa.
