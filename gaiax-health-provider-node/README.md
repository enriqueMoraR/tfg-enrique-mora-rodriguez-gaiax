# gaiax-health-provider-node

Servicio Provider de Gaia-X Health.

Este módulo publica y consulta datasets FHIR, expone endpoints HTTP para el catálogo de datasets y valida el contenido clínico antes de servirlo a consumidores autorizados.

## Estructura
- `src/main/java/com/gaiahealth/provider/`
- `src/test/java/com/gaiahealth/provider/`
- `src/main/resources/`
- `src/test/resources/`

## Endpoints
Base path: `/api/v1`

- `POST /api/v1/datasets/fhir`
  - Registra o actualiza un dataset FHIR.
- `GET /api/v1/datasets`
  - Lista datasets disponibles.
- `GET /api/v1/datasets/{id}/raw`
  - Devuelve el contenido bruto del dataset.

Base path FHIR: `/api/fhir`

- `POST /api/fhir`
  - Ingesta payloads FHIR.
- `GET /api/fhir/Observation`
  - Consulta observaciones FHIR.
- `GET /api/fhir/Patient`
  - Consulta pacientes FHIR.

## Configuración
La configuración activa se carga desde `src/main/resources/application.properties`.

## Desarrollo local
```bash
mvn test
mvn spring-boot:run
```

## Notas de implementación
- El paquete raíz real es `com.gaiahealth.provider`.
- La lógica de negocio principal vive en `domain/` y `application/`.
- El soporte FHIR está separado en `domain/fhir` y `api/fhir`.
