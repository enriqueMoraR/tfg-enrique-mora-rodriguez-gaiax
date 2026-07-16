# Plan de Tareas - FHIR Observation Compatibility

**Feature:** `feature-fhir-observation`  
**Version:** 1.0  
**Fecha creacion:** 2026-06-10

---

[x] O-1: Aceptar Observation directa en provider

### Descripcion
Modificar `gaiax-health-provider-node` para que acepte `Observation` directa ademas de `Bundle`, y validar los campos clinicos y de soberania relevantes del recurso aportado por el usuario.

### Dependencias
(ninguna)

### Criterios de validacion
- El provider acepta `Observation` valida sin wrapper manual.
- El provider sigue aceptando `Bundle` para compatibilidad.
- Se validan `meta.profile`, `meta.tag`, `status`, `category`, `code`, `subject`, `effectiveDateTime`, `issued`, `performer`, `bodySite` y `device`.

### Feedback al agente
- [x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Tipo: feature
- Componentes: provider, fhir, validation
- Feature: feature-fhir-observation

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-provider-node/src/main/java/com/example/gaiahealth/provider/domain/FhirValidationService.java`, `gaiax-health-provider-node/src/main/java/com/example/gaiahealth/provider/domain/DatasetService.java`, `gaiax-health-provider-node/src/main/java/com/example/gaiahealth/provider/domain/DatasetType.java`, `gaiax-health-provider-node/src/test/java/com/example/gaiahealth/provider/domain/FhirValidationServiceUnitTest.java`, `gaiax-health-provider-node/src/test/java/com/example/gaiahealth/provider/domain/DatasetServiceUnitTest.java`, `gaiax-health-provider-node/src/test/java/com/example/gaiahealth/provider/api/ProviderApiFunctionalTest.java`, `gaiax-health-provider-node/src/test/java/com/example/gaiahealth/provider/support/FhirTestDataLoader.java`, `gaiax-health-provider-node/src/test/resources/fhir/payloads/observation-real-2026.json`
- Archivos creados: `gaiax-health-provider-node/src/test/resources/fhir/payloads/observation-real-2026.json`
- Acciones realizadas: el provider ya acepta `Observation` directa y `Bundle`, valida perfil vitalsigns, tag de soberania, categoria, codigo, sujeto, issued y contexto de dispositivo, y el contrato de dataset distingue `FHIR_BUNDLE` y `FHIR_OBSERVATION`.

---

[x] O-2: Preservar contexto clinico en consumer

### Descripcion
Actualizar `gaiax-health-consumer-node` para mantener el contexto clinico y de provenance de una `Observation` real al normalizar los datos antes de entregarlos al dashboard.

### Dependencias
O-1

### Criterios de validacion
- El consumer no descarta `issued`, `performer`, `device` ni `bodySite` si estan presentes.
- El consumo sigue estando protegido por el flujo de autorizacion existente.
- La normalizacion sigue soportando los casos del MVP actuales.

### Feedback al agente
- [x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Tipo: feature
- Componentes: consumer, normalizacion, provenance
- Feature: feature-fhir-observation

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-consumer-node/src/main/java/com/example/gaiahealth/consumer/domain/ConsumerService.java`, `gaiax-health-consumer-node/src/test/java/com/example/gaiahealth/consumer/domain/ConsumerServiceTest.java`, `gaiax-health-consumer-node/src/test/resources/fhir/payloads/observation-real-2026.json`
- Archivos creados: `gaiax-health-consumer-node/src/test/resources/fhir/payloads/observation-real-2026.json`
- Acciones realizadas: el consumer ahora procesa payloads `Bundle` y `Observation`, preserva provenance clinica al normalizar mediciones y mantiene el valor sintetico para compatibilidad con el dashboard.

---

[x] O-3: Ampliar tipos y vista del dashboard

### Descripcion
Refactorizar `gaiax-health-dashboard` para soportar el nuevo modelo FHIR, mostrando la informacion minima necesaria de la observacion real y el contexto basico de provenance y consentimiento.

### Dependencias
O-1, O-2

### Criterios de validacion
- Los tipos TypeScript representan el nuevo recurso.
- `dataTransform` funciona con el JSON real aportado por el usuario.
- La UI muestra valor, fecha y contexto minimo sin romper la experiencia actual.

### Feedback al agente
- [x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Media
- Tipo: feature
- Componentes: dashboard, ui, fhir
- Feature: feature-fhir-observation

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-dashboard/src/types/fhir.ts`, `gaiax-health-dashboard/src/types/domain.ts`, `gaiax-health-dashboard/src/services/dataTransform.ts`, `gaiax-health-dashboard/src/components/MeasurementsTable.tsx`, `gaiax-health-dashboard/src/tests/services/dataTransform.fixtures.test.ts`, `gaiax-health-dashboard/src/tests/components/MeasurementsTable.test.tsx`, `gaiax-health-dashboard/src/tests/fixtures/observation-real-2026.json`
- Archivos creados: `gaiax-health-dashboard/src/tests/fixtures/observation-real-2026.json`
- Acciones realizadas: ampliados tipos FHIR y de medicion con provenance opcional, extraidos metadatos de soberania en la transformacion y mostrados en la tabla de mediciones sin romper la vista existente.

---

[x] O-4: Actualizar fixtures y pruebas de contrato

### Descripcion
Crear o adaptar fixtures y tests para cubrir el nuevo payload FHIR real y asegurar que el cambio no rompe la compatibilidad con el flujo actual.

### Dependencias
O-1, O-2, O-3

### Criterios de validacion
- Existe un fixture real con la `Observation` aportada por el usuario.
- Hay tests de provider, consumer y dashboard sobre el nuevo contrato.
- El contrato previo con `Bundle` sigue pasando.

### Feedback al agente
- [x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Tipo: test
- Componentes: tests, fixtures, contract
- Feature: feature-fhir-observation

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-provider-node/src/test/java/com/example/gaiahealth/provider/api/ProviderApiFunctionalTest.java`, `gaiax-health-provider-node/src/test/java/com/example/gaiahealth/provider/domain/FhirValidationServiceUnitTest.java`, `gaiax-health-provider-node/src/test/java/com/example/gaiahealth/provider/domain/DatasetServiceUnitTest.java`, `gaiax-health-consumer-node/src/test/java/com/example/gaiahealth/consumer/domain/ConsumerServiceTest.java`, `gaiax-health-dashboard/src/tests/services/dataTransform.fixtures.test.ts`
- Archivos creados: `gaiax-health-provider-node/src/test/resources/fhir/payloads/observation-real-2026.json`, `gaiax-health-consumer-node/src/test/resources/fhir/payloads/observation-real-2026.json`, `gaiax-health-dashboard/src/tests/fixtures/observation-real-2026.json`
- Acciones realizadas: se incorporo el JSON real como fixture de contrato en provider, consumer y dashboard; se añadieron pruebas de observacion directa, validacion de soberania y normalizacion de provenance.
