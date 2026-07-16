# METADATA

- Ultima actualizacion: `2026-06-12T07:19:01Z`
- Fuente de verdad: `plan/analisis_funcional.md`, `plan/analisis_tecnico.md`, `plan/tareas.md`
- Estado de cache: `vigente`

## TL;DR ejecutivo

### Analisis funcional
- MVP Gaia-X en salud con estrategia `EDC-first`.
- Flujo obligatorio validado: `publicacion -> solicitud -> autorizacion -> consumo`.
- Casos FHIR del MVP: `blood-pressure` y `heart-rate`.
- Nueva feature activa: `feature-cobertura-tests` (fase funcional aprobada).
- Feature completada: `feature-gaiax-health-hardening` (fase funcional y tecnica creadas, completada con `H-1` a `H-8`).
- Feature completada: `feature-fhir-observation` (contrato dual `Observation` + `Bundle`, metadatos FHIR de soberania y provenance preservada).
- Feature completada: `feature-analisis-mediciones` (pagina de analisis clinico exploratorio con filtros, graficas avanzadas, exportacion y soporte para miles de observaciones).
- Feature completada: `feature-clean-architecture` (refactor transversal para separar `api / application / domain / infrastructure` en backend y reorganizar el dashboard por `features`).
- `feature-clean-architecture` ejecuto CA-1: se elimino el nivel intermedio `com.example` y se normalizo el paquete base a `com.gaiahealth` en provider, trust y consumer.
- `feature-clean-architecture` ejecuto CA-2: `DatasetService` paso a `application`, `DatasetController` dejo de depender de la capa de dominio y el provider completo siguio pasando tests.
- `feature-clean-architecture` ejecuto CA-3: `TrustService` paso a `application`, se aislaron las reglas de consentimiento en `domain` y `trust` quedo verificado con tests.
- `feature-clean-architecture` ejecuto CA-4: `ConsumerService` paso a `application`, `HttpTrustAccessClient` paso a `infrastructure/trust` y el flujo de consumo quedo validado.
- `feature-clean-architecture` ejecuto CA-5: el dashboard se reorganizo por `features` (`patients`, `analytics`) manteniendo la UX y pasando type-check + tests.
- KPIs funcionales confirmados:
  - `error_rate <= 0.5%`
  - `p95 <= 500 ms`
  - `throughput >= 120 req/s`

### Analisis tecnico
- Arquitectura objetivo en 3 servicios: `provider`, `trust`, `consumer`.
- Decision de estructura: `3 repositorios separados` (ADR-006).
- Baseline de seguridad/observabilidad definido:
  - OAuth2 `client_credentials` + JWT
  - logs estructurados, metricas, trazabilidad
- DTOs de entrada simplificados con Lombok `1.18.46` en los tres servicios Java.
- Contratos API documentados en `plan/contratos_api.md`.
- Nueva feature activa: estrategia de tests por capas en `plan/feature-cobertura-tests/analisis_tecnico.md`.
- Feature completada: compatibilidad FHIR real con `Observation` directas en `plan/feature-fhir-observation/analisis_tecnico.md`.
- Nuevo flujo E2E FHIR operativo: provider con PostgreSQL JSONB, dashboard consultando `/api/fhir/Patient` y `/api/fhir/Observation`, y colección de Postman importable en `documentacion/postman/gaiax-health-e2e.postman_collection.json`.
- Orquestacion central alineada al orden real de arranque: `postgres -> provider -> trust -> consumer -> dashboard`, con `POSTMAN.md` como guia manual de llamadas.
- `POSTMAN.md` ampliado con ejemplos `cURL` completos, cabeceras y endpoints para ingesta, consulta, healthchecks y carga masiva con `multipleFhirBundle`.
- `POSTMAN.md` alineado con `gaiax-health-deployment/docs/api-contracts.md` y los DTOs reales del provider, trust y consumer.
- `gaiax-health-deployment/docs/api-contracts.md` actualizado con los payloads y query params reales de provider, trust, consumer y la fachada FHIR.
- `gaiax-health-deployment` depurado: scripts huérfanos eliminados, `.env.example` reducido a overrides opcionales y README/development-setup alineados con el arranque real sin `.env` obligatorio.
- `gaiax-health-deployment` depurado todavía más: `CONTRIBUTING.md` eliminado por ser boilerplate sin impacto operativo directo.
- Colección Postman enriquecida con tests y healthchecks de `provider`, `trust`, `consumer` y `dashboard`.
- Environment de Postman separado añadido en `documentacion/postman/gaiax-health-local.postman_environment.json`.
- La colección Postman depende solo del environment importado; no conserva variables internas.
- El healthcheck del dashboard se corrigio para comprobar `/` en lugar de `/health`, dejando el contenedor en estado `healthy`.
- El dashboard ya no inyecta `Content-Type` ni `X-Request-Id` en las lecturas FHIR, evitando preflight CORS y recuperando el estado de conexion.
- El dashboard expone un proxy Nginx en `http://localhost:3000/api/fhir` y health endpoints proxyados, de modo que navegador y Postman no dependen de `8081` desde el host.
- Se añadieron `documentacion/postman/fhirBundle.sample.json` como bundle FHIR estático pequeño y `documentacion/postman/multipleFhirBundle.sample.json` junto con sus particiones para carga masiva en Postman.

### Tareas
- Plan principal completado y validado (`T-1` a `T-11` en `[v]`).
- Entregables cerrados:
  - Provider/trust/consumer operativos
  - Orquestacion Docker Compose
  - Evidencia E2E (`plan/evidencias_t9.md`)
  - Informe de carga (`plan/informe_carga_t10.md`)
  - README tecnico-funcional actualizado

## Features activas
- Features tipo carpeta (`plan/feature-*`): `7`
- Feature: `feature-cobertura-tests`
  - Estado: completada (`T-CT-1`, `T-CT-2` y `T-CT-3` validadas en `[v]`).
  - Scope: generacion de tests unitarios, funcionales y de sistema basados en `src/test/resources/fhir`.
- Feature: `feature-dashboard-pacientes`
  - Estado: completada con extension local de pacientes precargados y sincronizada con el despliegue central.
  - Stack: React 18 + Vite + TypeScript + Tailwind + Recharts + TanStack Query
  - Scope: dashboard web buscador pacientes, tabla de 20 pacientes precargados, gráficos temporal (línea) + distribución (tarta), tabla mediciones FHIR
  - Build: ✓ 187 KB gzipped (production ready)
  - Tests: activos y ampliados con tabla precargada y seleccion por fila
- Feature: `feature-monorepo-to-polyrepo`
  - Estado: Completada.
  - Scope: Migración de monorepo a polyrepo (5 repos independientes: provider, trust, consumer, dashboard, deployment).
  - Repos: 5 nuevos.
- Feature: `feature-gaiax-health-hardening`
  - Estado: completada (`H-1` a `H-8` cerradas).
  - Scope: endurecimiento Gaia-X Health para provider/trust/consumer/dashboard/deployment.
  - Objetivo: consentimiento granular, identidad federada, validacion FHIR estricta y minimizacion de datos.
- Feature: `feature-fhir-observation`
  - Estado: completada (`O-1` a `O-4` cerradas).
  - Scope: compatibilidad con `Observation` directas, preservacion de provenance y metadatos de soberania.
  - Objetivo: aceptar payloads FHIR reales sin romper el contrato actual basado en `Bundle`.
- Feature: `feature-analisis-mediciones`
  - Estado: completada (`A-1` a `A-6` cerradas).
  - Scope: pagina de analisis clinico exploratorio con filtros, evoluciones temporales, distribuciones, comparacion entre pacientes y exportacion.
  - Objetivo: analizar tendencias y anomalías sobre bundles FHIR de volumen medio/alto con una UX clara y fluida.

## Estadisticas agregadas de tareas
- Total tareas (raiz): `12`
- Estados:
  - `[]`: `1`
  - `[-]`: `0`
  - `[x]`: `0`
  - `[v]`: `11`
- Tipos:
  - `feature`: `4`
  - `setup`: `4`
  - `test`: `2`
  - `doc`: `2`
- Prioridad:
  - `Alta`: `10`
- `Media`: `1`
- `Baja`: `0`

## Digest ADR
- `ADR-001`: arquitectura separada por roles (provider/trust/consumer).
- `ADR-002`: adopcion `EDC-first` como base del MVP.
- `ADR-003`: enfoque `FHIR-first` para rapidez y trazabilidad.
- `ADR-004`: catalogo integrado en conectores durante MVP.
- `ADR-005`: seguridad incremental (MVP -> evolucion Gaia-X completa).
- `ADR-006`: estrategia definitiva multi-repo (3 repositorios).
- `ADR-007`: baseline OAuth2 + observabilidad intermedia para pruebas KPI.

## Issues Jira vinculadas y mapeo 1->N
- Issues Jira vinculadas detectadas: `0`
- Tareas con bloque Jira sin definir: `11/11`
- Sincronizacion MCP-Jira: `no configurada` en el plan actual.

## Changelog reciente (ultimos 7 dias)
- `2026-06-11`: introducido Lombok `1.18.46` en provider, trust y consumer para simplificar DTOs de entrada y clases de estado, con validacion exitosa en los tres modulos.
- `2026-06-11`: reconstruido el flujo E2E FHIR con persistencia PostgreSQL, dashboard en tiempo real contra `/api/fhir`, limpieza de datos estáticos y colección Postman importable.
- `2026-06-11`: orden de arranque consolidado en `gaiax-health-deployment` como `postgres -> provider -> trust -> consumer -> dashboard`; añadida guia manual `POSTMAN.md` y sincronizada la memoria del TFG.
- `2026-06-11`: `POSTMAN.md` extendido con ejemplos `cURL` completos y descripción de cabeceras/endpoints para el flujo E2E.
- `2026-06-11`: colección Postman alineada con la guía `POSTMAN.md`, incluyendo healthchecks y validación básica del dashboard.
- `2026-06-11`: añadido environment de Postman separado para el stack local con variables de endpoints, healthchecks y dashboard.
- `2026-06-11`: la colección Postman quedó desacoplada de variables internas y pasó a depender solo del environment importado.
- `2026-06-11`: corregido el healthcheck del dashboard para que Nginx valide la raíz `/` y el contenedor pase a `healthy`.
- `2026-06-11`: el cliente FHIR del dashboard fue simplificado para usar solo `Accept` en las lecturas, evitando CORS preflight y reactivando el indicador de conexion.
- `2026-06-11`: el dashboard quedó proxyando FHIR y healthchecks a través de Nginx en `localhost:3000`, eliminando la dependencia del navegador sobre `localhost:8081`.
- `2026-06-11`: añadidos bundles FHIR de ejemplo y carga masiva para Postman en `documentacion/postman/fhirBundle.sample.json` y `documentacion/postman/multipleFhirBundle.sample.json` con particiones para evitar `413`.
- `2026-06-11`: el dashboard ahora calcula totales reales de pacientes y observaciones sobre el dataset completo, busca pacientes por ID en todo el conjunto cargado y mueve el indicador de estado FHIR a una esquina discreta.
- `2026-06-11`: la memoria del TFG se actualizó para reflejar los cambios del dashboard y de la página de analítica: totales reales, buscador global por ID, exportación PNG/CSV, skeleton loaders y capturas pendientes.
- `2026-06-11`: creada la feature `feature-clean-architecture` para separar capas en backend y reorganizar el dashboard por features sin cambiar contratos funcionales.
- `2026-06-11`: aplicado el rename de paquetes a `com.gaiahealth` en los tres backend y sus tests, moviendo fisicamente la estructura de directorios para hacerla coherente con el nuevo root package.
- `2026-06-11`: movida la orquestacion del provider a la capa `application`; el test funcional quedo desacoplado de PostgreSQL real con un servicio FHIR noop y el modulo paso la suite completa.
- `2026-06-11`: completada la separacion de `trust` en `application`/`domain`; `TrustService` quedo aislado y el modulo paso `18` tests.
- `2026-06-11`: completada la separacion de `consumer` en `application`/`domain`/`infrastructure`; `HttpTrustAccessClient` quedo fuera del dominio puro y el modulo paso `21` tests.
- `2026-06-11`: reorganizado el dashboard por features (`patients`, `analytics`) y actualizado `src/types/index.ts` para reexportar la analitica desde su feature.
- `2026-06-11`: creada la feature `feature-analisis-mediciones` para analitica clinica avanzada sobre observaciones FHIR con ECharts, filtros y exportacion.
- `2026-06-11`: creada la estructura de tareas de `feature-analisis-mediciones` con seis bloques para adaptacion FHIR, analisis, UI, estadisticas, exportacion y tests.
- `2026-06-11`: completada `A-1` de `feature-analisis-mediciones` con el modelo analitico, normalizacion FHIR y tests del adaptador; la feature pasa a ejecucion.
- `2026-06-11`: completada `A-2` de `feature-analisis-mediciones` con la capa de estadistica, histogramas, box plot y agregados temporales; el adaptador reutiliza la logica central.
- `2026-06-11`: completada `A-3` de `feature-analisis-mediciones` con panel de filtros, sincronizacion con URL y filtrado reactivo del dataset analitico.
- `2026-06-11`: completada `A-4` de `feature-analisis-mediciones` con una evolucion temporal basada en agregados, percentiles, banda intercuartil y zoom por rango.
- `2026-06-11`: completada `A-5` de `feature-analisis-mediciones` con histograma, box plot, scatter por sexo/edad y panel lateral de estadisticas dinamicas.
- `2026-06-11`: completada `A-6` de `feature-analisis-mediciones` con exportacion PNG/CSV, skeleton loaders, estados vacios mejorados y cobertura adicional de pruebas.
- `2026-06-12`: licencia MIT consolidada en la raiz del workspace; las copias por subproyecto quedaron eliminadas para reducir ruido documental.
- `2026-06-12`: limpiados fixtures de test no referenciados en `gaiax-health-consumer-node` (`collection-sample.json`, `observation-sample.json`, `tensiometro-bundles-10000.json`, `tensiometro-collection-10000.json`).
- `2026-06-12`: reescrito el README de `gaiax-health-consumer-node` para alinearlo con el paquete real `com.gaiahealth.consumer`, los endpoints vigentes y la configuración actual.
- `2026-06-12`: reescrito el README de `gaiax-health-trust-service` para reflejar los endpoints reales, el paquete `com.gaiahealth.trust` y la configuración actual; además se limpiaron los fixtures de test no usados.
- `2026-06-10`: reescrita la sección 1.1 del borrador del TFG con una descripción más natural del proyecto, su alcance y su motivación.
- `2026-06-10`: pasada de documentacion completada sobre el borrador del TFG; cerradas las secciones 2.2-6.2 y el Anexo C con un texto academico alineado al estado real del proyecto.
- `2026-06-10`: creada la feature `feature-fhir-observation` para aceptar `Observation` directas con provenance y soberania, manteniendo compatibilidad con `Bundle`.
- `2026-06-10`: completada la feature `feature-fhir-observation`; provider, consumer y dashboard aceptan y preservan `Observation` directas con provenance y soberania.
- `2026-06-10`: actualizado el título del borrador de la memoria a "Creación de un espacio de datos Gaia-X" y alineado el resumen con el texto aportado por el autor.
- `2026-06-10`: completada la sección 2.1 del borrador del TFG con antecedentes sobre espacios de datos, interoperabilidad sanitaria y soberanía; sincronizado el contenido en Markdown y `.docx`.
- `2026-06-10`: actualizada la portada del borrador del TFG con curso académico `2025/2026` y fecha de defensa `julio de 2026`.
- `2026-06-10`: actualizado el tutor del borrador del TFG a Félix Jesús Villanueva Molina y regenerado el `.docx` con el dato coherente.
- `2026-06-10`: actualizado el autor del borrador del TFG a Enrique Mora Rodriguez y regenerado el `.docx` con los metadatos coherentes.
- `2026-06-10`: completado el Anexo B del borrador de TFG con evidencia funcional, técnica y de carga basada en las pruebas reales del proyecto.
- `2026-06-10`: bibliografia del borrador convertida a formatos APA 7 e IEEE; regenerado el `.docx` de la memoria con la nueva version academica.
- `2026-06-10`: completados la bibliografia y el Anexo A del borrador de TFG; añadido un listado de fuentes oficiales, documentos internos y una descripcion reproducible del despliegue centralizado.
- `2026-06-10`: pasada de documentacion sobre el TFG; creado borrador en Markdown y `.docx` basado en la plantilla `plantillaESI_TFG.dotx` con secciones y huecos pendientes para completar.
- `2026-06-10`: el dashboard se sincroniza con `gaiax-health-deployment`; el Dockerfile compila con devDependencies y el compose central inyecta `VITE_API_URL=http://consumer:8083/api/v1`.
- `2026-06-10`: despliegue central verificado con `gaiax-health-deployment`; `provider`, `trust`, `consumer` y `dashboard` quedan saludables, y se corrige el mapeo host/container de `trust` y `consumer` a `8082:8080` y `8083:8080`.
- `2026-06-10`: README raíz y README de `gaiax-health-deployment` alineados con el estado actual del stack centralizado y con el arranque desde `gaiax-health-deployment/`.
- `2026-06-10`: el dashboard precarga 20 pacientes desde los fixtures del consumer, los muestra en una tabla clicable debajo del buscador y permite abrir el detalle de cada paciente.
- `2026-06-10`: se crea `feature-gaiax-health-hardening` para alinear el stack con Gaia-X Health mediante consentimiento granular, validacion FHIR estricta, identidad federada y minimizacion de datos.
- `2026-06-10`: ejecucion de `H-1` a `H-6` en `feature-gaiax-health-hardening`; contrato de consentimiento, validacion FHIR, PDP, propagacion de consentimiento, minimizacion del dashboard y endurecimiento del deployment quedan implementados.
- `2026-06-10`: `estado_proyecto.md` actualizado para reflejar `feature-gaiax-health-hardening` en ejecucion con los cuatro bloques principales ya completados.
- `2026-06-10`: ejecucion de `H-7` y `H-8` en `feature-gaiax-health-hardening`; añadidas pruebas de consentimiento/minimizacion, evidencia E2E y build del dashboard.
- `2026-06-10`: `estado_proyecto.md` actualizado para reflejar `feature-gaiax-health-hardening` como completada.
- `Actual`: Migración finalizada de monorepo a polyrepo (feature-monorepo-to-polyrepo). Separación de código en 5 repositorios. Eliminada dependencia circular de compilación en consumer.
- `2026-04-28`: dashboard-pacientes FASE A-D completadas: tipos + services + 5 componentes + integración Dashboard
  - Setup completo: Vite + types + axios + dataTransform
  - Services: consumerService + usePatientData + useMeasurements + useBackendStatus
  - Components: SearchBar + MetricsLineChart + DistributionPie + MeasurementsTable + ErrorBoundary
  - Build: TypeScript 0 errors, 187 KB gzipped
- `2026-04-28`: creacion de feature `feature-dashboard-pacientes` con fase 1-3 completadas (funcional, tecnico, tareas).
- `2026-04-28`: inicio de fase 4 (ejecucion) para feature dashboard.
- `2026-03-04`: ejecucion de `T-CT-3` con tests funcionales de `provider`, `trust` y `consumer`.
- `2026-03-04`: correccion de enrutado de excepciones por modulo en `*ExceptionHandler` (`basePackages` + `requestId` null-safe).
- `2026-03-04`: ejecucion de `T-CT-2` con nuevas suites unitarias para provider/trust/consumer.
- `2026-03-04`: cierre de `T-CT-1` con utilidades comunes de carga FHIR (`FhirTestDataLoader`).
- `2026-03-04`: creacion de `plan/feature-cobertura-tests/tareas.md` (Fase 3 propuesta).
- `2026-03-04`: anadida tarea `T-12` en `plan/tareas.md` para integracion de la feature.
- `2026-03-04`: creacion de `plan/feature-cobertura-tests/analisis_funcional.md`.

## Glosario del proyecto
- `EDC`: Eclipse Dataspace Components.
- `Provider`: nodo que publica datasets FHIR.
- `Trust service`: servicio de politicas, autorizacion y auditoria.
- `Consumer`: nodo que solicita y consume datasets autorizados.
- `FHIR`: estandar de interoperabilidad clinica usado en el MVP.
- `KPI`: indicadores de calidad/rendimiento usados para validar el TFG.
- `E2E`: prueba extremo a extremo del flujo funcional completo.
- `Baseline`: perfil de referencia para comparar rendimiento.
