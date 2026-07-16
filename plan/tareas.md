[v] T-1: Confirmar caso de uso MVP y KPIs finales

### Descripcion
Cerrar el alcance funcional operativo del MVP (dos casos FHIR: tension arterial y frecuencia cardiaca) y fijar KPIs de rendimiento para evaluar el espacio de datos.

### Dependencias
(ninguna).

### Criterios de validacion
- Caso de uso MVP confirmado por el usuario.
- KPIs cerrados: latencia p95, throughput, error rate y consumo de recursos.
- Coherencia confirmada con `analisis_funcional.md`.

### Feedback al agente
[x] F-1: Sin feedback pendiente en esta fase.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: doc
- Componentes: alcance, kpi
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `plan/analisis_funcional.md`, `plan/analisis_tecnico.md`, `plan/tareas.md`
- Archivos creados: (ninguno)
- Acciones realizadas:
  - Se registraron dos casos clinicos FHIR para el MVP (opcion B).
  - Se fijaron KPIs exigentes (opcion B): `p95 <= 500 ms`, `throughput >= 120 req/s`, `error_rate <= 0.5%`.
  - Se actualizo el estado de `T-1` a completada.

---

[v] T-2: Decidir estrategia de repositorio para los 3 proyectos

### Descripcion
Tomar la decision tecnica de estructura de trabajo: monorepo multi-modulo Maven o tres repositorios separados.

### Dependencias
T-1.

### Criterios de validacion
- Decision confirmada por el usuario.
- Pros/contras documentados en el tecnico o en ADR adicional.
- Impacto en build y despliegue identificado.

### Feedback al agente
[x] F-1: Sin feedback pendiente en esta fase.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: setup
- Componentes: arquitectura, repo
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `plan/analisis_tecnico.md`, `plan/tareas.md`
- Archivos creados: (ninguno)
- Acciones realizadas:
  - Se confirmo estrategia multi-repo (3 repositorios separados).
  - Se anadio ADR-006 con la decision de estructura.
  - Se documentaron impactos en build/despliegue y riesgo adicional de coordinacion.

---

[v] T-3: Definir baseline de seguridad y observabilidad del MVP

### Descripcion
Fijar el nivel minimo de seguridad (OAuth/API key) y observabilidad (logs + metricas + trazabilidad basica) para la primera entrega.

### Dependencias
T-1, T-2.

### Criterios de validacion
- Baseline de seguridad confirmado.
- Baseline de observabilidad confirmado.
- Requisitos reflejados en analisis tecnico y backlog.

### Feedback al agente
[x] F-1: Sin feedback pendiente en esta fase.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: setup
- Componentes: seguridad, observabilidad
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `plan/analisis_tecnico.md`, `plan/tareas.md`
- Archivos creados: (ninguno)
- Acciones realizadas:
  - Se confirmo baseline de seguridad `A`: OAuth2 client-credentials con JWT.
  - Se confirmo baseline de observabilidad `A`: logs JSON, metricas Prometheus y trazas OpenTelemetry.
  - Se registro ADR-007 y se eliminaron dudas pendientes de seguridad/observabilidad.

---

[v] T-4: Definir contratos API y validaciones FHIR

### Descripcion
Modelar los contratos iniciales de provider, trust y consumer, junto con reglas de validacion para recursos FHIR del MVP.

### Dependencias
T-1, T-3.

### Criterios de validacion
- Contratos API documentados (OpenAPI o equivalente).
- Reglas de validacion FHIR definidas para los recursos usados.
- Politica de versionado de contratos establecida.

### Feedback al agente
[x] F-1: Sin feedback pendiente en esta fase.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: feature
- Componentes: api, fhir, contratos
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `plan/analisis_tecnico.md`, `plan/tareas.md`
- Archivos creados: `plan/contratos_api.md`
- Acciones realizadas:
  - Se documentaron contratos API de provider, trust y consumer en formato equivalente OpenAPI.
  - Se definieron reglas de validacion FHIR para tension arterial y frecuencia cardiaca.
  - Se fijo politica de versionado semantico y compatibilidad multi-repo.

---

[v] T-5: Inicializar `gaiax-health-provider-node` con EDC

### Descripcion
Crear la base del servicio provider con conector EDC, alta de datasets FHIR y publicacion de metadatos en catalogo.

### Dependencias
T-2, T-4.

### Criterios de validacion
- Servicio compila y arranca en local.
- Endpoint `POST /datasets/fhir` operativo con validacion minima.
- Endpoint `GET /datasets` operativo.

### Feedback al agente
[x] F-1: Sin feedback pendiente en esta fase.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: feature
- Componentes: provider, edc, fhir
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `pom.xml`, `plan/tareas.md`, `src/main/java/com/example/tfgenriquemoragaiax/provider/api/DatasetController.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/domain/DatasetService.java`
- Archivos creados: `src/main/java/com/example/tfgenriquemoragaiax/provider/api/CreateDatasetRequest.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/api/DatasetMetadata.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/api/DatasetResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/api/DatasetItemResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/api/DatasetListResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/api/ErrorResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/api/ErrorDetailResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/api/ProviderExceptionHandler.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/domain/ClinicalCase.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/domain/DatasetType.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/domain/DatasetStatus.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/domain/DatasetRecord.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/domain/ProviderErrorCode.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/domain/ProviderApiException.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/domain/ValidationIssue.java`, `src/main/java/com/example/tfgenriquemoragaiax/provider/domain/FhirValidationService.java`, `src/test/java/com/example/tfgenriquemoragaiax/provider/domain/DatasetServiceSmokeTest.java`
- Acciones realizadas:
  - Se implementaron endpoints `POST /api/v1/datasets/fhir` y `GET /api/v1/datasets`.
  - Se implemento almacenamiento en memoria, validacion de unicidad y filtros de listado.
  - Se implementaron validaciones FHIR para `blood-pressure` y `heart-rate`.
  - Se unifico manejo de errores con codigos y formato de respuesta.
  - Se verifico compilacion y tests con Java 25 usando `JAVA_HOME=~/.jdks/openjdk-25.0.2`.

---

[v] T-6: Inicializar `gaiax-health-trust-service`

### Descripcion
Crear la base del servicio trust/compliance con gestion de solicitudes de acceso, evaluacion de politicas y auditoria.

### Dependencias
T-3, T-4.

### Criterios de validacion
- Servicio compila y arranca en local.
- Endpoint `POST /access-requests` operativo.
- Endpoint `POST /policies/validate` operativo.
- Trazabilidad de decisiones de acceso registrada.

### Feedback al agente
[x] F-1: Sin feedback pendiente en esta fase.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: feature
- Componentes: trust, compliance, audit
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `plan/tareas.md`
- Archivos creados: `src/main/java/com/example/tfgenriquemoragaiax/trust/api/CreateAccessRequestRequest.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/api/AccessRequestCreatedResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/api/AccessRequestStatusResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/api/PolicyValidationRequest.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/api/PolicyValidationResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/api/TrustController.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/api/TrustErrorResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/api/TrustErrorDetailResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/api/TrustExceptionHandler.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/domain/AccessRequestStatus.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/domain/AccessRequestRecord.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/domain/AuditEvent.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/domain/TrustErrorCode.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/domain/TrustValidationIssue.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/domain/TrustApiException.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/domain/PolicyService.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/domain/TrustService.java`, `src/test/java/com/example/tfgenriquemoragaiax/trust/domain/TrustServiceSmokeTest.java`
- Acciones realizadas:
  - Se implementaron endpoints `POST /api/v1/access-requests`, `GET /api/v1/access-requests/{id}` y `POST /api/v1/policies/validate`.
  - Se implemento decision de politica base (role/scope/purpose) con estados `PENDING/APPROVED/REJECTED`.
  - Se implemento trazabilidad de decisiones mediante auditoria en memoria.
  - Se unifico manejo de errores del trust-service.
  - Se verifico con Java 25 (`~/.jdks/openjdk-25.0.2`) por tests y comprobacion HTTP real.

---

[v] T-7: Inicializar `gaiax-health-consumer-node` con EDC

### Descripcion
Crear la base del servicio consumer con conector EDC para solicitar acceso y ejecutar consumo de datasets autorizados.

### Dependencias
T-4, T-6.

### Criterios de validacion
- Servicio compila y arranca en local.
- Endpoint `POST /consumption-jobs` operativo.
- Endpoint `GET /consumption-jobs/{id}` operativo.
- Consumo controlado segun autorizacion del trust-service.

### Feedback al agente
[x] F-1: Sin feedback pendiente en esta fase.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: feature
- Componentes: consumer, edc, analytics
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `plan/tareas.md`
- Archivos creados: `src/main/java/com/example/tfgenriquemoragaiax/consumer/api/CreateConsumptionJobRequest.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/api/ConsumptionJobCreatedResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/api/ConsumptionJobStatusResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/api/ConsumerController.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/api/ConsumerErrorResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/api/ConsumerErrorDetailResponse.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/api/ConsumerExceptionHandler.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/domain/ConsumptionJobStatus.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/domain/ConsumptionJobRecord.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/domain/ConsumerErrorCode.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/domain/ConsumerValidationIssue.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/domain/ConsumerApiException.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/domain/ConsumerService.java`, `src/test/java/com/example/tfgenriquemoragaiax/consumer/domain/ConsumerServiceSmokeTest.java`
- Acciones realizadas:
  - Se implementaron endpoints `POST /api/v1/consumption-jobs` y `GET /api/v1/consumption-jobs/{id}`.
  - Se implemento resolucion de job segun autorizacion del `trust-service` (APPROVED => `SUCCEEDED`, si no => `FAILED`).
  - Se implemento manejo de errores del consumer-service.
  - Se verifico con Java 25 (`~/.jdks/openjdk-25.0.2`) por tests y comprobacion HTTP real.

---

[v] T-8: Orquestar entorno local con Docker Compose

### Descripcion
Preparar infraestructura local para levantar provider, trust y consumer con sus dependencias tecnicas.

### Dependencias
T-5, T-6, T-7.

### Criterios de validacion
- Arranque reproducible con un comando.
- Healthchecks en verde de los tres servicios.
- Logs y metricas minimas accesibles.

### Feedback al agente
[x] F-1: Sin feedback pendiente en esta fase.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: setup
- Componentes: docker, infra, observabilidad
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `Dockerfile`, `compose.yaml`, `src/main/resources/application.properties`, `plan/tareas.md`
- Archivos creados: (ninguno)
- Acciones realizadas:
  - Se definio build/runtime containerizado para Java 25 con imagenes Temurin y empaquetado Maven.
  - Se orquestaron `provider`, `trust` y `consumer` en `compose.yaml` con puertos 8081/8082/8083 y healthchecks en `/actuator/health`.
  - Se habilitaron endpoints de observabilidad minima (`health`, `info`, `metrics`) en la configuracion Spring.
  - Se valido arranque reproducible con `docker compose up -d --build`, estado `healthy` en los 3 servicios y respuesta `UP` en los tres `/actuator/health`.

---

[v] T-9: Validar flujo E2E y auditoria tecnica

### Descripcion
Ejecutar validacion de extremo a extremo (publicacion, solicitud, autorizacion, consumo) verificando trazabilidad.

### Dependencias
T-8.

### Criterios de validacion
- Flujo E2E completado sin errores criticos.
- Evidencias de auditoria disponibles para cada paso.
- Resultado documentado para defensa tecnica.

### Feedback al agente
[x] F-1: Sin feedback pendiente en esta fase.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: test
- Componentes: e2e, audit
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `src/main/java/com/example/tfgenriquemoragaiax/consumer/domain/ConsumerService.java`, `src/main/resources/application.properties`, `compose.yaml`, `src/test/java/com/example/tfgenriquemoragaiax/consumer/domain/ConsumerServiceSmokeTest.java`, `plan/tareas.md`
- Archivos creados: `src/main/java/com/example/tfgenriquemoragaiax/consumer/domain/TrustAccessClient.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/domain/HttpTrustAccessClient.java`, `plan/evidencias_t9.md`
- Acciones realizadas:
  - Se corrigio integracion `consumer -> trust` para resolver autorizaciones via HTTP entre servicios Docker separados.
  - Se reconstruyeron y relanzaron los tres contenedores con la configuracion de `GAIAX_TRUST_BASE_URL`.
  - Se ejecuto flujo E2E completo (publish, access, policy, consume, status) con resultados esperados (`201/200/201/200/200/202/200` y `SUCCEEDED`).
  - Se documentaron evidencias tecnicas y trazabilidad por `X-Request-Id` en `plan/evidencias_t9.md`.

---

[v] T-10: Ejecutar pruebas de carga y generar informe

### Descripcion
Lanzar escenarios de carga definidos y elaborar informe de resultados comparando baseline y escalados.

### Dependencias
T-8, T-9.

### Criterios de validacion
- Escenarios de carga versionados y ejecutables.
- Reporte con p50/p95/p99, throughput, error rate y recursos.
- Recomendaciones de escalado y cuellos de botella documentados.

### Feedback al agente
[x] F-1: Sin feedback pendiente en esta fase.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: test
- Componentes: performance, benchmark
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `plan/tareas.md`
- Archivos creados: `scripts/perf/run_load_tests.sh`, `plan/informe_carga_t10.md`, `plan/perf-results/20260227T130048Z/summary.csv`, `plan/perf-results/20260227T130048Z/raw/*`, `plan/perf-results/20260227T130048Z/setup.json`, `plan/perf-results/20260227T130048Z/scenarios.txt`
- Acciones realizadas:
  - Se implemento runner versionado y ejecutable de carga con perfiles `baseline` (300 req, conc 10) y `scaled` (1200 req, conc 40) en 3 escenarios (`provider_list`, `trust_policy`, `consumer_job_status`).
  - Se ejecuto benchmark completo contra entorno Docker activo y se recolectaron percentiles (`p50/p95/p99`), throughput, error rate y snapshot de recursos por servicio.
  - Resultado global: `error_rate=0.00%` en todos los escenarios; throughput aproximado entre `150.73` y `168.26 req/s`.
  - Se genero informe consolidado con recomendaciones de escalado y cuellos de botella en `plan/informe_carga_t10.md`.

---

[v] T-11: Reescribir README.md tecnico-funcional

### Descripcion
Actualizar README para reflejar arquitectura final EDC-first, pasos de arranque, ejecucion de pruebas y resultados esperados.

### Dependencias
T-9, T-10.

### Criterios de validacion
- README describe claramente los 3 proyectos IntelliJ y su rol.
- README incluye guia operativa de arranque y pruebas.
- README incluye limites conocidos y roadmap del MVP.

### Feedback al agente
[x] F-1: Sin feedback pendiente en esta fase.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Media
- Responsable: (opcional)
- Tipo: doc
- Componentes: documentacion, onboarding
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `README.md`, `plan/tareas.md`
- Archivos creados: (ninguno)
- Acciones realizadas:
  - Se reescribio el README en formato tecnico-funcional alineado con la decision EDC-first y la arquitectura de 3 proyectos IntelliJ.
  - Se incluyo guia operativa completa (arranque local, tests, validacion E2E y carga) con comandos reproducibles.
  - Se incorporaron resultados de rendimiento reales del T-10, KPIs objetivo vs estado actual, limites del MVP y roadmap.

---

[] T-12: Integrar feature `feature-cobertura-tests` en el plan principal

### Descripcion
Orquestar y seguir el avance de la feature de cobertura de pruebas (unitarias, funcionales y de sistema) enlazando su plan aislado con el plan raiz.

### Dependencias
T-11.

### Criterios de validacion
- La feature `plan/feature-cobertura-tests/` contiene `analisis_funcional.md`, `analisis_tecnico.md` y `tareas.md`.
- Las tareas `T-CT-*` se ejecutan y validan en su propio `tareas.md`.
- El plan raiz refleja estado e impacto de la feature.

### Feedback al agente
[x] F-1: Sin feedback pendiente en esta fase.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: setup
- Componentes: plan, integracion, calidad
- Feature: feature-cobertura-tests

### Resumen de ejecucion
(se anade automaticamente justo antes de marcar `[x]`)

---

[x] T-fix-01: Ajustar version base de Java a 21 [~tipo=fix-menor]

### Descripcion
Actualizar la configuracion base del proyecto para usar Java 21 en compilacion y en imagenes Docker de build/runtime.

### Dependencias
(ninguna).

### Criterios de validacion
- `pom.xml` define `java.version` en `21`.
- `Dockerfile` usa `eclipse-temurin:21-jdk` y `eclipse-temurin:21-jre`.
- No quedan referencias activas a Java 25 en la configuracion de ejecucion del backend.

### Feedback al agente
[x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Media
- Responsable: (opcional)
- Tipo: fix
- Componentes: build, docker, java
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `pom.xml`, `Dockerfile`, `plan/tareas.md`
- Archivos creados: (ninguno)
- Acciones realizadas:
  - Se actualizo `java.version` de `25` a `21` en `pom.xml`.
  - Se actualizaron las imagenes base del `Dockerfile` a `eclipse-temurin:21-jdk` (build) y `eclipse-temurin:21-jre` (runtime).
  - Se valido compilacion con `./mvnw -q -DskipTests test-compile` forzando `JAVA_HOME=/home/emora/.jdks/openjdk-25.0.2` (resultado correcto).

---

[x] T-fix-02: Corregir build con `mvn clean install -U` al usar Java 21 [~tipo=fix-menor]

### Descripcion
Evitar el error `release version 21 not supported` cuando Maven corre con `JAVA_HOME` antiguo, forzando compilacion y ejecucion de tests con `javac/java` del `PATH`.

### Dependencias
T-fix-01.

### Criterios de validacion
- `./mvnw -DskipTests compile` deja de fallar por `release version 21 not supported`.
- `pom.xml` documenta configuracion explicita de compilador y JVM de tests.
- No se revierte el baseline Java 21 del proyecto.

### Feedback al agente
[x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: fix
- Componentes: build, maven, java
- Feature: (opcional)

### Resumen de ejecucion
- Archivos modificados: `pom.xml`, `plan/tareas.md`
- Archivos creados: (ninguno)
- Acciones realizadas:
  - Se configuro `maven-compiler-plugin` con `fork=true` y `executable=javac` para evitar dependencia del `JAVA_HOME` de Maven cuando apunta a Java 17.
  - Se anadio `maven-surefire-plugin` con `jvm=java` para alinear ejecucion de tests con la JVM de `PATH`.
  - Se verifico que desaparece el error `release version 21 not supported` con `mvn -q -DskipTests compile` y `./mvnw -q -DskipTests compile`.

---

### feature-analisis-mediciones
- Estado: en definicion.
- Impacto: nueva pagina analitica en el dashboard para tendencias, distribuciones, comparacion entre pacientes y deteccion de anomalías.
- Tareas espejo: `plan/feature-analisis-mediciones/tareas.md`.
- Validacion esperada: ECharts, filtros sincronizados con URL, exportacion PNG/CSV, estadisticas dinamicas y soporte para miles de observaciones.
