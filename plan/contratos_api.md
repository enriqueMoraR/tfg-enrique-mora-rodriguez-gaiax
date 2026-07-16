# Contratos API y validaciones FHIR (equivalente OpenAPI)

## Alcance
Este documento define contratos HTTP para:
1. `gaiax-health-provider-node`
2. `gaiax-health-trust-service`
3. `gaiax-health-consumer-node`

Incluye tambien reglas de validacion FHIR para el MVP:
- Observation de tension arterial
- Observation de frecuencia cardiaca

## Convenciones comunes
1. Base path versionado: `/api/v1`
2. Formato: `application/json`
3. Autenticacion: `Authorization: Bearer <JWT>` (OAuth2 client_credentials)
4. Correlacion: header `X-Request-Id` opcional; si no se envia, se genera.
5. Tiempos: formato ISO-8601 UTC.

## Modelo de errores comun
```json
{
  "timestamp": "2026-02-26T10:00:00Z",
  "requestId": "req-123",
  "code": "VALIDATION_ERROR",
  "message": "Payload invalido",
  "details": [
    { "field": "entry[0].resource.resourceType", "issue": "required" }
  ]
}
```

Codigos de error minimos:
- `400` `VALIDATION_ERROR`
- `401` `UNAUTHORIZED`
- `403` `FORBIDDEN`
- `404` `NOT_FOUND`
- `409` `CONFLICT`
- `422` `FHIR_VALIDATION_ERROR`
- `500` `INTERNAL_ERROR`

---

## Provider API

### POST `/api/v1/datasets/fhir`
Registra dataset FHIR publicado por proveedor.

Request (resumen):
```json
{
  "datasetId": "ds-bp-0001",
  "datasetType": "FHIR_BUNDLE",
  "clinicalCase": "blood-pressure",
  "payload": {
    "resourceType": "Bundle",
    "type": "collection",
    "entry": []
  },
  "metadata": {
    "owner": "provider-a",
    "purpose": "research",
    "tags": ["fhir", "vital-signs"]
  }
}
```

Response `201`:
```json
{
  "datasetId": "ds-bp-0001",
  "status": "PUBLISHED",
  "publishedAt": "2026-02-26T10:00:00Z"
}
```

Validaciones minimas:
- `datasetId` requerido y unico.
- `datasetType` debe ser `FHIR_BUNDLE`.
- `clinicalCase` permitido: `blood-pressure` o `heart-rate`.
- `payload.resourceType` debe ser `Bundle`.
- Bundle debe contener al menos una `Observation` valida segun reglas MVP.

### GET `/api/v1/datasets`
Lista datasets visibles para el cliente autenticado.

Query params:
- `clinicalCase` opcional (`blood-pressure` | `heart-rate`)
- `status` opcional (`PUBLISHED` | `REVOKED`)
- `page`, `size` opcionales

Response `200`:
```json
{
  "items": [
    {
      "datasetId": "ds-bp-0001",
      "clinicalCase": "blood-pressure",
      "status": "PUBLISHED",
      "publishedAt": "2026-02-26T10:00:00Z"
    }
  ],
  "page": 0,
  "size": 20,
  "total": 1
}
```

---

## Trust API

### POST `/api/v1/access-requests`
Crea una solicitud de acceso a dataset.

Request:
```json
{
  "datasetId": "ds-bp-0001",
  "consumerId": "consumer-a",
  "purpose": "research",
  "requestedScopes": ["dataset.read"]
}
```

Response `201`:
```json
{
  "requestId": "ar-0001",
  "status": "PENDING",
  "createdAt": "2026-02-26T10:00:00Z"
}
```

### GET `/api/v1/access-requests/{id}`
Consulta estado de solicitud.

Response `200`:
```json
{
  "requestId": "ar-0001",
  "datasetId": "ds-bp-0001",
  "consumerId": "consumer-a",
  "status": "APPROVED",
  "decisionReason": "policy-matched",
  "decidedAt": "2026-02-26T10:01:00Z"
}
```

Estados permitidos:
- `PENDING`
- `APPROVED`
- `REJECTED`

### POST `/api/v1/policies/validate`
Evalua reglas de acceso para una solicitud.

Request:
```json
{
  "datasetId": "ds-bp-0001",
  "consumerId": "consumer-a",
  "purpose": "research",
  "scopes": ["dataset.read"]
}
```

Response `200`:
```json
{
  "allowed": true,
  "policyId": "policy-001",
  "reason": "role-scope-purpose-match"
}
```

Reglas base MVP:
- Rol consumidor autorizado.
- Scope requerido presente.
- Finalidad permitida para dataset.

---

## Consumer API

### POST `/api/v1/consumption-jobs`
Inicia consumo de dataset autorizado.

Request:
```json
{
  "datasetId": "ds-bp-0001",
  "accessRequestId": "ar-0001",
  "mode": "DOWNLOAD"
}
```

Response `202`:
```json
{
  "jobId": "cj-0001",
  "status": "RUNNING",
  "startedAt": "2026-02-26T10:02:00Z"
}
```

### GET `/api/v1/consumption-jobs/{id}`
Consulta estado y resultado.

Response `200`:
```json
{
  "jobId": "cj-0001",
  "status": "SUCCEEDED",
  "datasetId": "ds-bp-0001",
  "recordsProcessed": 10000,
  "finishedAt": "2026-02-26T10:03:00Z"
}
```

Estados job:
- `RUNNING`
- `SUCCEEDED`
- `FAILED`

---

## Reglas de validacion FHIR (MVP)

## Reglas comunes Observation
Campos requeridos:
1. `resourceType = "Observation"`
2. `status` no vacio
3. `code.coding[0].system` no vacio
4. `code.coding[0].code` no vacio
5. `subject.reference` no vacio
6. `effectiveDateTime` valido ISO-8601

### Caso 1: tension arterial (`blood-pressure`)
Codigos esperados:
- Panel: `85354-9`
- Sistolica componente: `8480-6`
- Diastolica componente: `8462-4`

Validaciones adicionales:
- Deben existir dos componentes (sistolica y diastolica).
- `valueQuantity.value` numerico en ambos componentes.

### Caso 2: frecuencia cardiaca (`heart-rate`)
Codigo esperado:
- `8867-4`

Validaciones adicionales:
- Debe existir `valueQuantity.value` numerico.
- Unidad recomendada: `beats/min` o equivalente UCUM.

### Reglas Bundle
1. `resourceType = "Bundle"`
2. `type = "collection"`
3. `entry` no vacio.
4. Al menos una `Observation` valida de un caso permitido.

---

## Politica de versionado de contratos
1. Versionado semantico por API: `MAJOR.MINOR.PATCH`
2. Cambios incompatibles:
- incrementan `MAJOR`
- requieren nuevo base path (`/api/v2`)
3. Cambios compatibles:
- campos opcionales o nuevos endpoints incrementan `MINOR`
4. Correcciones sin cambio de contrato:
- incrementan `PATCH`
5. Regla multi-repo:
- provider/trust/consumer deben publicar matriz de compatibilidad de versiones.
