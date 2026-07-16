# Feature: clean-architecture

[x] CA-1: Crear estructura de carpetas por capas en backend

### Descripcion
Introducir en `provider`, `trust` y `consumer` la estructura base `api / application / domain / infrastructure` sin romper funcionalidad ni contratos.

### Dependencias
(ninguna).

### Criterios de validacion
- Las carpetas base existen en los tres servicios.
- La estructura nueva es coherente entre repos.
- La compilacion sigue funcionando.

### Feedback al agente
[] F-1: No hay feedback adicional por ahora.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: refactor
- Componentes: backend, arquitectura
- Feature: clean-architecture

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-provider-node/src/main/java/com/gaiahealth/...`, `gaiax-health-provider-node/src/test/java/com/gaiahealth/...`, `gaiax-health-trust-service/src/main/java/com/gaiahealth/...`, `gaiax-health-trust-service/src/test/java/com/gaiahealth/...`, `gaiax-health-consumer-node/src/main/java/com/gaiahealth/...`, `gaiax-health-consumer-node/src/test/java/com/gaiahealth/...`
- Archivos creados: (ninguno)
- Acciones realizadas:
  - Se elimino el nivel intermedio `com.example` y se normalizo el root package a `com.gaiahealth` en los tres backend y sus tests.
  - Se movieron fisicamente los directorios fuente y de test para que package y ruta coincidan.
  - Se verifico compilacion y tests en trust y consumer; en provider el test funcional sigue intentando abrir una conexion PostgreSQL real y queda bloqueado por el entorno, no por el rename de paquetes.

---

[x] CA-2: Extraer casos de uso del provider

### Descripcion
Separar la logica de orquestacion del provider en casos de uso de `application` y dejar `api` solo como adaptador HTTP.

### Dependencias
CA-1.

### Criterios de validacion
- `DatasetController` no contiene logica de negocio.
- La validacion y la publicacion se delegan a `application`.
- Los tests siguen pasando.

### Feedback al agente
[] F-1: No hay feedback adicional por ahora.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: refactor
- Componentes: provider, application
- Feature: clean-architecture

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-provider-node/src/main/java/com/gaiahealth/provider/application/DatasetService.java`, `gaiax-health-provider-node/src/main/java/com/gaiahealth/provider/api/DatasetController.java`, `gaiax-health-provider-node/src/test/java/com/gaiahealth/provider/domain/DatasetServiceUnitTest.java`, `gaiax-health-provider-node/src/test/java/com/gaiahealth/provider/domain/DatasetServiceSmokeTest.java`, `gaiax-health-provider-node/src/test/java/com/gaiahealth/provider/api/ProviderApiFunctionalTest.java`
- Archivos creados: (ninguno)
- Acciones realizadas:
  - Se movio la orquestacion del provider a la capa `application` sin alterar el contrato HTTP.
  - `DatasetController` paso a depender de la nueva capa de aplicacion.
  - El test funcional del provider quedo desacoplado de PostgreSQL real mediante una configuracion de test sin DB y con un servicio FHIR noop.
  - El modulo `provider` paso la suite completa de tests tras la reorganizacion.

---

[x] CA-3: Separar trust en dominio y casos de uso

### Descripcion
Mover las reglas de politica y la orquestacion de solicitudes a capas separadas para que la logica de consentimiento quede aislada.

### Dependencias
CA-1.

### Criterios de validacion
- `TrustController` queda como adaptador.
- La politica se evalua desde `application`/`domain`.
- La auditoria sigue operativa.

### Feedback al agente
[x] F-1: No hay feedback adicional por ahora.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: refactor
- Componentes: trust, domain, application
- Feature: clean-architecture

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-trust-service/src/main/java/com/gaiahealth/trust/application/TrustService.java`, `gaiax-health-trust-service/src/test/java/com/gaiahealth/trust/application/TrustServiceTest.java`, `gaiax-health-trust-service/src/test/java/com/gaiahealth/trust/api/TrustControllerTest.java`
- Archivos creados: (ninguno)
- Acciones realizadas:
  - Se movio `TrustService` a la capa `application` y se normalizaron las dependencias explicitas hacia `domain`.
  - Se recoloco el test de servicio en `src/test/java/com/gaiahealth/trust/application/` para alinear paquete y ruta.
  - Se valido el modulo `trust` con `mvn -Dmaven.repo.local=/tmp/m2 test`, obteniendo `BUILD SUCCESS` y `18` tests verdes.

---

[x] CA-4: Separar consumer y adaptadores externos

### Descripcion
Extraer el cliente HTTP y la orquestacion de jobs a capas separadas para aislar la dependencia del trust-service.

### Dependencias
CA-1.

### Criterios de validacion
- `HttpTrustAccessClient` vive fuera del dominio puro.
- `ConsumerController` no contiene logica de negocio.
- El flujo de consumo sigue funcionando.

### Feedback al agente
[x] F-1: No hay feedback adicional por ahora.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: refactor
- Componentes: consumer, infrastructure
- Feature: clean-architecture

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-consumer-node/src/main/java/com/gaiahealth/consumer/application/ConsumerService.java`, `gaiax-health-consumer-node/src/main/java/com/gaiahealth/consumer/infrastructure/trust/HttpTrustAccessClient.java`, `gaiax-health-consumer-node/src/main/java/com/gaiahealth/consumer/domain/ConsumptionJobRecord.java`, `gaiax-health-consumer-node/src/test/java/com/gaiahealth/consumer/application/ConsumerServiceTest.java`, `gaiax-health-consumer-node/src/test/java/com/gaiahealth/consumer/infrastructure/trust/HttpTrustAccessClientTest.java`, `gaiax-health-consumer-node/src/test/java/com/gaiahealth/consumer/api/ConsumerControllerTest.java`
- Archivos creados: (ninguno)
- Acciones realizadas:
  - Se movio la orquestacion del consumer a `application` y el cliente HTTP del trust a `infrastructure/trust`.
  - Se corregieron imports, rutas y tests para reflejar la nueva separacion de capas sin romper el flujo de consumo.
  - Se valido el modulo `consumer` con `mvn -Dmaven.repo.local=/tmp/m2 test`, obteniendo `BUILD SUCCESS` y `21` tests verdes.

---

[x] CA-5: Reorganizar el dashboard por features

### Descripcion
Reestructurar el frontend para que `patients`, `analysis` y `shared` queden claramente separadas y la UI no mezcle adaptadores, transformaciones y render.

### Dependencias
CA-1.

### Criterios de validacion
- La estructura del frontend sigue un esquema por features.
- Los componentes reciben datos ya preparados.
- No se rompe la experiencia actual del dashboard.

### Feedback al agente
[x] F-1: No hay feedback adicional por ahora.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Media
- Responsable: (opcional)
- Tipo: refactor
- Componentes: dashboard, frontend
- Feature: clean-architecture

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-dashboard/src/pages/Dashboard.tsx`, `gaiax-health-dashboard/src/hooks/useFhirData.ts`, `gaiax-health-dashboard/src/components/MetricsLineChart.tsx`, `gaiax-health-dashboard/src/features/patients/**`, `gaiax-health-dashboard/src/features/analytics/**`, `gaiax-health-dashboard/src/tests/**`, `gaiax-health-dashboard/src/types/index.ts`
- Archivos creados: `gaiax-health-dashboard/src/features/patients/components/MeasurementsTable.tsx`, `gaiax-health-dashboard/src/features/patients/components/PatientsTable.tsx`, `gaiax-health-dashboard/src/features/patients/hooks/usePatientData.ts`, `gaiax-health-dashboard/src/features/patients/hooks/useMeasurements.ts`, `gaiax-health-dashboard/src/features/patients/services/dataTransform.ts`, `gaiax-health-dashboard/src/features/patients/services/fhirApi.ts`, `gaiax-health-dashboard/src/features/patients/services/consumerService.ts`, `gaiax-health-dashboard/src/features/analytics/components/*`, `gaiax-health-dashboard/src/features/analytics/hooks/useAnalyticsFilters.ts`, `gaiax-health-dashboard/src/features/analytics/services/*`, `gaiax-health-dashboard/src/features/analytics/types/analysis.ts`
- Acciones realizadas:
  - Se reorganizo el frontend por features (`patients`, `analytics`) y se preservo la funcionalidad visible del dashboard.
  - Se actualizaron los imports de la UI, hooks, servicios y pruebas para reflejar la nueva estructura.
  - Se eliminaron carpetas vacias del layout antiguo y se valido el frontend con `npm run type-check` y `npm test -- --run` (`22` suites, `92` tests, todo verde).
