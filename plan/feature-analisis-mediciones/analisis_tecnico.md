# Análisis Técnico — Análisis de Mediciones

**Feature:** `feature-analisis-mediciones`  
**Versión:** 1.0 (borrador MVP)  
**Fecha creación:** 2026-06-11

---

## Entrada funcional aprobada
La feature añade una nueva página del dashboard para análisis clínico exploratorio sobre observaciones FHIR con volumen medio/alto. La interfaz debe soportar filtros dinámicos, tres modos de visualización, estadísticas calculadas al vuelo y exportación de resultados.

---

## Objetivo técnico
Diseñar una capa analítica en el frontend que:
1. Consuma y transforme bundles FHIR/Observation a un modelo optimizado para visualización.
2. Permita explorar tendencias, distribuciones y comparaciones entre pacientes sin saturar la interfaz.
3. Soporte al menos 5.000 observaciones con una experiencia fluida.
4. Mantenga el patrón visual y la arquitectura ya existente en `gaiax-health-dashboard`.

---

## Decisiones técnicas

### 1. Librería de gráficos
- **Decisión:** usar **ECharts** para esta feature.
- **Justificación:**
  - mejor soporte nativo para `dataZoom`, `scatter`, `boxplot`, `histogram` y bandas de rango;
  - mejor experiencia para conjuntos grandes de puntos;
  - exportación de imagen integrada;
  - mayor flexibilidad para visualización clínica avanzada que Recharts.
- **Trade-off:** mayor peso y complejidad que Recharts, pero asumible para esta pantalla concreta.

### 2. Fuente de datos
- **Decisión:** reutilizar el canal FHIR ya expuesto por el dashboard proxy (`/api/fhir`).
- **Motivo:** evita duplicar contratos y mantiene el flujo E2E actual.
- **Consumo principal:**
  - `GET /api/fhir/Observation?_count=...&_sort=-date`
  - `GET /api/fhir/Patient?_count=...`
- **Optimizaciones previstas:**
  - consultas con `_elements` y `_summary` cuando sea posible;
  - reducción de payload en vista analítica;
  - carga por lotes y lazy loading si el conjunto crece.

### 3. Modelo analítico intermedio
- **Decisión:** no renderizar directamente FHIR en los gráficos.
- **Motivo:** el render debe usar un modelo compacto, derivado y estable.
- **Modelo propuesto:**
  - `AnalyticsPatient`
  - `AnalyticsObservation`
  - `AnalyticsSeries`
  - `AnalyticsStats`
  - `AnalyticsFilters`

### 4. Gestión de estado
- **Decisión:** filtros y modo de visualización en URL con `useSearchParams`.
- **Motivo:** compartir vistas, reproducibilidad de análisis y navegación consistente.

### 5. Cálculo analítico
- **Decisión:** cálculos pesados centralizados en una capa de servicios/hooks, no en los componentes visuales.
- **Motivo:** separación clara de responsabilidades y mejor testabilidad.

---

## Arquitectura propuesta

```
src/
├── pages/
│   └── MeasurementsAnalysisPage.tsx
├── components/
│   └── analysis/
│       ├── AnalysisFiltersPanel.tsx
│       ├── AnalysisStatsPanel.tsx
│       ├── AnalysisTabs.tsx
│       ├── TemporalTrendChart.tsx
│       ├── DistributionChart.tsx
│       ├── PatientComparisonChart.tsx
│       └── AnalysisEmptyState.tsx
├── hooks/
│   └── analysis/
│       ├── useAnalysisDataset.ts
│       ├── useAnalysisFilters.ts
│       ├── useAnalysisStats.ts
│       └── useAnalysisExport.ts
├── services/
│   └── analysis/
│       ├── fhirAnalysisAdapter.ts
│       ├── analysisCalculator.ts
│       └── analysisExport.ts
└── types/
    └── analysis.ts
```

---

## Capa de adaptación FHIR

### Responsabilidad
Transformar bundles y observaciones FHIR en un modelo analítico uniforme, independientemente de si la entrada contiene:
- `Bundle` con múltiples recursos.
- `Observation` individual.
- combinaciones `Patient` + `Device` + `Observation`.

### Funciones clave
- `normalizeBundleToAnalyticsDataset(bundle)`
- `extractPatientsFromBundle(bundle)`
- `extractObservationsFromBundle(bundle)`
- `resolveMeasurementType(observation)`
- `resolvePatientProfile(patient, observation)`

### Reglas de normalización
1. Identificar el paciente por `subject.reference` y `Patient.id`.
2. Inferir el tipo de medición por `Observation.code.coding[0].code`.
3. Convertir tiempos a un formato único (`timestamp` UTC/ISO).
4. Derivar sexo, edad y grupo de edad a partir del paciente.
5. Preservar `unit`, `display`, `device`, `performer` y `encounter` para tooltips y comparativas.

---

## Lógica analítica

### Evolución temporal
- Agrupación por paciente y por tipo de medición.
- Cálculo de:
  - media;
  - percentil 25;
  - percentil 75;
  - banda intercuartílica.
- Selección de una serie individual o agregada.

### Distribución
- Construcción de histogramas por bins.
- Cálculo de box plot:
  - mediana;
  - Q1;
  - Q3;
  - IQR;
  - outliers por regla `1.5 * IQR`.

### Comparación entre pacientes
- Scatter plot:
  - color por sexo;
  - tamaño por edad;
  - tooltip enriquecido;
  - selección de puntos para inspección.

### Estadísticas dinámicas
- Número total de pacientes filtrados.
- Número total de observaciones.
- Media, mediana, desviación estándar.
- Min / max.
- Q1 / Q3.
- Número de anomalías.

### Reglas de rendimiento
- Evitar recomputar estadísticas si no cambian las entradas.
- Memoizar transformaciones con `useMemo` o selectores puros.
- Si el dataset supera el umbral práctico, usar decimación/agregación por ventana temporal.

---

## Componentes visuales

### Panel de filtros
- select de paciente.
- select de tipo de medición.
- select de sexo.
- select de grupo de edad.
- date range picker.

### Visualización principal
- pestañas:
  1. evolución temporal;
  2. distribución;
  3. comparación entre pacientes.
- cada pestaña renderiza un gráfico ECharts independiente.

### Panel lateral
- tarjetas de métricas calculadas.
- resumen del subconjunto filtrado.
- mensajes de contexto clínico básico.

---

## Estrategia de datos y consultas

### Lectura
- usar el proxy actual del dashboard:
  - `GET /api/fhir/Patient?_count=...`
  - `GET /api/fhir/Observation?_count=...&_sort=-date`

### Minimización
- cuando el endpoint lo permita, usar `_elements` para traer solo lo necesario.
- cachear resultados en memoria de la página mientras los filtros no cambien.

### Escalado
- el objetivo funcional es 5.000 observaciones.
- para 2.000 observaciones el render debe ser fluido sin necesidad de virtualización agresiva.
- para valores mayores, preparar:
  - lazy loading de datasets;
  - agregación previa;
  - posible Web Worker si la CPU del navegador se convierte en cuello de botella.

---

## Exportación

### PNG
- exportación nativa desde ECharts (`getDataURL`).

### CSV
- exportación desde el modelo analítico filtrado.
- incluir:
  - paciente;
  - tipo;
  - fecha;
  - valor;
  - unidad;
  - sexo;
  - edad;
  - identificador de recurso FHIR.

---

## Pruebas

### Unitarias
- adaptación FHIR.
- cálculo de estadísticas.
- clasificación por edad/sexo/tipo.

### Componentes
- panel de filtros.
- tabs de visualización.
- exportación.

### Integración UI
- carga de bundles de ejemplo.
- cambios de filtros.
- exportaciones.
- estados vacíos y skeletons.

---

## Riesgos técnicos
1. Saturación del render si se pintan miles de puntos sin agregación.
2. Cálculos pesados en hilo principal del navegador.
3. Aumento de peso del bundle por ECharts y utilidades analíticas.
4. Complejidad de mantener el estado de filtros sincronizado entre URL, gráficos y panel lateral.

---

## Mitigaciones
1. Memoización de cálculos y transformaciones.
2. Agregación por ventanas temporales y reducción de densidad visual.
3. Carga diferida de la página analítica si no se usa.
4. Separar estrictamente:
   - adaptador FHIR;
   - lógica analítica;
   - componentes visuales.

---

## Impacto en la arquitectura actual
- La feature se integra en `gaiax-health-dashboard` sin romper la navegación actual.
- Reutiliza el proxy `/api/fhir` ya disponible.
- No requiere cambios de backend para un MVP funcional.
- Puede coexistir con la vista actual de pacientes sin degradar su comportamiento.

---

## Decisiones pendientes
1. Confirmar si el dataset de análisis se cargará desde la API FHIR real o desde una caché/snapshot local para demo inicial.
2. Confirmar si la exportación CSV debe incluir solo el subconjunto filtrado o también metadatos FHIR completos.

---

## Resultado esperado
Una página de análisis clínico exploratorio que permita:
- detectar tendencias;
- comparar pacientes;
- descubrir anomalías;
- trabajar con grandes volúmenes FHIR de forma visualmente clara y fluida.

