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
| `POST` | `/Bundle?x-request-id={{requestId}}` | Fachada FHIR del provider. Para smoke test usa `fhirBundle.sample.json`; para carga real usa `multipleFhirBundle.*.json` |
| `GET` | `/Patient?_count=20` | Recuperación de pacientes persistidos |
| `GET` | `/Observation?_count=20&_sort=-date` | Recuperación de observaciones persistidas |
| `POST` | `/api/v1/access-requests` | Alta de una solicitud de acceso en trust |
| `GET` | `/api/v1/access-requests/{id}` | Consulta de estado de una solicitud de acceso |
| `POST` | `/api/v1/policies/validate` | Validación de una política de acceso |
| `POST` | `/api/v1/consumption-jobs` | Alta de un trabajo de consumo autorizado |
| `GET` | `/api/v1/consumption-jobs` | Listado de trabajos de consumo |
| `GET` | `/api/v1/consumption-jobs/{id}` | Consulta de estado de un trabajo de consumo |
| `GET` | `/api/health/provider`, `/api/health/trust`, `/api/health/consumer` | Verificación de salud de los servicios vía proxy del dashboard |
| `GET` | `http://localhost:3000/` | Comprobación básica del dashboard |

## Cabeceras

- `Content-Type: application/fhir+json`
- `Accept: application/fhir+json`
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

Repite el mismo patrón cambiando el sufijo del `requestId` y el fichero de entrada para cada partición.

## 2. Contrato de negocio del provider

**Endpoint**

`POST http://localhost:8081/api/v1/datasets/fhir`

**Propósito**

Publica un dataset con envoltorio de negocio (`datasetId`, `datasetType`, `clinicalCase`, `payload`, `metadata`) y deja el recurso listo para trazabilidad y auditoría.

**Nota**

Este endpoint no consume `Bundle` crudo. Si el objetivo es enviar bundles FHIR desde Postman, usa la fachada `/api/fhir/Bundle` documentada arriba.

## 3. Leer dataset crudo

**Endpoint**

`GET http://localhost:8081/api/v1/datasets/{id}/raw`

**Propósito**

Recupera el payload FHIR crudo asociado a un dataset concreto para depuración, auditoría y verificación de trazabilidad.

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

### 4.2. Validar política

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

**Propósito**

Devuelve el histórico de trabajos de consumo y permite filtrado por `patientId`.

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

## 6. Recuperar pacientes

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

## 7. Recuperar observaciones

**Endpoint**

`GET {{baseUrl}}/Observation?_count=20&_sort=-date`

**Cabeceras**

- `Accept: application/fhir+json`

**Propósito**

Devuelve el `Bundle` FHIR con las observaciones persistidas, ordenadas de más reciente a más antigua.

**cURL completo**

```bash
curl -X GET 'http://localhost:3000/api/fhir/Observation?_count=20&_sort=-date' \
  -H 'Accept: application/fhir+json'
```

## 8. Verificación de salud del stack

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

## 9. Verificación del dashboard

**Endpoint**

`GET http://localhost:3000/`

**Cabeceras**

- `Accept: text/html`

**cURL completo**

```bash
curl -X GET 'http://localhost:3000/' \
  -H 'Accept: text/html'
```

## 10. Orden de ejecución recomendado

1. Arrancar `postgres`.
2. Arrancar `provider`.
3. Arrancar `trust`.
4. Arrancar `consumer`.
5. Arrancar `dashboard`.
6. Enviar la petición `POST` de ingesta.
7. Validar con los `GET`.
8. Refrescar el dashboard y comprobar los datos reales.

## 11. Importación en Postman

1. Importa primero `documentacion/postman/gaiax-health-local.postman_environment.json`.
2. Importa después `documentacion/postman/gaiax-health-e2e.postman_collection.json`.
3. Selecciona el environment `Gaia-X Health Local` en Postman.
4. Ejecuta la colección en el orden recomendado.

## 12. Notas

- El dashboard consume el endpoint FHIR a través de `http://localhost:3000/api/fhir`.
- El contrato funcional de provider para datasets está en `gaiax-health-deployment/docs/api-contracts.md`; la ingesta de bundles FHIR crudos se hace por la fachada `/api/fhir`.
- El flujo actual no requiere autenticación local adicional para la demo.
- Si quieres probar un único paciente, puedes reutilizar la misma estructura cambiando `Patient/{id}` en el `subject.reference` y en el `GET /Observation`.
