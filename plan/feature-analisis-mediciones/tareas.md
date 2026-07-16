# Plan de Tareas — Análisis de Mediciones

**Feature:** `feature-analisis-mediciones`  
**Versión:** 1.0 (borrador MVP)  
**Fecha creación:** 2026-06-11

---

## Resumen Ejecutivo

- **Tareas totales previstas:** 6
- **Tareas completadas:** 6
- **Estimado:** ~18-24 horas
- **Dependencia:** `gaiax-health-dashboard` con acceso a `/api/fhir`
- **Entregable:** nueva página `Análisis de Mediciones` con filtros, gráficos y exportación
- **Estado actual:** ✅ completada, pendiente de validación humana

---

## Fase A: Base analítica y adaptación FHIR

### [x] A-1: Crear modelo analítico y adaptador FHIR

### Descripción
Definir tipos, adaptador y normalización de datos FHIR para convertir `Bundle` y `Observation` en un modelo optimizado para visualización.

### Dependencias
(ninguna)

### Criterios de validación
- Existen tipos `AnalyticsPatient`, `AnalyticsObservation`, `AnalyticsSeries`, `AnalyticsStats` y `AnalyticsFilters`.
- Existe un adaptador que convierte bundles FHIR en dataset analítico compacto.
- Se preservan `patient`, `device`, `unit`, `timestamp`, `sex` y `ageGroup`.
- El adaptador soporta `Observation` directa y `Bundle` con múltiples entradas.

### Feedback al agente
[x] F-1: Validación completada sin incidencias; no se derivan mejoras adicionales en esta tarea.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronización: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: setup
- Componentes: analysis, fhir-adapter, types
- Feature: feature-analisis-mediciones

### Resumen de ejecución
- Archivos modificados: `src/types/analysis.ts`, `src/types/index.ts`, `src/services/analysis/fhirAnalysisAdapter.ts`, `src/tests/services/analysis/fhirAnalysisAdapter.test.ts`
- Archivos creados: `src/types/analysis.ts`, `src/services/analysis/fhirAnalysisAdapter.ts`, `src/tests/services/analysis/fhirAnalysisAdapter.test.ts`
- Acciones realizadas: se definió el modelo analítico, se implementó el adaptador FHIR para `Bundle` y `Observation`, se normalizaron pacientes/dispositivos/mediciones y se validó con 2 tests verdes.

---

### [x] A-2: Implementar capa de cálculo analítico

### Descripción
Crear la lógica de agregación y estadística para medias, medianas, percentiles, desviación estándar, histograma, box plot e IQR.

### Dependencias
A-1

### Criterios de validación
- Se calculan media, mediana, desviación estándar, mínimo, máximo, percentiles 25/75 e IQR.
- Se identifican anomalías con regla `1.5 * IQR`.
- Se generan series agregadas por paciente, tipo de medición y rango temporal.
- Los cálculos están desacoplados de los componentes visuales.

### Feedback al agente
[x] F-1: Validación completada sin incidencias; no se derivan mejoras adicionales en esta tarea.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronización: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: feature
- Componentes: analysis, statistics
- Feature: feature-analisis-mediciones

### Resumen de ejecución
- Archivos modificados: `src/services/analysis/analyticsStatistics.ts`, `src/services/analysis/fhirAnalysisAdapter.ts`, `src/types/analysis.ts`, `src/tests/services/analysis/analyticsStatistics.test.ts`
- Archivos creados: `src/services/analysis/analyticsStatistics.ts`, `src/tests/services/analysis/analyticsStatistics.test.ts`
- Acciones realizadas: se implementó la capa de cálculo analítico para estadísticas descriptivas, histogramas, box plot, agregados temporales y agrupaciones por paciente/tipo; se refactorizó el adaptador FHIR para reutilizar la estadística central; se validó con 5 tests y type-check verde.

---

## Fase B: UI principal y filtros

### [x] A-3: Construir panel de filtros y estado en URL

### Descripción
Implementar filtros por paciente, tipo de medición, intervalo temporal, sexo y grupo de edad, manteniendo el estado sincronizado con la URL.

### Dependencias
A-1, A-2

### Criterios de validación
- Los filtros actualizan todos los gráficos en tiempo real.
- El estado queda persistido en la query string.
- Existen opciones para todos los tipos de medición presentes en el bundle.
- El selector de grupo de edad incluye `0-18`, `19-40`, `41-65` y `65+`.

### Feedback al agente
[x] F-1: Validación completada sin incidencias; no se derivan mejoras adicionales en esta tarea.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronización: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: feature
- Componentes: ui, filters, routing
- Feature: feature-analisis-mediciones

### Resumen de ejecución
- Archivos modificados: `src/components/analysis/AnalyticsFiltersPanel.tsx`, `src/hooks/useAnalyticsFilters.ts`, `src/pages/Dashboard.tsx`, `src/services/analysis/analyticsDataset.ts`, `src/services/analysis/analyticsFilters.ts`, `src/hooks/useFhirData.ts`
- Archivos creados: `src/components/analysis/AnalyticsFiltersPanel.tsx`, `src/hooks/useAnalyticsFilters.ts`, `src/services/analysis/analyticsDataset.ts`, `src/services/analysis/analyticsFilters.ts`, `src/tests/services/analysis/analyticsDataset.test.ts`
- Acciones realizadas: se implementó el panel de filtros para paciente, medición, sexo, edad y rango temporal; se sincronizó el estado con la URL; se añadió filtrado del dataset analítico y actualización de métricas/gráficos en tiempo real; se validó con tests de dataset, adaptador, app shell y dashboard.

---

### [x] A-4: Implementar visualización temporal con agregados

### Descripción
Crear la pestaña de evolución temporal con línea interactiva, media, percentiles, banda sombreada y zoom temporal.

### Dependencias
A-2, A-3

### Criterios de validación
- Se puede visualizar un paciente concreto o todos agregados.
- Se muestran media, percentil 25 y percentil 75.
- La banda intercuartílica queda sombreada.
- El gráfico admite zoom y selección de rango.
- El tooltip muestra fecha, valor, unidad y paciente.

### Feedback al agente
[x] F-1: Validación completada sin incidencias; no se derivan mejoras adicionales en esta tarea.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronización: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: feature
- Componentes: ui, temporal-chart, echarts
- Feature: feature-analisis-mediciones

### Resumen de ejecución
- Archivos modificados: `src/components/analysis/TemporalEchartsChart.tsx`, `src/pages/Dashboard.tsx`, `src/services/analysis/analyticsDataset.ts`, `src/types/analysis.ts`, `src/tests/components/analysis/TemporalEchartsChart.test.tsx`
- Archivos creados: `src/components/analysis/TemporalEchartsChart.tsx`, `src/tests/components/analysis/TemporalEchartsChart.test.tsx`
- Acciones realizadas: se sustituyó la serie temporal antigua por una vista analítica con media, percentiles, banda intercuartílica, zoom con Brush y modo paciente; se integró en la pestaña de analítica; se validó con tests y type-check.

---

### [x] A-5: Implementar distribución, scatter y panel de estadísticas

### Descripción
Construir los modos de distribución y comparación entre pacientes junto al panel lateral con estadísticas dinámicas.

### Dependencias
A-2, A-3

### Criterios de validación
- Existe histograma y box plot con detección de outliers.
- Existe scatter plot con color por sexo y tamaño por edad.
- El tooltip incluye nombre/ID de paciente, fecha, valor y unidad.
- El panel lateral muestra métricas dinámicas correctamente recalculadas.

### Feedback al agente
[x] F-1: Validación completada sin incidencias; no se derivan mejoras adicionales en esta tarea.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronización: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: feature
- Componentes: ui, stats, distribution, scatter, echarts
- Feature: feature-analisis-mediciones

### Resumen de ejecución
- Archivos modificados: `src/components/analysis/ComparisonScatterChart.tsx`, `src/components/analysis/MeasurementDistributionChart.tsx`, `src/components/analysis/AnalyticsStatsPanel.tsx`, `src/pages/Dashboard.tsx`, `src/tests/components/analysis/AnalyticsStatsPanel.test.tsx`, `src/tests/components/analysis/ComparisonScatterChart.test.tsx`
- Archivos creados: `src/components/analysis/MeasurementDistributionChart.tsx`, `src/components/analysis/ComparisonScatterChart.tsx`, `src/components/analysis/AnalyticsStatsPanel.tsx`, `src/tests/components/analysis/MeasurementDistributionChart.test.tsx`, `src/tests/components/analysis/ComparisonScatterChart.test.tsx`, `src/tests/components/analysis/AnalyticsStatsPanel.test.tsx`
- Acciones realizadas: se implementaron el histograma, el box plot, el scatter interactivo con color por sexo y tamaño por edad, y el panel lateral con estadisticas dinamicas; se ajustaron pruebas unitarias para el nuevo layout analitico; se validó con type-check y batería focalizada de tests verdes.

---

## Fase C: UX, exportación y validación

### [x] A-6: Añadir exportación, estados vacíos y pruebas

### Descripción
Completar exportación PNG/CSV, skeleton loaders, estados vacíos y cobertura de tests para la nueva página.

### Dependencias
A-4, A-5

### Criterios de validación
- Se exporta el gráfico activo a PNG.
- Se exportan los datos filtrados a CSV.
- Existen skeleton loaders y mensajes claros cuando no hay datos.
- Hay tests de componentes, hooks y adaptación FHIR.
- La feature funciona con al menos 2.000 observaciones y queda preparada para 5.000+.

### Feedback al agente
[x] F-1: Validación completada sin incidencias; no se derivan mejoras adicionales en esta tarea.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronización: no configurada

### Metadatos
- Prioridad: Alta
- Responsable: (opcional)
- Tipo: test
- Componentes: export, tests, ux
- Feature: feature-analisis-mediciones

### Resumen de ejecución
- Archivos modificados: `src/pages/Dashboard.tsx`, `src/tests/pages/Dashboard.test.tsx`, `src/services/analysis/analyticsExport.ts`, `src/tests/services/analysis/analyticsExport.test.ts`
- Archivos creados: `src/services/analysis/analyticsExport.ts`, `src/tests/services/analysis/analyticsExport.test.ts`
- Acciones realizadas: se añadieron exportaciones de PNG y CSV para la vista analítica activa, se incorporaron skeleton loaders en las vistas principales, se mejoraron los estados vacíos y se amplió la cobertura de pruebas para exportación y carga; se validó con type-check y 18 tests verdes.
