# Feature: clean-architecture

## Entrada funcional aprobada
Esta feature parte del estado funcional actual del sistema, que ya dispone de:
- backend separado en `provider`, `trust` y `consumer`;
- dashboard React operativo con analítica y visualización de pacientes;
- flujo E2E FHIR y documentación de despliegue;
- cobertura de tests y documentación técnica consolidada.

## Objetivo técnico
Reorganizar la base de código para que cada backend siga una separación explícita de capas y el frontend se ordene por `features`, reduciendo el acoplamiento entre casos de uso, transporte y detalles de infraestructura.

## Decisión de arquitectura
1. Backend:
   - Estructura obligatoria por servicio:
     - `api`
     - `application`
     - `domain`
     - `infrastructure`
   - Controllers solo como adaptadores HTTP.
   - Casos de uso como punto central de orquestación.
   - Repositorios, clientes externos y configuración aislados en `infrastructure`.
2. Frontend:
   - Estructura por `features` y `shared`.
   - Los componentes visuales no contienen lógica de negocio.
   - Los servicios de acceso a API se tratan como adaptadores técnicos.

## Mapeo técnico de componentes actuales
### Provider
- `api`:
  - `DatasetController`
  - `CreateDatasetRequest`
  - `DatasetResponse`
  - `DatasetListResponse`
  - `DatasetItemResponse`
  - `DatasetMetadata`
  - `ErrorResponse`
  - `ErrorDetailResponse`
  - `ProviderExceptionHandler`
- `application`:
  - `DatasetService` como candidato a dividir en casos de uso
  - validaciones de entrada y orquestación
- `domain`:
  - `ClinicalCase`
  - `DatasetRecord`
  - `DatasetStatus`
  - `DatasetType`
  - `ProviderApiException`
  - `ProviderErrorCode`
  - `ValidationIssue`
  - reglas FHIR puras
- `infrastructure`:
  - persistencia
  - serialización/deserialización
  - clientes y adaptadores futuros

### Trust
- `api`:
  - `TrustController`
  - DTOs y handlers de error
- `application`:
  - `TrustService`
  - orquestación de solicitudes de acceso
  - evaluación de política como caso de uso
- `domain`:
  - `AccessRequestRecord`
  - `AccessRequestStatus`
  - `AuditEvent`
  - `TrustValidationIssue`
  - `TrustErrorCode`
  - `TrustApiException`
  - reglas de consentimiento y política
- `infrastructure`:
  - almacenamiento
  - auditoría
  - adaptadores externos

### Consumer
- `api`:
  - `ConsumerController`
  - DTOs y handlers de error
- `application`:
  - `ConsumerService`
  - orquestación de consumo y consulta al trust
- `domain`:
  - `ConsumptionJobRecord`
  - `ConsumptionJobStatus`
  - `ConsumerValidationIssue`
  - `ConsumerErrorCode`
  - `ConsumerApiException`
  - invariantes del job de consumo
- `infrastructure`:
  - `HttpTrustAccessClient`
  - futuros clientes FHIR
  - persistencia o colas si se incorporan

### Dashboard
- Reorganización objetivo:
  - `features/patients`
  - `features/analysis`
  - `shared`
  - `app` o `pages` como composición
- `services/*` debe dividirse entre:
  - adaptadores de API
  - transformadores de FHIR
  - cálculos de analítica
- La lógica de negocio de visualización no debe residir en componentes de presentación.

## Estrategia de migración
1. Crear la estructura de carpetas sin mover todavía toda la lógica.
2. Extraer casos de uso desde servicios existentes.
3. Mover reglas puras al dominio.
4. Aislar los adaptadores externos.
5. Reorganizar el frontend por features.
6. Ejecutar tests en cada paso para mantener el contrato estable.

## Riesgos tecnicos
1. Riesgo de sobreingeniería si se crea demasiada abstracción sin valor añadido.
2. Riesgo de regresiones si se mueve lógica entre capas sin tests de soporte.
3. Riesgo de duplicidad temporal entre estructuras vieja y nueva durante la migración.

## Criterios de validacion
1. La compilación y los tests siguen pasando tras la reorganización.
2. Cada servicio backend presenta una frontera clara entre transporte, negocio e infraestructura.
3. El frontend queda agrupado por features y con adaptadores bien delimitados.
4. No se rompen los contratos E2E existentes.

