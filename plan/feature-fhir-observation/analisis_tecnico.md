# Analisis Tecnico - FHIR Observation Compatibility

**Feature:** `feature-fhir-observation`  
**Version:** 1.0  
**Fecha creacion:** 2026-06-10

---

## Entrada Funcional
Esta feature introduce compatibilidad con recursos `Observation` directos en el stack existente, manteniendo soporte para `Bundle` como contrato de transicion.

## Objetivo Tecnico
Normalizar una observacion FHIR real con metadatos de soberania para que el flujo provider -> trust -> consumer -> dashboard pueda operar con payloads mas cercanos a produccion sin perder interoperabilidad con el MVP actual.

## Decisiones Tecnicas
### DT-001: Contrato dual `Observation` + `Bundle`
- El provider debe aceptar ambos formatos.
- `Bundle` se mantiene para compatibilidad.
- `Observation` directa se convierte en ruta preferente para nuevos payloads reales.

### DT-002: Validacion FHIR ampliada
- Validar no solo `resourceType`, `status` y `code`, sino tambien:
  - `meta.profile`
  - `meta.tag`
  - `category`
  - `subject`
  - `effectiveDateTime` / `issued`
  - `performer`
  - `bodySite`
  - `device`
- Los errores deben seguir un formato procesable por tests y UI.

### DT-003: Normalizacion de provenance
- El consumer debe preservar el contexto clinico relevante.
- El dashboard no debe depender de campos descartados en el normalizador.
- La trazabilidad de consentimiento se debe mantener como metadata separada o embebida segun contrato.

### DT-004: Tipado frontend mas expresivo
- El modelo TypeScript debe reflejar el recurso real.
- Los transformadores deben tolerar observaciones con o sin `Bundle`.
- La UI debe mostrar campos clinicos utiles sin exponer mas de lo necesario.

### DT-005: Fixtures reales como fuente de verdad
- El JSON proporcionado por el usuario debe convertirse en fixture de prueba.
- Los tests deben verificar que el payload real pasa por provider, consumer y dashboard.

## Arquitectura Objetivo
```text
[Observation JSON real]
        |
        v
[provider] -- valida FHIR + soberania --> [store/catalogo]
        |
        v
[trust-service] -- decision consentimiento -->
        |
        v
[consumer] -- normaliza Observation/Bundle --> [dashboard]
        |
        v
[dashboard] -- renderiza contexto minimo + provenance
```

## Cambios por Repositorio
### gaiax-health-provider-node
- Aceptar `Observation` directa en la capa HTTP.
- Ampliar reglas de validacion FHIR y metadatos de soberania.
- Alinear errores con el contrato de validacion actual.

### gaiax-health-consumer-node
- Mantener `issued`, `performer`, `device`, `bodySite` y campos asociados si el payload los contiene.
- Seguir soportando el flujo de consumo autorizado sin exponer datos sensibles.

### gaiax-health-dashboard
- Ampliar `FhirObservation` y tipos derivados.
- Alinear `dataTransform` con observaciones reales.
- Ajustar tabla, detalle y grafico si hacen uso del nuevo contexto.

### tests/fixtures
- Incluir fixture real aportado por el usuario.
- Añadir pruebas de contrato y de normalizacion.

## Contratos y Validaciones
1. Entrada:
   - `Observation` directa valida.
   - `Bundle` con `Observation` valida.
2. Salud de recurso:
   - `status = final`
   - `code = 85354-9` para tension arterial
   - `component` con `8480-6` y `8462-4`
3. Soberania:
   - `meta.profile` presente.
   - `meta.tag` presente y trazable.
4. UI:
   - no perder timestamp ni valor.
   - mantener provenance basica.

## ADR Nuevos o Ajustados
### ADR-011 - Contrato dual FHIR para interoperabilidad pragmatica
El stack acepta `Observation` directa y `Bundle` para evitar roturas y facilitar la adopcion gradual de payloads reales.

### ADR-012 - Metadata de soberania como parte del recurso
La soberania no se modela solo en el dataset; se refleja tambien en el recurso FHIR o en su envoltorio inmediato.

## Riesgos Tecnicos
1. Si el provider se vuelve demasiado permisivo, puede degradarse la consistencia de los datasets.
2. Si el dashboard intenta pintar todo el recurso, se pierde la ventaja de minimizacion.
3. Si los tests usan fixtures simplificados, no cubren el contrato real del usuario.

## Plan de Integracion
1. Ampliar provider.
2. Ajustar consumer.
3. Actualizar dashboard.
4. Renovar fixtures y tests.
5. Validar E2E con el payload real.

