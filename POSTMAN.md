# POSTMAN

Guía rápida de llamadas para validar el flujo E2E Gaia-X Health:

`Postgres -> provider -> trust -> consumer -> dashboard`

La documentación se alinea con `gaiax-health-deployment/docs/api-contracts.md` en dos niveles:

- `api/v1` para los contratos de negocio y gobernanza.
- `api/fhir` para la fachada FHIR que recibe `Bundle`, `Observation` y expone `Patient` y `Observation`.

## Variables

- La colección no incluye variables internas; depende solo del environment importado.
- Environment importable: `documentacion/postman/gaiax-health-local.postman_environment.json`
- Bundle mínimo reutilizable para pruebas rápidas: `documentacion/postman/fhirBundle.sample.json`
- Bundle masivo completo para carga realista: `documentacion/postman/multipleFhirBundle.sample.json`
- Bundles particionados para evitar `413` y acelerar la carga por lotes: `documentacion/postman/multipleFhirBundle.part-01.json` ... `part-08.json`
- Variables esperadas en el environment:
  - `baseUrl`
  - `requestId`
  - `providerHealthUrl`
  - `trustHealthUrl`
  - `consumerHealthUrl`
  - `dashboardUrl`

## Endpoints

| Método | Endpoint | Propósito |
| --- | --- | --- |
| `POST` | `/api/v1/datasets/fhir` | Contrato de negocio del provider. Recibe dataset envelope con `metadata` y `payload` |
| `GET` | `/api/v1/datasets` | Listado de datasets persistidos |
| `GET` | `/api/v1/datasets/{id}/raw` | Recupera el payload FHIR crudo asociado a un dataset concreto |
| `POST` | `/Bundle?x-request-id={{requestId}}` | Fachada FHIR del provider. Para smoke test usa `fhirBundle.sample.json`; para carga real usa `multipleFhirBundle.*.json` |
| `GET` | `/Patient?_count=20` | Recuperación de pacientes persistidos |
| `GET` | `/Observation?_count=20&_sort=-date` | Recuperación de observaciones persistidas |
| `POST` | `/api/v1/access-requests` | Alta de una solicitud de acceso en trust |
| `GET` | `/api/v1/access-requests/{id}` | Consulta de estado de una solicitud de acceso |
| `POST` | `/api/v1/policies/validate` | Validación de una política de acceso |
| `POST` | `/api/v1/consumption-jobs` | Alta de un trabajo de consumo autorizado |
| `GET` | `/api/v1/consumption-jobs` | Listado de trabajos de consumo |
| `GET` | `/api/v1/consumption-jobs/{id}` | Consulta de estado de un trabajo de consumo |
| `GET` | `/api/v1/proveedores` | Recuperación de profesionales médicos y centros de salud (hospitales) |
| `POST` | `/api/v1/historial/init` | Inicializa el historial clínico de un paciente con datos completos |
| `GET` | `/api/v1/historial/paciente/{pacienteId}` | Recuperación del historial clínico (diagnósticos y tratamientos) de un paciente |
| `POST` | `/api/v1/historial/{historialId}/diagnosticos` | Añadir un diagnóstico a un historial clínico |
| `POST` | `/api/v1/historial/{historialId}/tratamientos` | Añadir un tratamiento a un historial clínico |
| `GET` | `/api/health/provider`, `/api/health/trust`, `/api/health/consumer` | Verificación de salud de los servicios vía proxy del dashboard |
| `GET` | `http://localhost:3000/` | Comprobación básica del dashboard |

## Cabeceras

- `Content-Type: application/fhir+json` (para `/api/fhir/*`) o `application/json` (para `/api/v1/*`)
- `Accept: application/fhir+json` (para `/api/fhir/*`) o `application/json` (para `/api/v1/*`)
- `X-Request-Id: <id-opcional>` para trazabilidad de la petición

## 1. Ingesta FHIR

**Endpoint**

`POST {{baseUrl}}/Bundle?x-request-id={{requestId}}`

**Cabeceras**

- `Content-Type: application/fhir+json`
- `Accept: application/fhir+json`
- `X-Request-Id: {{requestId}}` opcional, la colección también lo pasa por query param

**Body**

- Tipo: `raw`
- Formato: `JSON`
- Contenido: `Bundle` FHIR con recursos `Patient`, `Device` y `Observation`

**Escenarios de uso**

La colección importable en `documentacion/postman/gaiax-health-e2e.postman_collection.json` sirve como smoke test del flujo E2E. Debe ejecutarse con el environment `Gaia-X Health Local` y usa el dashboard como proxy FHIR.

Si prefieres un `Bundle` estático pequeño, usa `documentacion/postman/fhirBundle.sample.json`.

Si necesitas una carga realista completa, usa `documentacion/postman/multipleFhirBundle.sample.json`. Ese fichero supera el límite habitual de Nginx y puede devolver `413 Request Entity Too Large`.

Para cargar el volumen completo sin superar el proxy, usa los ficheros particionados `multipleFhirBundle.part-01.json` a `multipleFhirBundle.part-08.json`. Cada uno contiene 25 pacientes, 25 dispositivos y 250 observaciones.

Orden recomendado de carga masiva:
1. `multipleFhirBundle.part-01.json`
2. `multipleFhirBundle.part-02.json`
3. `multipleFhirBundle.part-03.json`
4. `multipleFhirBundle.part-04.json`
5. `multipleFhirBundle.part-05.json`
6. `multipleFhirBundle.part-06.json`
7. `multipleFhirBundle.part-07.json`
8. `multipleFhirBundle.part-08.json`

**cURL completo**

```bash
curl -X POST 'http://localhost:3000/api/fhir/Bundle?x-request-id=req-postman-e2e-001' \
  -H 'Content-Type: application/fhir+json' \
  -H 'Accept: application/fhir+json' \
  -H 'X-Request-Id: req-postman-e2e-001' \
  --data-binary '@documentacion/postman/fhirBundle.sample.json'
```

**cURL para carga masiva realista**

```bash
curl -X POST 'http://localhost:3000/api/fhir/Bundle?x-request-id=req-postman-load-001' \
  -H 'Content-Type: application/fhir+json' \
  -H 'Accept: application/fhir+json' \
  -H 'X-Request-Id: req-postman-load-001' \
  --data-binary '@documentacion/postman/multipleFhirBundle.part-01.json'
```

## 2. Contrato de negocio del provider (Escritura)

**Endpoint**

`POST http://localhost:8081/api/v1/datasets/fhir`

**Propósito**

Publica un dataset con envoltorio de negocio (`datasetId`, `datasetType`, `clinicalCase`, `payload`, `metadata`) y deja el recurso listo para trazabilidad y auditoría.

**Nota**

Este endpoint no consume `Bundle` crudo de la misma forma que FHIR. Si el objetivo es enviar bundles FHIR desde Postman, usa la fachada `/api/fhir/Bundle` documentada arriba.

## 3. Contrato de negocio del provider (Lectura de Datasets)

### 3.1. Listar datasets

**Endpoint**

`GET http://localhost:8081/api/v1/datasets`

**Parámetros de consulta (Query Params) opcionales:**
- `clinicalCase`: Filtrar por caso clínico (ej. `asma`).
- `status`: Filtrar por estado.
- `page`: Número de página (por defecto `0`).
- `size`: Tamaño de la página (por defecto `20`).

**Propósito**

Devuelve el listado de datasets persistidos en el sistema.

**cURL completo**

```bash
curl -X GET 'http://localhost:8081/api/v1/datasets?page=0&size=20' \
  -H 'Accept: application/json'
```

### 3.2. Leer dataset crudo

**Endpoint**

`GET http://localhost:8081/api/v1/datasets/{id}/raw`

**Propósito**

Recupera el payload FHIR crudo asociado a un dataset concreto para depuración, auditoría y verificación de trazabilidad.

**cURL completo**

```bash
curl -X GET 'http://localhost:8081/api/v1/datasets/patient-02314/raw' \
  -H 'Accept: application/json'
```

## 4. Trust: solicitudes de acceso y políticas

### 4.1. Crear solicitud de acceso

**Endpoint**

`POST http://localhost:8082/api/v1/access-requests`

**Propósito**

Crea una solicitud de acceso con `datasetId`, `consumerId`, `purpose` y ventana temporal.

**cURL completo**

```bash
curl -X POST 'http://localhost:8082/api/v1/access-requests' \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-Request-Id: req-access-001' \
  --data-raw '{
    "datasetId": "patient-02314",
    "consumerId": "consumer-demo",
    "consumerDid": "did:web:consumer.example",
    "receiverDid": "did:web:provider.example",
    "purpose": "care",
    "requestedScopes": ["observation.read", "patient.read"],
    "validFrom": "2026-06-11T12:00:00Z",
    "validTo": "2026-06-11T18:00:00Z"
  }'
```

### 4.2. Consultar estado de una solicitud de acceso

**Endpoint**

`GET http://localhost:8082/api/v1/access-requests/{id}`

**Propósito**

Consulta los detalles y el estado de una solicitud de acceso previamente creada.

**cURL completo**

```bash
curl -X GET 'http://localhost:8082/api/v1/access-requests/req-access-001' \
  -H 'Accept: application/json'
```

### 4.3. Validar política

**Endpoint**

`POST http://localhost:8082/api/v1/policies/validate`

**Propósito**

Evalúa si una petición cumple el contrato de consentimiento y soberanía.

**cURL completo**

```bash
curl -X POST 'http://localhost:8082/api/v1/policies/validate' \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-Request-Id: req-policy-001' \
  --data-raw '{
    "datasetId": "patient-02314",
    "consumerId": "consumer-demo",
    "consumerDid": "did:web:consumer.example",
    "receiverDid": "did:web:provider.example",
    "purpose": "care",
    "scopes": ["observation.read"],
    "validFrom": "2026-06-11T12:00:00Z",
    "validTo": "2026-06-11T18:00:00Z"
  }'
```

## 5. Consumer: trabajos de consumo

### 5.1. Crear trabajo

**Endpoint**

`POST http://localhost:8083/api/v1/consumption-jobs`

**Propósito**

Solicita el consumo autorizado de datos tras la validación de trust.

**cURL completo**

```bash
curl -X POST 'http://localhost:8083/api/v1/consumption-jobs' \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-Request-Id: req-job-001' \
  --data-raw '{
    "datasetId": "patient-02314",
    "accessRequestId": "req-access-001",
    "mode": "summary"
  }'
```

### 5.2. Listar trabajos

**Endpoint**

`GET http://localhost:8083/api/v1/consumption-jobs`

**Parámetros de consulta (Query Params) opcionales:**
- `patientId`: Filtra los trabajos por el ID de un paciente específico.
- `summary`: Si es `true`, devuelve un resumen (por defecto `false`).

**Propósito**

Devuelve el histórico de trabajos de consumo y permite filtrado.

**cURL completo**

```bash
curl -X GET 'http://localhost:8083/api/v1/consumption-jobs?summary=true' \
  -H 'Accept: application/json'
```

### 5.3. Consultar un trabajo

**Endpoint**

`GET http://localhost:8083/api/v1/consumption-jobs/{id}`

**Propósito**

Consulta el estado de un trabajo concreto de consumo.

**cURL completo**

```bash
curl -X GET 'http://localhost:8083/api/v1/consumption-jobs/job-001' \
  -H 'Accept: application/json'
```

## 6. Proveedores: Médicos y Hospitales

**Endpoint**

`GET http://localhost:8081/api/v1/proveedores`

**Propósito**

Devuelve el listado de profesionales de la salud y centros registrados en el sistema.

**cURL completo**

```bash
curl -X GET 'http://localhost:8081/api/v1/proveedores' \
  -H 'Accept: application/json'
```

## 7. Historial Clínico

### 7.1. Inicializar Historial Clínico

**Endpoint**

`POST http://localhost:8081/api/v1/historial/init`

**Propósito**

Inicializa un nuevo historial clínico para un paciente con diagnósticos, tratamientos, dispositivos y datos de filiación.

**cURL completo**

```bash
curl -X POST 'http://localhost:8081/api/v1/historial/init' \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  --data-raw '{
    "fhirId": "patient-123",
    "nifDni": "12345678A",
    "nombreCompleto": "Juan Perez",
    "fechaNacimiento": "1980-01-01",
    "genero": "MALE",
    "diagnosticos": [
      {
        "cie10": "J45",
        "descripcion": "Asma no especificada"
      }
    ],
    "tratamientos": [
      {
        "nombreTratamiento": "Salbutamol",
        "indicaciones": "Inhalador PRN",
        "principioActivo": "Salbutamol"
      }
    ],
    "filiacion": [],
    "antecedentes": [],
    "dispositivos": []
  }'
```

### 7.2. Recuperar Historial de un Paciente

**Endpoint**

`GET http://localhost:8081/api/v1/historial/paciente/{pacienteId}`

**Propósito**

Recupera el historial clínico completo asociado a un paciente, incluyendo sus diagnósticos y tratamientos.

**cURL completo**

```bash
curl -X GET 'http://localhost:8081/api/v1/historial/paciente/patient-123' \
  -H 'Accept: application/json'
```

### 7.3. Añadir Diagnóstico al Historial

**Endpoint**

`POST http://localhost:8081/api/v1/historial/{historialId}/diagnosticos`

**Propósito**

Registra un nuevo diagnóstico en un historial clínico existente.

**cURL completo**

```bash
curl -X POST 'http://localhost:8081/api/v1/historial/123e4567-e89b-12d3-a456-426614174000/diagnosticos' \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  --data-raw '{
    "cie10": "I10",
    "descripcion": "Hipertensión esencial",
    "fechaDiagnostico": "2026-07-16T10:00:00Z"
  }'
```

### 7.4. Añadir Tratamiento al Historial

**Endpoint**

`POST http://localhost:8081/api/v1/historial/{historialId}/tratamientos`

**Propósito**

Registra un nuevo tratamiento en un historial clínico existente.

**cURL completo**

```bash
curl -X POST 'http://localhost:8081/api/v1/historial/123e4567-e89b-12d3-a456-426614174000/tratamientos' \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  --data-raw '{
    "nombreTratamiento": "Enalapril",
    "indicaciones": "10mg/dia",
    "fechaInicio": "2026-07-16T10:00:00Z"
  }'
```

## 8. Recuperar pacientes (Fachada FHIR)

**Endpoint**

`GET {{baseUrl}}/Patient?_count=20`

**Cabeceras**

- `Accept: application/fhir+json`

**Propósito**

Devuelve el `Bundle` FHIR con los pacientes persistidos en PostgreSQL.

**cURL completo**

```bash
curl -X GET 'http://localhost:3000/api/fhir/Patient?_count=20' \
  -H 'Accept: application/fhir+json'
```

## 9. Recuperar observaciones (Fachada FHIR)

**Endpoint**

`GET {{baseUrl}}/Observation?_count=20&_sort=-date`

**Parámetros de consulta (Query Params) opcionales soportados por la fachada:**
- `patient`: Filtra las observaciones de un paciente concreto (ej. `patient=Patient/123`).
- `_count`: Limita el número de resultados (por defecto 50).

**Cabeceras**

- `Accept: application/fhir+json`

**Propósito**

Devuelve el `Bundle` FHIR con las observaciones persistidas, ordenadas de más reciente a más antigua.

**cURL completo**

```bash
curl -X GET 'http://localhost:3000/api/fhir/Observation?_count=20&_sort=-date' \
  -H 'Accept: application/fhir+json'
```

## 10. Verificación de salud del stack

**Provider**

`GET http://localhost:8081/actuator/health`

**Cabeceras**

- `Accept: application/json`

**cURL completo**

```bash
curl -X GET 'http://localhost:3000/api/health/provider' \
  -H 'Accept: application/json'
```

**Trust**

`GET http://localhost:8082/actuator/health`

**Cabeceras**

- `Accept: application/json`

**cURL completo**

```bash
curl -X GET 'http://localhost:3000/api/health/trust' \
  -H 'Accept: application/json'
```

**Consumer**

`GET http://localhost:8083/actuator/health`

**Cabeceras**

- `Accept: application/json`

**cURL completo**

```bash
curl -X GET 'http://localhost:3000/api/health/consumer' \
  -H 'Accept: application/json'
```

## 11. Verificación del dashboard

**Endpoint**

`GET http://localhost:3000/`

**Cabeceras**

- `Accept: text/html`

**cURL completo**

```bash
curl -X GET 'http://localhost:3000/' \
  -H 'Accept: text/html'
```

## 12. Orden de ejecución recomendado

1. Arrancar `postgres`.
2. Arrancar `provider`.
3. Arrancar `trust`.
4. Arrancar `consumer`.
5. Arrancar `dashboard`.
6. Enviar la petición `POST` de ingesta FHIR u operaciones del historial (ej. `/init`).
7. Validar con los `GET`.
8. Refrescar el dashboard y comprobar los datos reales.

## 13. Importación en Postman

1. Importa primero `documentacion/postman/gaiax-health-local.postman_environment.json`.
2. Importa después `documentacion/postman/gaiax-health-e2e.postman_collection.json`.
3. Selecciona el environment `Gaia-X Health Local` en Postman.
4. Ejecuta la colección en el orden recomendado.

## 14. Notas

- El dashboard consume el endpoint FHIR a través de `http://localhost:3000/api/fhir`.
- El contrato funcional de provider para datasets está en `gaiax-health-deployment/docs/api-contracts.md`; la ingesta de bundles FHIR crudos se hace por la fachada `/api/fhir`.
- El flujo actual no requiere autenticación local adicional para la demo.
- Si quieres probar un único paciente, puedes reutilizar la misma estructura cambiando `Patient/{id}` en el `subject.reference` y en el `GET /Observation`.
