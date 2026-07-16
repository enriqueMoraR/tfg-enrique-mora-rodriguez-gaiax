# Fase 1 - Analisis funcional (feature-cobertura-tests)

## Contexto
El repositorio ya contiene servicios `provider`, `trust` y `consumer`, con un conjunto minimo de smoke tests.
Tambien existe un dataset FHIR de pruebas en:
- `src/test/resources/fhir/payloads/*.json` (muestras pequenas)
- `src/test/resources/fhir/tensiometro-bundles-10000.json` (10.000 bundles)
- `src/test/resources/fhir/tensiometro-collection-10000.json` (1 bundle con 10.000 observaciones)

La solicitud es ampliar la cobertura de calidad para todo el proyecto, generando pruebas unitarias, funcionales y de sistema usando esos datos.

## Objetivo funcional de la feature
Disponer de una bateria de pruebas automatizadas que valide:
1. Reglas de negocio internas (unitario).
2. Comportamiento de APIs por modulo (funcional).
3. Flujo extremo a extremo del sistema (sistema).

El objetivo es detectar regresiones de validacion FHIR, autorizacion y consumo antes de despliegue.

## Alcance funcional
1. Cobertura unitaria en componentes clave:
- validacion FHIR del provider.
- politicas y resolucion de solicitudes en trust.
- resolucion de jobs de consumo en consumer.
2. Cobertura funcional HTTP de endpoints:
- `POST/GET` de datasets.
- `POST/GET` de access requests y validacion de politica.
- `POST/GET` de consumption jobs.
3. Cobertura de sistema:
- escenario E2E completo `provider -> trust -> consumer`.
- uso de payloads FHIR reales del repositorio.
4. Validaciones con datos masivos:
- lectura y uso controlado de los ficheros de 10.000 eventos para asegurar compatibilidad con el baseline del MVP.

## Fuera de alcance
1. Sustituir pruebas de carga (k6/JMeter/Gatling) por esta suite.
2. Cambios funcionales en endpoints/contratos.
3. Integracion con Jira en esta iteracion (no configurado actualmente).

## Actores y valor
1. Desarrollador: obtiene feedback rapido en CI/local.
2. Tutor/evaluador TFG: recibe evidencia reproducible de robustez.
3. Operador tecnico: reduce riesgo de regresion en flujo E2E.

## Requisitos funcionales de la feature
- RF-CT-01: Debe existir suite unitaria para reglas core de provider/trust/consumer.
- RF-CT-02: Debe existir suite funcional por API con casos validos e invalidos.
- RF-CT-03: Debe existir al menos una prueba de sistema E2E con flujo completo.
- RF-CT-04: Las suites deben consumir datos de `src/test/resources/fhir`.
- RF-CT-05: La suite debe ejecutarse con `mvn test` sin pasos manuales adicionales.

## Criterios de aceptacion
1. Se incorporan pruebas unitarias, funcionales y de sistema para los tres modulos.
2. Se cubren casos positivos y negativos relevantes por modulo.
3. Se usan muestras FHIR reales y al menos un escenario con dataset de 10.000 eventos.
4. Todas las pruebas nuevas pasan en local.
5. La evidencia de ejecucion queda reflejada en `plan/feature-cobertura-tests/tareas.md`.

## Riesgos funcionales
1. Tiempo de ejecucion excesivo por uso de datos grandes.
2. Fragilidad de pruebas E2E si dependen de puertos/estado global.
3. Solapamiento entre niveles de prueba si no se separan responsabilidades.

## Mitigaciones funcionales
1. Limitar pruebas con datos de 10.000 a escenarios representativos.
2. Aislar estado entre tests y evitar dependencias externas.
3. Definir claramente que valida cada nivel (unitario/funcional/sistema).

## Preguntas funcionales pendientes
1. (sin preguntas bloqueantes para pasar a Fase 2)
