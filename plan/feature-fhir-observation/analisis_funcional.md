# Analisis Funcional - FHIR Observation Compatibility

**Feature:** `feature-fhir-observation`  
**Version:** 1.0  
**Fecha creacion:** 2026-06-10

---

## Objetivo General
Hacer compatible el stack Gaia-X Health con recursos HL7 FHIR `Observation` directos, sin perder la compatibilidad con el contrato actual basado en `Bundle`, y preservando los metadatos de soberania y consentimiento necesarios para el dominio de salud.

## Problema a Resolver
El stack actual funciona con bundles FHIR y con un subconjunto de `Observation`, pero no acepta de forma natural una observacion clinica completa como la que se usa en el dominio real. Eso dificulta:
- reutilizar payloads FHIR reales;
- conservar contexto clinico y de soberania;
- mostrar provenance y consentimiento de forma coherente en el dashboard;
- validar el contrato de entrada contra recursos mas cercanos a un caso de uso FHIR R4 real.

## Alcance Funcional
### Incluido
- Aceptar `Observation` directa como entrada funcional equivalente al contrato actual basado en `Bundle`.
- Validar campos clinicos y de soberania relevantes:
  - `meta.profile`
  - `meta.tag`
  - `status`
  - `category`
  - `code`
  - `subject`
  - `effectiveDateTime`
  - `issued`
  - `performer`
  - `bodySite`
  - `device`
- Mantener compatibilidad con los casos del MVP:
  - tension arterial
  - frecuencia cardiaca
- Mostrar en el dashboard el contexto minimo necesario de la observacion y su provenance.
- Regenerar fixtures y pruebas con la estructura real aportada por el usuario.

### Excluido
- Soporte completo de todo HL7 FHIR R4/R5.
- Persistencia historica de versiones FHIR.
- Orquestacion federada completa o conector Gaia-X adicional.
- Nuevos casos clinicos fuera del MVP actual.

## Actores
1. Proveedor de datos:
   - Publica observaciones FHIR validadas.
   - Adjunta metadatos de soberania.
2. Consumidor de datos:
   - Recupera y normaliza observaciones.
   - Preserva trazabilidad y consentimiento.
3. Dashboard:
   - Presenta el contexto minimo de la observacion.
   - Muestra provenance y estado del acceso.
4. Operador tecnico:
   - Verifica que la compatibilidad no rompe el flujo E2E.

## Flujos Funcionales
### F1 - Publicacion de Observation directa
1. El provider recibe un recurso `Observation`.
2. Valida estructura FHIR, codigo clinico y metadatos de soberania.
3. Si es valido, lo publica como dataset o payload equivalente.

### F2 - Consumo de Observation
1. El consumer obtiene la observacion aprobada.
2. Normaliza el recurso manteniendo los campos clinicos relevantes.
3. Exponer solo el contexto necesario para analitica y visualizacion.

### F3 - Visualizacion en dashboard
1. El dashboard recibe la observacion normalizada.
2. Renderiza el valor clinico y el contexto de provenance.
3. Indica el estado del consentimiento asociado.

## Requisitos Funcionales
- RF-01: El sistema debe aceptar `Observation` directa sin obligar siempre a `Bundle`.
- RF-02: El sistema debe seguir aceptando `Bundle` para compatibilidad retroactiva.
- RF-03: El sistema debe validar los metadatos de soberania incluidos en `meta.tag`.
- RF-04: El sistema debe conservar el contexto clinico minimo necesario.
- RF-05: El dashboard debe mostrar una vista utilizable del recurso sin exponer campos innecesarios.
- RF-06: Las pruebas deben cubrir el nuevo contrato con fixtures reales.

## Criterios de Aceptacion
1. Una `Observation` valida pasa por provider, consumer y dashboard sin conversion manual previa.
2. Una `Observation` invalida se rechaza con errores claros.
3. El contrato viejo con `Bundle` sigue funcionando.
4. El dashboard muestra al menos:
   - codigo o tipo de observacion;
   - valor;
   - fecha/hora;
   - dispositivo o provenance basica cuando exista.
5. Los tests incluyen el JSON real aportado por el usuario.

## Riesgos
1. Duplicar logica entre soporte de `Bundle` y soporte de `Observation`.
2. Perder compatibilidad con fixtures antiguos si se cambia el contrato de forma demasiado agresiva.
3. Sobrecargar la UI si se decide mostrar todo el contexto FHIR en vez del minimo necesario.

## Preguntas Pendientes
1. ¿El provider debe aceptar `Observation` y `Bundle` indistintamente o priorizar `Observation` como contrato principal?
2. ¿El dashboard debe mostrar `meta.tag` completo o solo el resumen de politica/consentimiento?

## Impacto por Proyecto
### Provider
- Aceptar `Observation` directa y validar metadatos FHIR ampliados.

### Consumer
- Preservar campos clinicos y de provenance al normalizar los recursos.

### Dashboard
- Adaptar tipos, transformadores y vistas para el nuevo recurso real.

### Deployment
- Mantener compatibilidad con el contrato anterior mientras se despliega el cambio.

