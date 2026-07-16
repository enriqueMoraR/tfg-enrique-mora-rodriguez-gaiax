# Fase 2 - Analisis tecnico (feature-cobertura-tests)

## Entrada funcional aprobada
La feature busca generar pruebas unitarias, funcionales y de sistema para todo el proyecto usando datos FHIR reales disponibles en `src/test/resources/fhir`.

## Objetivo tecnico
Implementar una estrategia de pruebas por capas que:
1. Maximice cobertura de reglas criticas (validacion FHIR, politicas, consumo).
2. Mantenga tiempos de ejecucion razonables en `mvn test`.
3. Reutilice de forma consistente los recursos FHIR pequenos y masivos (10.000 eventos).

## Decisiones tecnicas de la feature
1. Framework base:
- JUnit 5 + AssertJ + Mockito (incluido en `spring-boot-starter-test`).
2. Pruebas funcionales de API:
- `@SpringBootTest` + `@AutoConfigureMockMvc` para validar contrato HTTP real de controladores + servicios.
3. Pruebas de sistema:
- `@SpringBootTest` con flujo E2E completo en una sola JVM.
- Sobrescritura de `TrustAccessClient` en test para enrutar `consumer -> trust` dentro del mismo contexto de prueba.
4. Gestion de fixtures:
- Clase utilitaria de test para cargar JSON desde `src/test/resources/fhir` y evitar duplicacion.
5. Politica de datos masivos:
- Usar ficheros de 10.000 eventos en un conjunto reducido de pruebas representativas para evitar lentitud excesiva.

## Arquitectura de suites de test
1. Unitarias (dominio puro)
- `provider/domain`:
  - `FhirValidationService` (casos validos/invalidos, codigos LOINC, formato datetime, componentes BP).
  - `DatasetService` (conflicto de ids, filtros, paginacion, validaciones basicas).
- `trust/domain`:
  - `PolicyService` (allowed/denied segun role-scope-purpose-dataset).
  - `TrustService` (creacion de solicitudes, resolucion de estado y auditoria).
- `consumer/domain`:
  - `ConsumerService` (job `SUCCEEDED` y `FAILED` segun estado de acceso).
2. Funcionales (API por modulo)
- `provider/api`: `POST /api/v1/datasets/fhir` y `GET /api/v1/datasets`.
- `trust/api`: `POST /api/v1/access-requests`, `GET /api/v1/access-requests/{id}`, `POST /api/v1/policies/validate`.
- `consumer/api`: `POST /api/v1/consumption-jobs`, `GET /api/v1/consumption-jobs/{id}`.
3. Sistema (E2E)
- Flujo completo:
  - alta dataset FHIR,
  - alta solicitud de acceso,
  - validacion/resolucion de acceso,
  - creacion y consulta de job de consumo.
- Verificacion de estados esperados (`PUBLISHED`, `APPROVED`, `SUCCEEDED`) y coherencia de ids.

## Estrategia de uso de datos FHIR
1. Fixtures pequenos:
- `fhir/payloads/bundle-sample.json`
- `fhir/payloads/collection-sample.json`
- `fhir/payloads/observation-sample.json`
2. Fixtures masivos:
- `fhir/tensiometro-bundles-10000.json` (10000 bundles / 10000 observations).
- `fhir/tensiometro-collection-10000.json` (1 bundle / 10000 observations).
3. Reglas de uso:
- Unitario/funcional: priorizar fixtures pequenos.
- Sistema y validacion de robustez: incluir al menos un caso con `collection-10000`.
- Comprobaciones estructurales del dataset masivo sin multiplicar escenarios redundantes.

## Estructura propuesta de paquetes de test
1. `src/test/java/com/example/tfgenriquemoragaiax/support/`
- utilidades comunes de carga de recursos FHIR.
2. `src/test/java/com/example/tfgenriquemoragaiax/provider/domain/`
- unitarios del dominio provider.
3. `src/test/java/com/example/tfgenriquemoragaiax/trust/domain/`
- unitarios del dominio trust.
4. `src/test/java/com/example/tfgenriquemoragaiax/consumer/domain/`
- unitarios del dominio consumer.
5. `src/test/java/com/example/tfgenriquemoragaiax/provider/api/`
6. `src/test/java/com/example/tfgenriquemoragaiax/trust/api/`
7. `src/test/java/com/example/tfgenriquemoragaiax/consumer/api/`
8. `src/test/java/com/example/tfgenriquemoragaiax/system/`
- pruebas de sistema E2E.

## Cobertura minima esperada por comportamiento
1. Provider:
- validacion FHIR correcta para blood-pressure.
- rechazo de payload invalido con `FHIR_VALIDATION_ERROR`.
- rechazo de `datasetId` duplicado con `CONFLICT`.
2. Trust:
- solicitud valida queda `PENDING` y pasa a `APPROVED` o `REJECTED` al consultar.
- politica exige `dataset.read` y `purpose=research`.
3. Consumer:
- job termina en `SUCCEEDED` si access request aprobado y dataset coincide.
- job termina en `FAILED` en caso contrario.
4. Sistema:
- cadena completa E2E sin mocks de negocio (solo sustitucion tecnica de cliente HTTP para entorno local de test).

## Riesgos tecnicos y mitigaciones
1. Riesgo: lentitud por parseo de archivos grandes.
- Mitigacion: limitar su uso a pocas pruebas de alto valor.
2. Riesgo: fragilidad por acoplamiento a red/puertos.
- Mitigacion: usar MockMvc y contexto Spring local.
3. Riesgo: duplicidad entre pruebas funcionales y de sistema.
- Mitigacion: diferenciar alcance por nivel y assertions.

## Criterios tecnicos de aceptacion
1. Suites separadas por nivel (unitario/funcional/sistema).
2. Uso efectivo de recursos FHIR del repositorio.
3. Ejecucion correcta con `mvn test`.
4. Sin dependencias externas nuevas para correr tests.
5. Evidencia en `tareas.md` de la feature con resultados de ejecucion.
