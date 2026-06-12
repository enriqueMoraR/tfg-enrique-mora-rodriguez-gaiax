# API Contracts — Gaia-X Health

This document summarizes the REST contracts for the polyrepo deployment.

## Common API Conventions
- Business APIs base path: `/api/v1`
- FHIR facade base path: `/api/fhir`
- Content type:
  - `application/json` for `/api/v1`
  - `application/fhir+json` for FHIR resources
- Authorization: none enforced in the current implementation; token-based access can be added at deployment level
- Correlation header: `X-Request-Id`
- Time format: ISO-8601 UTC

## Error Model
```json
{
  "timestamp": "2026-02-26T10:00:00Z",
  "requestId": "req-123",
  "code": "VALIDATION_ERROR",
  "message": "Invalid payload",
  "details": [
    { "field": "entry[0].resource.resourceType", "issue": "required" }
  ]
}
```

### Provider
- `POST /api/v1/datasets/fhir`
- `GET /api/v1/datasets`
- `GET /api/v1/datasets/{id}/raw`

#### `POST /api/v1/datasets/fhir`
Request body:
```json
{
  "datasetId": "patient-02314",
  "datasetType": "FHIR_BUNDLE",
  "clinicalCase": "blood-pressure",
  "payload": { "resourceType": "Bundle" },
  "metadata": {
    "owner": "demo",
    "purpose": "care",
    "jurisdiction": "EU",
    "policyUri": "https://example.org/policies/care",
    "receiverDid": "did:web:consumer.example",
    "retentionDays": 365,
    "validFrom": "2026-06-11T12:00:00Z",
    "validTo": "2026-06-12T12:00:00Z",
    "tags": ["gaia-x", "fhir"]
  }
}
```

#### `GET /api/v1/datasets`
Query params:
- `clinicalCase` optional
- `status` optional
- `page` default `0`
- `size` default `20`

#### `GET /api/v1/datasets/{id}/raw`
Returns the stored raw payload for the given dataset id.

### Provider FHIR facade
- `POST /api/fhir/Bundle`
- `POST /api/fhir/Observation`
- `GET /api/fhir/Observation`
- `GET /api/fhir/Patient`

#### `POST /api/fhir/Bundle`
Request body:
- `Bundle` with `Patient`, `Device` and `Observation`
- optional query param `x-request-id`

#### `POST /api/fhir/Observation`
Request body:
- raw FHIR `Observation`
- optional query param `x-request-id`

#### `GET /api/fhir/Observation`
Query params:
- `patient` optional
- `_count` default `50`

#### `GET /api/fhir/Patient`
Query params:
- `_count` default `50`

### Trust
- `POST /api/v1/access-requests`
- `GET /api/v1/access-requests/{id}`
- `POST /api/v1/policies/validate`

#### `POST /api/v1/access-requests`
Request body:
```json
{
  "datasetId": "patient-02314",
  "consumerId": "consumer-demo",
  "consumerDid": "did:web:consumer.example",
  "receiverDid": "did:web:provider.example",
  "purpose": "care",
  "requestedScopes": ["observation.read"],
  "validFrom": "2026-06-11T12:00:00Z",
  "validTo": "2026-06-11T18:00:00Z"
}
```

#### `GET /api/v1/access-requests/{id}`
Returns the request status and request metadata.

#### `POST /api/v1/policies/validate`
Request body:
```json
{
  "datasetId": "patient-02314",
  "consumerId": "consumer-demo",
  "consumerDid": "did:web:consumer.example",
  "receiverDid": "did:web:provider.example",
  "purpose": "care",
  "scopes": ["observation.read"],
  "validFrom": "2026-06-11T12:00:00Z",
  "validTo": "2026-06-11T18:00:00Z"
}
```

### Consumer
- `POST /api/v1/consumption-jobs`
- `GET /api/v1/consumption-jobs`
- `GET /api/v1/consumption-jobs/{id}`

#### `POST /api/v1/consumption-jobs`
Request body:
```json
{
  "datasetId": "patient-02314",
  "accessRequestId": "req-access-001",
  "mode": "summary"
}
```

#### `GET /api/v1/consumption-jobs`
Query params:
- `patientId` optional
- `summary` default `false`

#### `GET /api/v1/consumption-jobs/{id}`
Returns the status of a consumption job.

## FHIR Validation Rules
- `Observation` must have `resourceType`, `status`, `code.coding`, `subject.reference`, `effectiveDateTime`
- `blood-pressure` must carry systolic and diastolic components
- `heart-rate` must include a numeric quantity value
- Raw FHIR ingestion uses the `/api/fhir` facade; the dataset envelope contract stays at `/api/v1/datasets/fhir`.
