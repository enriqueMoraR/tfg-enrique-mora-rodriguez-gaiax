# Plan de Tareas - Gaia-X Health Hardening

**Feature:** `feature-gaiax-health-hardening`  
**Version:** 1.0  
**Fecha creacion:** 2026-06-10

---

[x] H-1: Definir contrato de consentimiento y soberania

### Descripcion
Fijar el modelo comun que usaran provider, trust, consumer y dashboard para representar consentimiento, proposito, receptor, vigencia y metadatos de soberania.

### Dependencias
(ninguna)

### Criterios de validacion
- Existe un contrato de consentimiento versionado.
- El contrato cubre tiempo, proposito y receptor.
- Los metadatos de soberania quedan definidos para los recursos publicados.

### Feedback al agente
- [x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Tipo: doc
- Componentes: governance, consent, sovereignty
- Feature: feature-gaiax-health-hardening

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-deployment/docs/consent-contract.md`, `gaiax-health-deployment/README.md`, `gaiax-health-deployment/docker-compose.yml`, `plan/feature-gaiax-health-hardening/tareas.md`
- Archivos creados: `gaiax-health-deployment/docs/consent-contract.md`
- Acciones realizadas: definido contrato versionado de consentimiento/soberania; documentados tiempo, proposito, receptor y metadatos de soberania; enlazado el contrato en el despliegue central.

---

[x] H-2: Endurecer validacion FHIR en provider

### Descripcion
Refactorizar `gaiax-health-provider-node` para que la entrada valide FHIR R4/R5 con criterios mas estrictos, y para que los errores de validacion devuelvan una respuesta procesable tipo OperationOutcome o equivalente.

### Dependencias
H-1

### Criterios de validacion
- Un payload FHIR invalido se rechaza antes de persistirse.
- La validacion cubre Bundle, Observation y los casos clinicos del MVP.
- El provider adjunta o conserva metadatos de soberania al publicar.

### Feedback al agente
- [x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Tipo: feature
- Componentes: provider, fhir, validation
- Feature: feature-gaiax-health-hardening

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-provider-node/src/main/java/com/example/gaiahealth/provider/api/DatasetMetadata.java`, `gaiax-health-provider-node/src/main/java/com/example/gaiahealth/provider/api/DatasetController.java`, `gaiax-health-provider-node/src/main/java/com/example/gaiahealth/provider/domain/DatasetService.java`, `gaiax-health-provider-node/src/test/java/com/example/gaiahealth/provider/api/ProviderApiFunctionalTest.java`, `gaiax-health-provider-node/pom.xml`, `plan/feature-gaiax-health-hardening/tareas.md`
- Archivos creados: ninguno
- Acciones realizadas: ampliada la metadata de publicacion con jurisdiccion, policy URI, DID receptor y ventana temporal; endurecida la validacion antes de persistir; ajustados los tests funcionales y unitarios al nuevo contrato.

---

[x] H-3: Introducir PDP y consentimiento granular en trust-service

### Descripcion
Convertir `gaiax-health-trust-service` en el punto de decision de politica, con consentimiento granular por tiempo, proposito y receptor, y con auditoria de decisiones.

### Dependencias
H-1

### Criterios de validacion
- El trust-service decide allow/deny en base a consentimiento vigente.
- Se registra auditoria por cada decision importante.
- El servicio expone la base para integracion OIDC/SIOP.

### Feedback al agente
- [x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Tipo: feature
- Componentes: trust, consent, audit, identity
- Feature: feature-gaiax-health-hardening

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-trust-service/src/main/java/com/example/gaiahealth/trust/api/CreateAccessRequestRequest.java`, `gaiax-health-trust-service/src/main/java/com/example/gaiahealth/trust/api/PolicyValidationRequest.java`, `gaiax-health-trust-service/src/main/java/com/example/gaiahealth/trust/api/AccessRequestStatusResponse.java`, `gaiax-health-trust-service/src/main/java/com/example/gaiahealth/trust/domain/AccessRequestRecord.java`, `gaiax-health-trust-service/src/main/java/com/example/gaiahealth/trust/domain/PolicyService.java`, `gaiax-health-trust-service/src/main/java/com/example/gaiahealth/trust/domain/TrustService.java`, `gaiax-health-trust-service/src/test/java/com/example/gaiahealth/trust/domain/PolicyServiceTest.java`, `gaiax-health-trust-service/src/test/java/com/example/gaiahealth/trust/domain/TrustServiceTest.java`, `gaiax-health-trust-service/src/test/java/com/example/gaiahealth/trust/api/TrustControllerTest.java`, `plan/feature-gaiax-health-hardening/tareas.md`
- Archivos creados: ninguno
- Acciones realizadas: convertido trust-service en PDP con consentimiento granular por tiempo, proposito y receptor; ampliados los contratos de request/response; preservada la trazabilidad de las decisiones en los records y tests.

---

[x] H-4: Propagar identidad y consentimiento en consumer

### Descripcion
Ajustar `gaiax-health-consumer-node` para que no consuma datasets sin autorizacion valida, y para que propague el contexto de identidad federada hacia trust/provider.

### Dependencias
H-2, H-3

### Criterios de validacion
- El consumer rechaza consumo sin autorizacion vigente.
- La identidad y el contexto de acceso viajan entre peticiones.
- Los errores de trust o provider no exponen datos sensibles.

### Feedback al agente
- [x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Tipo: feature
- Componentes: consumer, identity, access-control
- Feature: feature-gaiax-health-hardening

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-consumer-node/src/main/java/com/example/gaiahealth/consumer/infra/trust/AccessRequestStatusResponse.java`, `gaiax-health-consumer-node/src/main/java/com/example/gaiahealth/consumer/domain/ConsumptionJobRecord.java`, `gaiax-health-consumer-node/src/main/java/com/example/gaiahealth/consumer/api/ConsumptionJobStatusResponse.java`, `gaiax-health-consumer-node/src/main/java/com/example/gaiahealth/consumer/api/ConsumerController.java`, `gaiax-health-consumer-node/src/main/java/com/example/gaiahealth/consumer/domain/ConsumerService.java`, `gaiax-health-consumer-node/src/main/resources/application.properties`, `gaiax-health-consumer-node/src/test/java/com/example/gaiahealth/consumer/domain/ConsumerServiceTest.java`, `gaiax-health-consumer-node/src/test/java/com/example/gaiahealth/consumer/api/ConsumerControllerTest.java`, `plan/feature-gaiax-health-hardening/tareas.md`
- Archivos creados: ninguno
- Acciones realizadas: propagado el contexto de identidad y consentimiento entre consumer, trust y provider; añadido modo resumen para minimizar exposición; ampliadas las respuestas con provenance y contexto de acceso.

---

[x] H-5: Minimizar consultas y exponer consentimiento en dashboard

### Descripcion
Refactorizar `gaiax-health-dashboard` para pedir solo el subconjunto necesario de datos, mostrar el estado del consentimiento y reducir la exposicion de informacion sensible.

### Dependencias
H-1, H-4

### Criterios de validacion
- El dashboard usa consultas reducidas (`_summary`, `_elements` o equivalente).
- La vista del paciente muestra estado de consentimiento y provenance.
- No se renderiza informacion sensible que no sea necesaria para la demo.

### Feedback al agente
- [x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Media
- Tipo: feature
- Componentes: dashboard, ui, privacy
- Feature: feature-gaiax-health-hardening

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-dashboard/src/types/api.ts`, `gaiax-health-dashboard/src/services/consumerService.ts`, `gaiax-health-dashboard/src/hooks/usePatientData.ts`, `gaiax-health-dashboard/src/pages/Dashboard.tsx`, `gaiax-health-dashboard/src/tests/hooks/usePatientData.test.tsx`, `gaiax-health-dashboard/src/tests/services/consumerService.test.ts`, `plan/feature-gaiax-health-hardening/tareas.md`
- Archivos creados: ninguno
- Acciones realizadas: reducido el volumen de datos en consultas del dashboard; expuesto el estado de consentimiento y provenance en la vista del paciente; ajustados servicios y tests al parametro de resumen.

---

[x] H-6: Endurecer deployment con red y secretos

### Descripcion
Actualizar `gaiax-health-deployment` para separar red publica e interna, introducir TLS o terminacion segura, y documentar secretos, puertos y matriz de versiones.

### Dependencias
H-2, H-3, H-4

### Criterios de validacion
- El despliegue sigue siendo reproducible.
- La red de servicios queda segregada.
- Los secretos no quedan embebidos en el repositorio.
- La matriz de compatibilidad queda actualizada.

### Feedback al agente
- [x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Tipo: setup
- Componentes: deployment, infra, security
- Feature: feature-gaiax-health-hardening

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-deployment/docker-compose.yml`, `gaiax-health-deployment/README.md`, `plan/feature-gaiax-health-hardening/tareas.md`
- Archivos creados: `gaiax-health-deployment/docs/consent-contract.md`
- Acciones realizadas: segregada la red interna del despliegue, endurecidos los envs de backend, documentado el contrato de consentimiento y alineado el dashboard con el endpoint publico.

---

[x] H-7: Añadir pruebas de consentimiento, validacion y minimizacion

### Descripcion
Crear o actualizar suites de tests para cubrir el nuevo comportamiento de provider, trust, consumer y dashboard.

### Dependencias
H-2, H-3, H-4, H-5

### Criterios de validacion
- Hay tests unitarios para el modelo de consentimiento y la validacion FHIR.
- Hay tests de integracion para el flujo de acceso.
- Hay tests del dashboard para la minimizacion y la vista de consentimiento.

### Feedback al agente
- [x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Tipo: test
- Componentes: tests, fhir, consent, ui
- Feature: feature-gaiax-health-hardening

### Resumen de ejecucion
- Archivos modificados: `gaiax-health-provider-node/src/test/java/com/example/gaiahealth/provider/domain/DatasetServiceUnitTest.java`, `gaiax-health-trust-service/src/test/java/com/example/gaiahealth/trust/domain/PolicyServiceTest.java`, `gaiax-health-consumer-node/src/main/java/com/example/gaiahealth/consumer/domain/ConsumerService.java`, `gaiax-health-consumer-node/src/test/java/com/example/gaiahealth/consumer/domain/ConsumerServiceTest.java`, `gaiax-health-consumer-node/src/test/java/com/example/gaiahealth/consumer/api/ConsumerControllerTest.java`, `gaiax-health-dashboard/src/tests/pages/Dashboard.test.tsx`, `plan/feature-gaiax-health-hardening/tareas.md`
- Archivos creados: ninguno
- Acciones realizadas: añadidos tests de validacion FHIR con metadata de soberania, consentimiento expirado, propagacion del contexto aprobado y vista minimizada con provenance; ajustado el consumer para permitir tests aislados sin red real.

---

[x] H-8: Validar E2E y preparar evidencia para defensa

### Descripcion
Ejecutar el flujo extremo a extremo con el nuevo hardening y dejar una evidencia de comportamiento y riesgos residuales para la defensa tecnica.

### Dependencias
H-6, H-7

### Criterios de validacion
- El flujo provider -> trust -> consumer -> dashboard sigue operativo.
- Se documentan brechas restantes frente a certificacion.
- Se deja una recomendacion clara de siguiente iteracion.

### Feedback al agente
- [x] F-1: Sin feedback pendiente.

### Jira relacionada
- Proyecto: (sin definir)
- Issue: (sin definir)
- URL: (sin definir)
- Sincronizacion: no configurada

### Metadatos
- Prioridad: Alta
- Tipo: doc
- Componentes: e2e, evidence, delivery
- Feature: feature-gaiax-health-hardening

### Resumen de ejecucion
- Archivos modificados: `plan/feature-gaiax-health-hardening/tareas.md`
- Archivos creados: `plan/feature-gaiax-health-hardening/evidencia_e2e.md`
- Acciones realizadas: ejecutadas las suites de provider, trust, consumer y dashboard; validada la build de dashboard; preparada evidencia E2E con conclusiones y siguiente iteracion recomendada.
