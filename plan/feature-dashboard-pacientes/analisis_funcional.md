#  Análisis Funcional — Dashboard de Pacientes

**Feature:** `feature-dashboard-pacientes`  
**Versión:** 1.0 (MVP pre-defensa)  
**Fecha creación:** 2026-04-28

---

##  Objetivo General
Proporcionar un **dashboard web interactivo** que visualice datos clínicos de pacientes consumidos del ecosistema Gaia-X, permitiendo búsqueda, análisis y trazabilidad de mediciones de salud en tiempo real.

---

##  Usuarios Objetivo
1. **Personal clínico:** Análisis de pacientes y revisión de mediciones
2. **Administradores:** Auditoría y validación de datos consumidos
3. **Demostradores de defensa:** Visualización de E2E del flujo de datos

---

##  Alcance (MVP)

### ✅ Incluido
- [x] **Buscador de pacientes** por ID, nombre o documento
- [x] **Tabla de pacientes precargados** con los 20 primeros registros del fixture local del consumer
- [x] **Detalle de paciente seleccionado** al hacer clic en una fila de la tabla
- [x] **Visualización de mediciones:** gráficos de línea (series temporales)
- [x] **Gráficos de tarta:** distribución por tipo de medición (blood-pressure, heart-rate, etc.)
- [x] **Consumo de APIs backend:**
  - `GET /api/v1/consumption-jobs/{jobId}` → datos de consumo
  - `GET /api/v1/datasets` → catálogo disponible
- [x] **Respuesta de búsqueda instantánea** (client-side filtrado)
- [x] **Trazabilidad:** mostrar `X-Request-Id` y timestamps

### ❌ Excluido (futuro)
- [ ] Exportar a PDF/Excel
- [ ] Edición de datos (solo lectura)
- [ ] Alertas automáticas
- [ ] Multi-idioma
- [ ] Autenticación avanzada (OAuth2 integrado)

---

##  Flujos de Usuario

### Flujo 1: Búsqueda y visualización de paciente
```
1. Usuario abre dashboard
2. Ingresa ID de paciente (ej: "patient-001")
3. Presiona "Buscar"
4. Sistema obtiene consumo-jobs vinculados
5. Dashboard renderiza:
   - Tabla de 20 pacientes precargados debajo del buscador
   - Tabla de mediciones (timestamp, tipo, valor)
   - Gráfico de línea: evolución temporal
   - Gráfico de tarta: proporción por tipo
6. Usuario puede hacer zoom, exportar vista (futuro)
```

### Flujo 2: Exploración de catálogo
```
1. Usuario selecciona "Ver Datasets Disponibles"
2. Dashboard lista datasets publicados
3. Puede filtrar por tipo (FHIR, etc.)
4. Selecciona dataset → ve muestra de datos
```

### Flujo 3: Exploracion rapida de pacientes precargados
```
1. Usuario abre el dashboard
2. El sistema carga una tabla con los 20 primeros pacientes del fixture local
3. Usuario hace clic en una fila
4. El dashboard muestra los datos del paciente seleccionado
5. Si introduce un ID manual, el buscador sigue resolviendo la busqueda normal
```

---

##  Casos de Uso

### UC-01: Buscar paciente por ID
**Actor:** Personal clínico  
**Precondición:** Dashboard cargado, backend activo  
**Flujo:**
1. Introduce ID: "patient-001"
2. Presiona Enter o botón Buscar
3. Sistema valida formato
4. Obtiene datos vía API
5. Renderiza gráficos

**Criterios de aceptación:**
- [ ] Campo de búsqueda acepte IDs alfanuméricos
- [ ] Error visible si paciente no existe
- [ ] Latencia < 2s en búsqueda
- [ ] Gráficos renderizen sin lag

---

### UC-02: Visualizar evolución de mediciones
**Actor:** Personal clínico  
**Precondición:** Paciente encontrado  
**Flujo:**
1. Dashboard muestra gráfico de línea con serie temporal
2. Eje X: timestamp, Eje Y: valor (presión en mmHg, frecuencia en bpm)
3. Usuario puede:
   - Pasar mouse sobre punto → tooltip con valor exacto
   - Zoom (futuro)
   - Comparar múltiples mediciones

**Criterios de aceptación:**
- [ ] Gráfico renderiza ≥10 puntos sin lag
- [ ] Tooltips mostrar timestamp + valor + tipo
- [ ] Escalas automáticas según rango de datos
- [ ] Leyenda identifique tipo de medición

---

### UC-03: Ver distribución de mediciones
**Actor:** Personal administrativo  
**Precondición:** Paciente encontrado  
**Flujo:**
1. Gráfico de tarta muestra % de cada tipo de medición
2. Ejemplo: 60% blood-pressure, 40% heart-rate
3. Al hacer clic en segmento → filtra gráfico de línea

**Criterios de aceptación:**
- [ ] Tarta renderiza correctamente con colores diferenciados
- [ ] Etiquetas claras con % y recuento
- [ ] Interactividad: clic en segmento filtra datos
- [ ] Suma total = 100%

---

### UC-04: Seleccionar paciente desde la tabla precargada
**Actor:** Personal clinico
**Precondicion:** Dashboard cargado con la tabla visible
**Flujo:**
1. Usuario ve la tabla con los 20 primeros pacientes precargados
2. Hace clic en una fila concreta
3. Dashboard carga el detalle local asociado a ese paciente
4. Se actualizan la tabla de mediciones y los graficos con ese contexto

**Criterios de aceptacion:**
- [ ] La tabla aparece automaticamente debajo del buscador
- [ ] Cada fila abre el detalle del paciente sin recargar la pagina
- [ ] El paciente seleccionado queda claramente resaltado
- [ ] Los datos proceden de los fixtures locales del consumer

---

##  Pantallas & Wireframes

### Pantalla principal (mockup textual)
```
┌─────────────────────────────────────────────────┐
│  Dashboard Pacientes — Gaia-X Salud           │
├─────────────────────────────────────────────────┤
│  Buscar paciente: [patient-001_____] [Buscar]   │
│  Status: ✅ Backend conectado |  Last sync: 2m │
├─────────────────────────────────────────────────┤
│                                                 │
│  PACIENTE: patient-001  (DOB: 1980-05-15)      │
│  ┌─────────────────────┐  ┌─────────────────┐  │
│  │  Gráfico de Línea   │  │  Gráfico Tarta  │  │
│  │  (Serie temporal)   │  │ (Distribución)  |  │
│  │                     │  │                 │  │
│  │  [▲ ▲ ▲ ▲ ▼]      │  │   ◐ 60%        │  │
│  │  BPM/mmHg vs time   │  │   ◑ 40%        │  │
│  └─────────────────────┘  └─────────────────┘  │
│                                                 │
│  Últimas mediciones:                           │
│  ┌─────────────────────────────────────────┐  │
│  │ Timestamp | Tipo | Valor | X-Request-Id│  │
│  │ 14:32:10 | BP | 120/80 | req-abc123...│  │
│  │ 14:30:05 | HR | 72 bpm | req-def456...│  │
│  └─────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

---

##  Especificación de Datos

### Entrada (desde APIs backend)
```json
{
  "jobId": "job-12345",
  "patientId": "patient-001",
  "measurements": [
    {
      "timestamp": "2026-04-28T14:32:10Z",
      "type": "blood-pressure",
      "value": { "systolic": 120, "diastolic": 80 },
      "unit": "mmHg"
    },
    {
      "timestamp": "2026-04-28T14:30:05Z",
      "type": "heart-rate",
      "value": 72,
      "unit": "bpm"
    }
  ],
  "metadata": {
    "xRequestId": "req-xyz789",
    "consumedAt": "2026-04-28T14:35:00Z"
  }
}
```

### Salida HTML/Componentes
- **SearchBar:** input + botón buscar
- **PreloadedPatientsTable:** tabla con los 20 primeros pacientes y accion de seleccion
- **MetricsChart:** Recharts LineChart con eje temporal
- **DistributionPie:** Recharts PieChart
- **MeasurementsTable:** tabla de datos crudos
- **StatusIndicator:** indicador de conexión backend

---

## ⚙️ Criterios de Validación (Definition of Done)

1. **Funcionalidad:**
   - [ ] Buscador devuelve resultados en <2s
   - [ ] Tabla precargada visible al cargar la pagina
   - [ ] Seleccion de fila actualiza el detalle del paciente
   - [ ] Gráficos renderizen sin console errors
   - [ ] Simulación de pacientes múltiples funciona

2. **UI/UX:**
   - [ ] Responsive en desktop, tablet, mobile
   - [ ] Paleta de colores profesional (healthcare)
   - [ ] Fuentes legibles (accesibilidad WCAG AA mín.)

3. **Rendimiento:**
   - [ ] Carga inicial <3s (First Contentful Paint)
   - [ ] Búsqueda interactiva sin lag
   - [ ] Manejo de 100+ mediciones sin freeze

4. **Integración:**
   - [ ] APIs backend consumidas correctamente
   - [ ] Errores de backend manejados (fallbacks)
   - [ ] X-Request-Id mostrado en UI para trazabilidad

5. **Testing:**
   - [ ] Tests unitarios para componentes (Jest/Vitest)
   - [ ] Tests E2E básicos (Cypress/Playwright)
   - [ ] Cobertura mínima 70%

---

##  Dependencias Funcionales

- **Feature:** Requiere backend `gaiax-health-consumer-node` en ejecución
- **APIs:** `/api/v1/consumption-jobs/{id}`, `/api/v1/datasets`
- **Datos:** Consumos con mediciones FHIR (blood-pressure, heart-rate)

---

##  Próxima Fase
→ **Fase 2: Análisis Técnico** — Stack, arquitectura, decisiones tecnológicas
