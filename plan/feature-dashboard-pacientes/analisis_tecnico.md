#  Análisis Técnico — Dashboard de Pacientes

**Feature:** `feature-dashboard-pacientes`  
**Versión:** 1.0 (MVP pre-defensa)  
**Fecha creación:** 2026-04-28

---

##  Stack Tecnológico (MVP)

| Capa | Componente | Justificación |
|------|-----------|---------------|
| **Frontend** | React 18 + TypeScript | Tipado fuerte, ecosystem maduro, componentes reutilizables |
| **Bundler** | Vite | Build rápido, hot reload, optimizado para SPA |
| **Gráficas** | Recharts | Basado en React, bajo overhead, FHIR-friendly |
| **Estilos** | Tailwind CSS | Utility-first, responsive by default, healthcare-friendly |
| **Estado** | TanStack Query (React Query) | Cache de APIs, sincronización backend automática |
| **Testing** | Vitest + React Testing Library | Rápido, compatible con Vite, cobertura clara |
| **HTTP Client** | Axios | Interceptores fáciles, timeout, retry nativo |
| **Componentes UI** | Shadcn/ui (Tailwind + Radix) | Accesibilidad WCAG AA, healthcare-ready |

---

## ️ Arquitectura Frontend

```
gaiax-health-dashboard/
├── public/
│   └── index.html
├── src/
│   ├── main.tsx                          # Entry point Vite
│   ├── App.tsx                           # Componente raíz
│   ├── index.css                         # Tailwind
│   │
│   ├── components/
│   │   ├── SearchBar.tsx                 # Buscador paciente
│   │   ├── PreloadedPatientsTable.tsx    # Tabla de 20 pacientes precargados
│   │   ├── MetricsLineChart.tsx          # Gráfico de línea (Recharts)
│   │   ├── DistributionPie.tsx           # Gráfico tarta (Recharts)
│   │   ├── MeasurementsTable.tsx         # Tabla de datos crudos
│   │   ├── StatusIndicator.tsx           # Indicador conexión backend
│   │   └── ErrorBoundary.tsx             # Manejo de errores
│   │
│   ├── hooks/
│   │   ├── usePatientData.ts             # Hook para consumo de APIs
│   │   ├── useMeasurements.ts            # Hook para transformar datos
│   │   └── useBackendStatus.ts           # Hook verificar conectividad
│   │
│   ├── services/
│   │   ├── api.ts                        # Cliente Axios + interceptores
│   │   ├── consumerService.ts            # Endpoints consumer-node
│   │   └── dataTransform.ts              # Transformar JSON → gráficos
│   │
│   ├── data/
│   │   └── preloadedPatients.ts          # Snapshot local de 20 pacientes
│   │
│   ├── types/
│   │   ├── fhir.ts                       # Tipos FHIR (blood-pressure, heart-rate)
│   │   ├── api.ts                        # Respuestas API
│   │   └── domain.ts                     # Tipos de dominio (Patient, Measurement)
│   │
│   ├── pages/
│   │   ├── Dashboard.tsx                 # Página principal
│   │   └── CatalogPage.tsx               # Explorador de datasets (futuro)
│   │
│   ├── utils/
│   │   ├── formatters.ts                 # Formateo (timestamps, valores)
│   │   ├── validators.ts                 # Validación de IDs de paciente
│   │   └── constants.ts                  # Config backend URLs, timeouts
│   │
│   └── tests/
│       ├── components/                   # Tests de componentes
│       ├── hooks/                        # Tests de custom hooks
│       ├── services/                     # Tests de APIs
│       └── integration/                  # Tests E2E lógica
│
├── vite.config.ts
├── tsconfig.json
├── tailwind.config.ts
├── vitest.config.ts
├── scripts/
│   └── generate-preloaded-patients.mjs   # Generador del snapshot local
├── package.json
└── .env.example
```

---

##  Integración con APIs Backend

### Consumer Node Backend
**Base URL:** `http://localhost:8083`

#### Endpoint 1: Obtener consumo por job ID
```
GET /api/v1/consumption-jobs/{jobId}

Response:
{
  "id": "job-12345",
  "patientId": "patient-001",
  "datasetId": "dataset-bp-001",
  "status": "SUCCEEDED",
  "consumedAt": "2026-04-28T14:35:00Z",
  "measurements": [
    {
      "timestamp": "2026-04-28T14:32:10Z",
      "resourceType": "Observation",
      "code": {"coding": [{"code": "55284-4", "system": "http://loinc.org"}]},
      "valueQuantity": {"value": 120, "unit": "mmHg"},
      "subject": {"reference": "Patient/patient-001"}
    }
  ],
  "metadata": {
    "xRequestId": "req-xyz789"
  }
}
```

#### Endpoint 2: Listar datasets disponibles
```
GET /api/v1/datasets

Response:
{
  "items": [
    {
      "datasetId": "dataset-bp-001",
      "name": "Blood Pressure Readings",
      "resourceType": "Observation",
      "recordCount": 1500
    }
  ]
}
```

### Datos precargados locales
- Fuente: `gaiax-health-consumer-node/src/test/resources/fhir/tensiometro-bundles-10000.json`
- Proceso: `gaiax-health-dashboard/scripts/generate-preloaded-patients.mjs` extrae los 20 primeros bundles y genera `gaiax-health-dashboard/src/data/preloadedPatients.ts`
- Uso UI: `PreloadedPatientsTable` renderiza esos 20 pacientes debajo del buscador y el clic en una fila hidrata el detalle sin depender de una llamada inicial al backend
- Fallback: la busqueda manual sigue usando `searchPatients(query)` para localizar pacientes adicionales por ID o texto parcial

### Contrato de Cliente (Axios interceptor)
```typescript
// Interceptor automático de X-Request-Id
api.interceptors.request.use((config) => {
  config.headers['X-Request-Id'] = generateUUID()
  return config
})

// Retry automático en 500+ con backoff exponencial
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status >= 500 && retryCount < 3) {
      return retry(error.config, retryCount + 1)
    }
    return Promise.reject(error)
  }
)
```

---

##  Decisiones Técnicas (ADRs)

### ADR-1: React + Vite vs Next.js
**Contexto:** MVP pre-defensa, requiere demo rápida.  
**Decisión:** React + Vite  
**Justificación:**
- Vite build: <1s vs Next: ~3-5s
- Menor complejidad de configuración
- SSR no necesario (MVP static)
- Fácil de deployer en Apache/Nginx simple

**Trade-off:** Sin SSR, sin API routes integradas (pero no las necesitamos).

---

### ADR-2: Recharts vs D3.js vs ECharts
**Contexto:** Necesitamos gráficos de línea y tarta, bajo overhead.  
**Decisión:** Recharts  
**Justificación:**
- Componentes React nativos
- Bajo bundle size (~60KB gzipped)
- Responsive by default
- API declarativa, fácil de testear
- Healthcare-friendly (muchos dashboards médicos lo usan)

**Trade-off:** Menos customización que D3, pero suficiente para MVP.

---

### ADR-3: TanStack Query vs Redux para estado
**Contexto:** Sincronizar datos de APIs backend, caching.  
**Decisión:** TanStack Query  
**Justificación:**
- Caché automática + invalidación
- Manejo de loading/error states built-in
- Retry automático
- DevTools excelentes para debugging
- Menor boilerplate que Redux

**Trade-off:** No para estado local complejo (pero dashboard es simple).

---

### ADR-4: Tailwind CSS vs Material UI
**Contexto:** Estilos responsive para dashboard clínico.  
**Decisión:** Tailwind + Shadcn/ui  
**Justificación:**
- Utility-first = muy rápido prototipar
- Shadcn prebuilt con Radix (accesibilidad WCAG AA)
- Healthcare-friendly color palettes
- No extra bloat de componentes innecesarios

---

### ADR-5: Vitest vs Jest
**Contexto:** Testing rápido, integración con Vite.  
**Decisión:** Vitest  
**Justificación:**
- Compatible con Vite (misma config)
- 10x más rápido que Jest
- API casi idéntica a Jest (fácil migración)
- ESM nativo

### ADR-6: Snapshot local de pacientes precargados
**Contexto:** La demo necesita contenido visible inmediatamente al abrir el dashboard, incluso sin esperar una llamada inicial al backend.  
**Decisión:** Generar un snapshot local de 20 pacientes a partir de los fixtures del consumer y servirlo desde `gaiax-health-dashboard/src/data/preloadedPatients.ts`.  
**Justificación:**
- Reduce el tiempo hasta la primera visualizacion util.
- Evita depender de una carga inicial remota para enseñar el buscador.
- Mantiene la fuente de verdad en los fixtures FHIR del consumer.

**Trade-off:** El snapshot debe regenerarse si cambian los fixtures de origen.

---

##  Dependencias (package.json)

```json
{
  "name": "gaiax-dashboard",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "test": "vitest",
    "test:coverage": "vitest --coverage",
    "lint": "eslint src --ext ts,tsx",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "axios": "^1.7.7",
    "@tanstack/react-query": "^5.50.0",
    "recharts": "^2.12.7",
    "@radix-ui/react-dialog": "^1.1.2",
    "@radix-ui/react-slot": "^2.1.0",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.1.1",
    "tailwind-merge": "^2.4.0",
    "lucide-react": "^0.408.0"
  },
  "devDependencies": {
    "@types/react": "^18.3.3",
    "@types/react-dom": "^18.3.0",
    "@vitejs/plugin-react": "^4.3.1",
    "typescript": "^5.4.5",
    "vite": "^5.2.11",
    "vitest": "^1.6.0",
    "@vitest/ui": "^1.6.0",
    "@testing-library/react": "^15.0.7",
    "@testing-library/jest-dom": "^6.4.6",
    "eslint": "^9.7.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "tailwindcss": "^3.4.4",
    "postcss": "^8.4.40",
    "autoprefixer": "^10.4.19"
  }
}
```

---

##  Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                          DASHBOARD UI                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  SearchBar (input: "patient-001")                                │
│        ↓                                                          │
│  usePatientData() hook                                           │
│        ↓                                                          │
│  TanStack Query (caching)                                        │
│        ↓                                                          │
│  consumerService.getConsumptionJobs(patientId)                   │
│        ↓                                                          │
│  axios interceptor (X-Request-Id, retry, backoff)                │
│        ↓                                                          │
│  Backend: GET /api/v1/consumption-jobs?patientId=...            │
│        ↓                                                          │
│  Response JSON (measurements array)                              │
│        ↓                                                          │
│  dataTransform.normalizeMeasurements()                           │
│        ↓                                                          │
│  State update (React)                                            │
│        ↓                                                          │
│  Re-render componentes:                                          │
│  ├─ MetricsLineChart (Recharts)                                  │
│  ├─ DistributionPie (Recharts)                                   │
│  └─ MeasurementsTable                                            │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

##  Estructura de Deployment

### Desarrollo local
```bash
npm install
npm run dev
# → http://localhost:5173
```

### Build para producción
```bash
npm run build
# → dist/ (optimizado, minificado)
```

### Deployment
**Opción A (Recomendado para MVP):** Apache/Nginx simple
```nginx
server {
  listen 8080;
  root /var/www/gaiax-dashboard/dist;
  location / {
    try_files $uri $uri/ /index.html;
  }
}
```

**Opción B (Docker):** Incluir en docker-compose.yaml
```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json .
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
```

**Opción C (Deployment centralizado):** usar `gaiax-health-deployment/docker-compose.yml`, que inyecta `VITE_API_URL=http://consumer:8083/api/v1` y construye el dashboard con su `Dockerfile` propio.

---

##  Seguridad & Observabilidad

### Seguridad MVP
- [~] CORS: Configurar para backend (localhost:8083)
- [ ] CSP headers: Aplicar restricciones básicas
- [ ] HTTPS: Recomendado en producción (por ahora HTTP local)
- [~] Sanitización: React escapa XSS por defecto
- [ ] FHIR validation: Validar esquema de entrada (futuro)

### Observabilidad
- [x] Logs en consola (dev)
- [ ] Error boundary: Capturar crashes
- [ ] Request logging: X-Request-Id visible en Network tab
- [ ] Performance metrics: Medir renderizado de gráficos
- [ ] Analytics (futuro): Qué pacientes se buscan, qué gráficos más usados

---

## ✅ Criterios de Aceptación Técnica

1. **Setup:**
   - [ ] `npm install` completa sin errores
   - [ ] `npm run dev` inicia servidor en <5s
   - [ ] TypeScript compila sin errores

2. **API Integration:**
   - [ ] Llamadas a `/api/v1/consumption-jobs` funcionan
   - [ ] Retry automático en fallos 500+
   - [ ] X-Request-Id presente en headers

3. **Gráficos:**
   - [ ] LineChart renderiza con datos reales
   - [ ] PieChart suma = 100%
   - [ ] Tooltips interactivos
   - [ ] Performance: <100ms re-render

4. **Testing:**
   - [ ] Tests unitarios de componentes: 70%+ cobertura
   - [ ] Tests de hooks (usePatientData)
   - [ ] Tests de transformación de datos
   - [ ] `npm run test:coverage` reporta cobertura

5. **Build & Deploy:**
   - [ ] `npm run build` genera bundle <500KB gzipped
   - [ ] Artifacts en `dist/` listos para deploy
   - [ ] Docker build exitoso (si aplica)

---

##  Dependencias Técnicas

**Externas:**
- Backend consumer-node activo (http://localhost:8083)
- Node.js 18+ local para desarrollo

**Internas (proyecto raíz):**
- Compartir tipos FHIR desde `/src/main/java/com/example/.../domain/fhir/`
- Documentación de contratos desde `/plan/contratos_api.md`

---

##  Próxima Fase
→ **Fase 3: Tareas** — Plan de implementación con tareas granulares
