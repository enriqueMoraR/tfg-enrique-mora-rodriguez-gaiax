#  DEVELOPMENT.md — Dashboard Pacientes Gaia-X

**Proyecto:** Dashboard de Pacientes — Feature `feature-dashboard-pacientes`  
**Versión:** 1.0 MVP Pre-Defensa  
**Fecha:** 2026-04-30

---

##  Tabla de Contenidos

- [ Inicio Rápido](#-inicio-rápido)
- [️ Arquitectura del Proyecto](#️-arquitectura-del-proyecto)
- [ Configuración de Desarrollo](#-configuración-de-desarrollo)
- [ APIs y Mocking](#-apis-y-mocking)
- [ Testing](#-testing)
- [ Build y Deployment](#-build-y-deployment)
- [ Troubleshooting](#-troubleshooting)
- [ Referencias](#-referencias)

---

##  Inicio Rápido

### Prerrequisitos
- **Node.js**: 18+ (recomendado: 20.x)
- **npm**: 8+ (viene con Node.js)
- **Backend Gaia-X**: Opcional (puerto 8083)

### Instalación
```bash
# Clonar el proyecto (si aplica)
cd /path/to/tfg-enrique-mora-gaia-x/gaiax-health-dashboard

# Instalar dependencias
npm install --legacy-peer-deps

# Verificar instalación
npm run type-check
```

### Desarrollo Local
```bash
# Iniciar servidor de desarrollo
npm run dev

# Abrir en navegador: http://localhost:5173
```

### Con Backend Real
```bash
# Asegurar que backend esté corriendo en puerto 8083
curl -fsS http://localhost:8083/actuator/health

# El dashboard automáticamente conectará vía proxy Vite
```

---

## ️ Arquitectura del Proyecto

```
gaiax-health-dashboard/
├── public/
│   └── index.html                 # HTML base + meta tags
├── src/
│   ├── main.tsx                   # Entry point React 18
│   ├── App.tsx                    # Root component + QueryClient
│   ├── index.css                  # Tailwind CSS + custom styles
│   │
│   ├── components/                # UI Components
│   │   ├── SearchBar.tsx          # Búsqueda de pacientes
│   │   ├── MetricsLineChart.tsx    # Gráfico temporal (Recharts)
│   │   ├── DistributionPie.tsx    # Gráfico distribución (Recharts)
│   │   ├── MeasurementsTable.tsx  # Tabla de mediciones
│   │   ├── StatusIndicator.tsx    # Estado backend
│   │   └── ErrorBoundary.tsx      # Error handling
│   │
│   ├── hooks/                     # Custom React Hooks
│   │   ├── usePatientData.ts      # Carga datos paciente
│   │   ├── useMeasurements.ts     # Transformación FHIR
│   │   └── useBackendStatus.ts    # Health check backend
│   │
│   ├── services/                  # API Services
│   │   ├── api.ts                 # Axios client + interceptores
│   │   ├── consumerService.ts     # APIs consumer-node
│   │   └── dataTransform.ts       # FHIR → UI transformers
│   │
│   ├── types/                     # TypeScript Definitions
│   │   ├── index.ts               # Re-exports
│   │   ├── fhir.ts                # FHIR types (Observation)
│   │   ├── api.ts                 # API response types
│   │   └── domain.ts              # Domain types (Patient, Measurement)
│   │
│   ├── pages/                     # Page Components
│   │   └── Dashboard.tsx          # Página principal
│   │
│   ├── utils/                     # Utilities (vacío por ahora)
│   └── tests/                     # Test Files
│       ├── components/            # Component tests
│       ├── hooks/                 # Hook tests
│       └── services/              # Service tests
│
├── package.json                   # Dependencies + scripts
├── vite.config.ts                 # Vite config + proxy
├── tsconfig.json                  # TypeScript strict mode
├── vitest.config.ts               # Testing config
├── tailwind.config.ts             # Tailwind + clinical theme
└── .env.example                   # Environment variables
```

### Stack Tecnológico
- **Frontend**: React 18 + TypeScript + Vite
- **Styling**: Tailwind CSS + custom clinical theme
- **Charts**: Recharts (React-based, lightweight)
- **State**: TanStack Query (caching + API state)
- **HTTP**: Axios (interceptors + retry logic)
- **Testing**: Vitest + React Testing Library
- **Build**: Vite (fast HMR + optimized production)

---

##  Configuración de Desarrollo

### Variables de Entorno

Crear archivo `.env` en la raíz del proyecto:

```bash
# API Backend URL (default: proxy Vite)
VITE_API_URL=http://localhost:8083

# API Timeout (default: 10000ms)
VITE_API_TIMEOUT=10000

# FHIR API URL through the dashboard proxy
VITE_FHIR_API_URL=/api/fhir

# FHIR API Timeout (default: 10000ms)
VITE_FHIR_API_TIMEOUT=10000
```

### Scripts Disponibles

```bash
# Desarrollo
npm run dev              # Servidor HMR en http://localhost:5173
npm run build            # Build producción (dist/)
npm run preview          # Preview build local

# Calidad de Código
npm run type-check       # TypeScript validation
npm run lint             # ESLint (React + hooks)
npm run format           # Prettier auto-format

# Testing
npm run test             # Vitest unit tests
npm run test:coverage    # Tests + coverage report
```

### IDE Setup Recomendado

**VS Code Extensions:**
- TypeScript Importer
- Tailwind CSS IntelliSense
- ESLint
- Prettier

**Configuración VS Code:**
```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "typescript.preferences.importModuleSpecifier": "relative"
}
```

---

##  APIs y Mocking

### APIs Backend

El dashboard consume APIs del `consumer-node` (puerto 8083):

#### 1. Buscar Jobs de Consumo
```
GET /consumption-jobs?patientId={patientId}
```
- **Response**: Lista de jobs consumidos por paciente
- **Mock**: Retorna datos demo si backend no disponible

#### 2. Detalle de Job
```
GET /consumption-jobs/{jobId}
```
- **Response**: Detalle job + mediciones FHIR
- **Mock**: Datos FHIR simulados

#### 3. Lista de Datasets
```
GET /datasets
```
- **Response**: Datasets disponibles para consumo
- **Mock**: Lista estática de datasets

#### 4. Health Check
```
GET /health
```
- **Response**: Estado del backend
- **Mock**: Siempre retorna 200 OK

### Mocking Automático

El proyecto incluye mocking automático cuando el backend no está disponible:

```typescript
// En consumerService.ts
export async function searchPatients(query: string): Promise<Patient[]> {
  // Mock implementation para desarrollo
  const mockPatients = [
    { id: 'patient-001', name: 'Juan Pérez' },
    { id: 'patient-002', name: 'María García' },
    { id: 'patient-003', name: 'Carlos López' },
  ]

  return mockPatients.filter(p =>
    p.id.toLowerCase().includes(query.toLowerCase()) ||
    p.name.toLowerCase().includes(query.toLowerCase())
  )
}
```

### Axios Interceptors

Configurados automáticamente en `/src/services/api.ts`:

- **Request Interceptor**: Añade `X-Request-Id` único
- **Response Interceptor**: Retry automático en errores 500+ (3 intentos, backoff exponencial)

### Desarrollo sin Backend

```bash
# Solo dashboard - usa mocks automáticamente
npm run dev

# Verificar que usa mocks
# Buscar "patient-001" → debería mostrar datos mock
```

---

##  Testing

### Estructura de Tests

```
src/tests/
├── components/
│   ├── SearchBar.test.tsx
│   ├── MetricsLineChart.test.tsx
│   ├── DistributionPie.test.tsx
│   ├── MeasurementsTable.test.tsx
│   ├── StatusIndicator.test.tsx
│   └── ErrorBoundary.test.tsx
├── fixtures/
│   ├── bundle-sample.json
│   └── observation-sample.json
├── hooks/
│   ├── usePatientData.test.ts
│   └── useMeasurements.test.ts
└── services/
    ├── consumerService.test.ts
    └── dataTransform.test.ts
```

### Ejecutar Tests

```bash
# Todos los tests
npm run test

# Con coverage
npm run test:coverage

# Tests específicos
npm run test SearchBar
npm run test usePatientData
```

### Mocks en Tests

```typescript
// Ejemplo: Mock de axios en consumerService.test.ts
vi.mock('axios')
const mockedAxios = vi.mocked(axios)

mockedAxios.get.mockResolvedValueOnce({
  data: [{ id: 'job-1', patientId: 'patient-001' }]
})
```

### Coverage Esperado
- **Statements**: ≥70%
- **Branches**: ≥60%
- **Functions**: ≥80%
- **Lines**: ≥70%

---

##  Build y Deployment

### Build de Producción

```bash
# Generar build optimizado
npm run build

# Resultado en /dist
# - index.html
# - assets/ (JS, CSS minificados)
# - Tamaño: ~187 KB gzipped
```

### Deployment Opciones

#### Opción 1: Nginx Simple
```nginx
server {
  listen 8080;
  root /var/www/dashboard/dist;
  index index.html;

  location / {
    try_files $uri $uri/ /index.html;
  }
}
```

#### Opción 2: Docker
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

#### Opción 3: Apache
```apache
<VirtualHost *:8080>
  DocumentRoot /var/www/dashboard/dist
  <Directory /var/www/dashboard/dist>
    Require all granted
    RewriteEngine on
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.html [L]
  </Directory>
</VirtualHost>
```

### Variables de Producción

```bash
# En producción, configurar:
VITE_API_URL=https://api.gaia-x-health.com
VITE_API_TIMEOUT=15000
VITE_FHIR_API_URL=/api/fhir
VITE_FHIR_API_TIMEOUT=15000
```

---

##  Troubleshooting

### Problemas Comunes

#### 1. "Cannot resolve dependency"
```bash
# Limpiar node_modules y reinstalar
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps
```

#### 2. "TypeScript errors"
```bash
# Verificar tipos
npm run type-check

# Si persiste, reinstalar tipos
npm install --save-dev @types/react @types/react-dom
```

#### 3. "Vite dev server no inicia"
```bash
# Verificar puerto 5173 libre
lsof -i :5173

# Cambiar puerto si necesario
npm run dev -- --port 3000
```

#### 4. "Charts no renderizan"
```bash
# Verificar Recharts import
import { LineChart, PieChart } from 'recharts'

# Verificar datos en formato correcto
console.log('Chart data:', data)
```

#### 5. "API calls fallan"
```bash
# Verificar backend corriendo
curl http://localhost:8083/actuator/health

# Verificar proxy Vite en vite.config.ts
server: {
  proxy: {
    '/api': 'http://localhost:8083'
  }
}
```

#### 6. "Tests fallan"
```bash
# Limpiar cache Vitest
npm run test -- --clearCache

# Verificar mocks
console.log('Mocked axios:', vi.mocked(axios))
```

### Logs Útiles

```bash
# Ver logs del build
npm run build 2>&1 | tee build.log

# Ver logs de tests
npm run test -- --reporter=verbose

# Ver logs de desarrollo
npm run dev -- --logLevel info
```

### Performance Issues

- **Build lento**: Usar `npm ci` en lugar de `npm install`
- **Tests lentos**: Paralelizar con `npm run test -- --threads 4`
- **Bundle grande**: Verificar imports no utilizados con `npm run build -- --analyze`

---

##  Referencias

### Documentación Técnica
- [analisis_funcional.md](../plan/analisis_funcional.md)
- [analisis_tecnico.md](../plan/analisis_tecnico.md)
- [tareas.md](../plan/feature-dashboard-pacientes/tareas.md)

### APIs Backend
- [contratos_api.md](../plan/contratos_api.md)
- [evidencias_t9.md](../plan/evidencias_t9.md)

### Stack Tecnológico
- [React 18](https://react.dev/)
- [TypeScript](https://www.typescriptlang.org/)
- [Vite](https://vitejs.dev/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Recharts](https://recharts.org/)
- [TanStack Query](https://tanstack.com/query/)
- [Vitest](https://vitest.dev/)

### Gaia-X Context
- [README.md](../README.md)
- [HELP.md](../HELP.md)
- [Whitepaper Gaia-X](../documentacion/WhitepaperGaiaX.pdf)

---

##  Contribución

### Commits
```bash
# Formato recomendado
git commit -m "feat: add patient search functionality"
git commit -m "fix: resolve chart rendering issue"
git commit -m "docs: update DEVELOPMENT.md"
```

### Pull Requests
- Crear branch desde `main`
- Tests pasan: `npm run test`
- Lint pasa: `npm run lint`
- Build funciona: `npm run build`
- Documentación actualizada

---

** Soporte:** Para issues específicos, revisar logs en consola del navegador (F12) y verificar configuración de backend.
