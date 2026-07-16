# Análisis Funcional — Análisis de Mediciones

**Feature:** `feature-analisis-mediciones`  
**Versión:** 1.0 (borrador MVP)  
**Fecha creación:** 2026-06-11

---

## Objetivo General
Proporcionar una página de análisis clínico exploratorio sobre observaciones FHIR, orientada a visualizar tendencias, comparar pacientes y detectar anomalías a partir de bundles con volumen medio/alto de datos.

---

## Usuarios Objetivo
1. **Personal clínico:** exploración de tendencias, outliers y comparación entre pacientes.
2. **Analistas de datos sanitarios:** inspección de distribución y comportamiento temporal.
3. **Demostradores de defensa:** visualización clara y fluida de grandes volúmenes FHIR.

---

## Alcance (MVP)

### Incluido
- [ ] **Página nueva de analítica** dentro del dashboard: `Análisis de Mediciones`.
- [ ] **Panel de filtros** por:
  - paciente.
  - tipo de medición (`Observation.code`).
  - intervalo de fechas.
  - sexo del paciente.
  - grupo de edad.
- [ ] **Transformación previa de datos FHIR** (`Bundle` y `Observation`) a un modelo optimizado para visualización.
- [ ] **Modo 1: Evolución temporal**
  - línea interactiva.
  - un paciente o agregados.
  - media, percentil 25 y percentil 75.
  - banda sombreada entre percentiles.
  - zoom y selección de rango.
- [ ] **Modo 2: Distribución**
  - histograma.
  - box plot.
  - detección de atípicos.
- [ ] **Modo 3: Comparación entre pacientes**
  - scatter plot interactivo.
  - color por sexo.
  - tamaño por edad.
  - tooltip con paciente, fecha, valor y unidad.
- [ ] **Panel lateral de estadísticas**
  - total pacientes filtrados.
  - total observaciones.
  - media, mediana, desviación estándar.
  - mínimo, máximo, percentiles.
  - conteo de anomalías por IQR.
- [ ] **UX avanzada**
  - tooltips enriquecidos.
  - leyendas interactivas.
  - exportación a PNG.
  - exportación a CSV.
  - estado de filtros en URL.
  - skeleton loaders y estados vacíos claros.
- [ ] **Soporte para al menos 5.000 observaciones** sin degradación perceptible en el uso habitual.

### Excluido
- [ ] edición de datos.
- [ ] alertas médicas automáticas.
- [ ] machine learning para diagnóstico.
- [ ] persistencia de filtros en backend.
- [ ] exportación a PDF en esta iteración.

---

## Flujos de Usuario

### Flujo 1: Análisis temporal
```
1. Usuario abre la página "Análisis de Mediciones"
2. El sistema carga observaciones FHIR disponibles
3. El usuario selecciona paciente, tipo de medición y rango temporal
4. El gráfico temporal actualiza media, percentiles y banda intercuartílica
5. El usuario ajusta zoom o rango para inspeccionar picos/anomalías
```

### Flujo 2: Comparación entre pacientes
```
1. Usuario activa el modo "Comparación"
2. El sistema agrupa observaciones por sexo y edad
3. Se renderiza un scatter plot con tooltips
4. El usuario selecciona uno o varios puntos
5. El panel lateral actualiza estadísticas y detalle
```

### Flujo 3: Distribución y outliers
```
1. Usuario activa el modo "Distribución"
2. El sistema calcula histograma, box plot e IQR
3. Se resaltan valores atípicos
4. El usuario exporta datos o imagen del gráfico
```

---

## Casos de Uso

### UC-01: Filtrar observaciones por paciente y tipo
**Actor:** Personal clínico  
**Precondición:** datos FHIR cargados  
**Flujo:**
1. Selecciona paciente.
2. Selecciona tipo de medición.
3. Define rango temporal.
4. El sistema recalcula todos los gráficos.

**Criterios de aceptación:**
- [ ] Los filtros afectan a todos los paneles de forma consistente.
- [ ] La respuesta visual es inmediata para conjuntos de tamaño medio.
- [ ] El estado de filtros queda reflejado en la URL.

### UC-02: Detectar tendencia y dispersión
**Actor:** Analista de datos sanitarios  
**Precondición:** existe al menos un subconjunto con varias observaciones  
**Flujo:**
1. Activa evolución temporal.
2. Observa media, P25, P75 y banda sombreada.
3. Revisa picos, valles y cambios bruscos.

**Criterios de aceptación:**
- [ ] La media y percentiles se recalculan correctamente.
- [ ] El gráfico soporta zoom/rango temporal.
- [ ] Las anomalías se distinguen visualmente.

### UC-03: Comparar pacientes por edad y sexo
**Actor:** Personal clínico  
**Precondición:** datos con múltiples pacientes cargados  
**Flujo:**
1. Activa scatter plot.
2. El sistema colorea por sexo y dimensiona por edad.
3. Selecciona puntos concretos para inspección.

**Criterios de aceptación:**
- [ ] El tooltip muestra paciente, fecha, valor y unidad.
- [ ] La selección de puntos actualiza el panel lateral.
- [ ] La codificación visual es consistente.

### UC-04: Exportar resultados
**Actor:** Demostrador / analista  
**Precondición:** existe un filtro aplicado  
**Flujo:**
1. El usuario exporta gráfico a PNG.
2. Exporta datos filtrados a CSV.
3. Comparte los resultados fuera de la aplicación.

**Criterios de aceptación:**
- [ ] Los ficheros exportados contienen el subconjunto filtrado.
- [ ] El gráfico exportado conserva la leyenda y el rango visible.

---

## Requisitos Funcionales
- RF-AM-01: La página debe cargar observaciones FHIR desde el dashboard.
- RF-AM-02: Debe permitir filtrar por paciente, tipo de observación, sexo, edad e intervalo de fechas.
- RF-AM-03: Debe mostrar evolución temporal agregada por medias y percentiles.
- RF-AM-04: Debe mostrar distribución con histograma y box plot.
- RF-AM-05: Debe permitir comparación visual entre pacientes.
- RF-AM-06: Debe calcular estadísticas dinámicas para el subconjunto filtrado.
- RF-AM-07: Debe soportar exportación de gráfico e información filtrada.
- RF-AM-08: Debe mostrar estados vacíos y skeleton loaders de forma clara.
- RF-AM-09: Debe mantener el estado de filtros en la URL.

---

## Criterios de Aceptación del MVP
1. La nueva página permite análisis clínico visual sin saturar la interfaz.
2. Los filtros reordenan y recalculan la visualización en tiempo real.
3. Los gráficos muestran tendencia, distribución y comparación.
4. El sistema soporta varios miles de observaciones de forma fluida.
5. El comportamiento es consistente con el diseño actual del dashboard.

---

## Riesgos Funcionales
1. Saturación visual si se muestran demasiados puntos sin agregación.
2. Respuesta lenta al recalcular estadísticas pesadas.
3. Ambigüedad si se mezclan observaciones heterogéneas en el mismo gráfico.
4. Dificultad para mantener legibilidad en pantallas pequeñas.

---

## Preguntas Funcionales Pendientes
1. Confirmar si el análisis se alimentará del bundle local de 2.000 observaciones, del bundle masivo particionado o de ambos.
2. Confirmar si la exportación CSV debe incluir metadatos FHIR completos o solo el subconjunto analítico.

---

## Impactos por feature
### feature-dashboard-pacientes
- Esta feature añade una nueva página dentro del mismo dashboard.
- Reutiliza diseño visual, navegación y datos FHIR ya existentes.
- Amplía la capa de analítica sin sustituir la vista operativa de pacientes.

