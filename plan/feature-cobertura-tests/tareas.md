[x] T-CT-1: Preparar infraestructura comun de testing y fixtures FHIR

### Descripcion
Crear utilidades compartidas para carga de payloads FHIR desde `src/test/resources/fhir` y dejar base comun para pruebas unitarias, funcionales y de sistema.

### Dependencias
(ninguna).

### Criterios de validacion
- Existe soporte comun para leer JSON de `payloads` y datasets de 10.000 eventos.
- No se duplica logica de carga de recursos entre suites.
- El proyecto compila con los nuevos soportes de test.

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
- Componentes: test-support, fhir
- Feature: feature-cobertura-tests

### Resumen de ejecucion
- Archivos modificados: `plan/feature-cobertura-tests/tareas.md`
- Archivos creados: `src/test/java/com/example/tfgenriquemoragaiax/support/FhirTestDataLoader.java`
- Acciones realizadas:
  - Se creo una utilidad comun para cargar fixtures FHIR desde classpath con cache en memoria y copia defensiva (`deepCopy`).
  - Se incorporaron accesos directos a `payloads` y datasets masivos (`tensiometro-bundles-10000.json`, `tensiometro-collection-10000.json`).
  - Se anadieron helpers de conteo y extraccion para escenarios de pruebas masivas.
  - Se verifico compilacion de tests con `JAVA_HOME=~/.jdks/openjdk-25.0.2` mediante `./mvnw -q -DskipTests test-compile`.

---

[x] T-CT-2: Implementar pruebas unitarias de provider, trust y consumer

### Descripcion
Ampliar cobertura unitaria de dominio para reglas clave de validacion FHIR, politicas de acceso y resolucion de jobs de consumo.

### Dependencias
T-CT-1.

### Criterios de validacion
- Pruebas unitarias nuevas en `provider/domain`, `trust/domain` y `consumer/domain`.
- Cobertura de casos positivos y negativos representativos.
- Validacion de codigos/estados esperados (`CONFLICT`, `FHIR_VALIDATION_ERROR`, `APPROVED`, `REJECTED`, `SUCCEEDED`, `FAILED`).

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
- Componentes: provider, trust, consumer, unit
- Feature: feature-cobertura-tests

### Resumen de ejecucion
- Archivos modificados: `plan/feature-cobertura-tests/tareas.md`, `src/test/java/com/example/tfgenriquemoragaiax/provider/domain/FhirValidationServiceUnitTest.java`
- Archivos creados: `src/test/java/com/example/tfgenriquemoragaiax/provider/domain/DatasetServiceUnitTest.java`, `src/test/java/com/example/tfgenriquemoragaiax/provider/domain/FhirValidationServiceUnitTest.java`, `src/test/java/com/example/tfgenriquemoragaiax/trust/domain/PolicyServiceUnitTest.java`, `src/test/java/com/example/tfgenriquemoragaiax/trust/domain/TrustServiceUnitTest.java`, `src/test/java/com/example/tfgenriquemoragaiax/consumer/domain/ConsumerServiceUnitTest.java`
- Acciones realizadas:
  - Se anadieron pruebas unitarias de dominio para `provider`, `trust` y `consumer` con escenarios positivos y negativos.
  - Se reutilizo `FhirTestDataLoader` para construir casos con `payloads` y referencias a datasets de 10.000 eventos.
  - Se cubrieron validaciones y estados clave: `FHIR_VALIDATION_ERROR`, `CONFLICT`, `VALIDATION_ERROR`, `NOT_FOUND`, `APPROVED`, `REJECTED`, `SUCCEEDED`, `FAILED`.
  - Se ejecuto bateria unitaria (`*UnitTest` + `*SmokeTest`) con `JAVA_HOME=/home/emora/.jdks/openjdk-25.0.2` y resultado correcto.

---

[x] T-CT-3: Implementar pruebas funcionales HTTP por modulo

### Descripcion
Crear pruebas funcionales de API para endpoints de provider, trust y consumer con `MockMvc` validando respuestas HTTP, contratos y errores.

### Dependencias
T-CT-1, T-CT-2.

### Criterios de validacion
- Existen pruebas funcionales para `POST/GET` de datasets.
- Existen pruebas funcionales para `POST/GET` de access requests y `POST` de validacion de politicas.
- Existen pruebas funcionales para `POST/GET` de consumption jobs.
- Se validan status codes y payloads de error.

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
- Componentes: provider, trust, consumer, api
- Feature: feature-cobertura-tests

### Resumen de ejecucion
- Archivos modificados: `plan/feature-cobertura-tests/tareas.md`, `src/main/java/com/example/tfgenriquemoragaiax/provider/api/ProviderExceptionHandler.java`, `src/main/java/com/example/tfgenriquemoragaiax/trust/api/TrustExceptionHandler.java`, `src/main/java/com/example/tfgenriquemoragaiax/consumer/api/ConsumerExceptionHandler.java`
- Archivos creados: `src/test/java/com/example/tfgenriquemoragaiax/provider/api/ProviderApiFunctionalTest.java`, `src/test/java/com/example/tfgenriquemoragaiax/trust/api/TrustApiFunctionalTest.java`, `src/test/java/com/example/tfgenriquemoragaiax/consumer/api/ConsumerApiFunctionalTest.java`
- Acciones realizadas:
  - Se implementaron pruebas funcionales HTTP por modulo con `MockMvc` en contexto web `MOCK` (sin sockets) para validar endpoints de `provider`, `trust` y `consumer`.
  - Se cubrieron flujos validos e invalidos, verificando codigos de estado y payloads de error.
  - Se detecto y corrigio un bug de enrutado de excepciones entre modulos: los `@RestControllerAdvice` globales capturaban errores de otros dominios; se restringieron por `basePackages` para cada API.
  - Se anadio tolerancia a `HttpServletRequest` nulo en `requestId(...)` de los tres exception handlers.
  - Se valido la suite funcional con `JAVA_HOME=/home/emora/.jdks/openjdk-25.0.2` mediante `./mvnw -q -Dtest='*FunctionalTest' test`.

---

[] T-CT-4: Implementar pruebas de sistema E2E con datos FHIR reales

### Descripcion
Implementar pruebas de sistema que recorran el flujo completo `provider -> trust -> consumer` usando payloads FHIR del repositorio, incluyendo un escenario con dataset masivo.

### Dependencias
T-CT-2, T-CT-3.

### Criterios de validacion
- Prueba E2E completa valida publicacion, autorizacion y consumo.
- Se utiliza al menos un payload de `payloads` y un caso con `tensiometro-collection-10000.json`.
- Se verifican estados y coherencia de identificadores entre servicios.

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
- Componentes: system, e2e, fhir
- Feature: feature-cobertura-tests

### Resumen de ejecucion
(se anade automaticamente justo antes de marcar `[x]`)

---

[] T-CT-5: Ejecutar suite completa y documentar resultados

### Descripcion
Ejecutar `mvn test`, corregir incidencias y dejar evidencia de resultados en este `tareas.md` mediante resumentes de ejecucion.

### Dependencias
T-CT-2, T-CT-3, T-CT-4.

### Criterios de validacion
- Todas las pruebas nuevas y existentes pasan en local.
- Cada tarea completada contiene su resumen de ejecucion antes de marcar `[x]`.
- Se informa al usuario para validacion final `[v]` de la feature.

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
- Componentes: regression, test-runner
- Feature: feature-cobertura-tests

### Resumen de ejecucion
(se anade automaticamente justo antes de marcar `[x]`)
