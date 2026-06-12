# gaiax-health-consumer-node

Servicio Consumer de Gaia-X Health.

Este módulo solicita acceso a datasets autorizados al servicio de trust, ejecuta trabajos de consumo y expone el estado de esos trabajos por API HTTP.

## Estructura
- `src/main/java/com/gaiahealth/consumer/`
- `src/test/java/com/gaiahealth/consumer/`
- `src/main/resources/application.properties`
- `src/test/resources/fhir/payloads/`

## Endpoints
Base path: `/api/v1/consumption-jobs`

- `POST /api/v1/consumption-jobs`
  - Crea un trabajo de consumo.
  - Body:
    - `datasetId`
    - `accessRequestId`
    - `mode`
- `GET /api/v1/consumption-jobs`
  - Lista trabajos de consumo.
  - Query params:
    - `patientId` opcional
    - `summary` opcional (`true|false`)
- `GET /api/v1/consumption-jobs/{id}`
  - Devuelve el estado detallado de un trabajo.

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
- validación de requests;
- gestión de trabajos de consumo;
- integración con el cliente trust;
- parseo de fixtures FHIR en `src/test/resources/fhir/payloads/`.

## Notas de implementación
- El paquete raíz real es `com.gaiahealth.consumer`.
- El cliente HTTP al trust vive en `infrastructure/trust`.
- La lógica de negocio principal está en `application/ConsumerService.java`.
