# gaiax-health-trust-service

Servicio Trust de Gaia-X Health.

Este módulo evalúa políticas de acceso, crea solicitudes de acceso autorizadas y expone el estado de esas solicitudes para que otros nodos puedan decidir si un dataset puede consumirse.

## Estructura
- `src/main/java/com/gaiahealth/trust/`
- `src/test/java/com/gaiahealth/trust/`
- `src/main/resources/application.properties`
- `src/test/resources/fhir/payloads/`

## Endpoints
Base path: `/api/v1`

- `POST /api/v1/access-requests`
  - Crea una solicitud de acceso.
  - Body:
    - `datasetId`
    - `consumerId`
    - `consumerDid`
    - `receiverDid`
    - `purpose`
    - `requestedScopes`
    - `validFrom`
    - `validTo`
- `GET /api/v1/access-requests/{id}`
  - Devuelve el estado de una solicitud de acceso.
- `POST /api/v1/policies/validate`
  - Evalúa una política de acceso.
  - Body:
    - `datasetId`
    - `consumerId`
    - `consumerDid`
    - `receiverDid`
    - `purpose`
    - `scopes`
    - `validFrom`
    - `validTo`

## Configuración
La configuración activa se carga desde `src/main/resources/application.properties`.

Variables relevantes:
- `GAIAX_TRUST_BASE_URL`
  - URL base del servicio trust.
  - Valor por defecto: `http://localhost:8082`

Health y observabilidad:
- `management.endpoints.web.exposure.include=health,info,metrics`
- `management.endpoint.health.probes.enabled=true`

## Desarrollo local
```bash
mvn test
mvn spring-boot:run
```

## Pruebas
Los tests del módulo cubren:
- validación de solicitudes de acceso;
- evaluación de políticas;
- exposición de los endpoints HTTP;
- reglas de consentimiento y auditoría en memoria.

## Notas de implementación
- El paquete raíz real es `com.gaiahealth.trust`.
- La lógica de evaluación reside en `application/TrustService.java`.
- Las reglas puras de política están en `domain/PolicyService.java`.
