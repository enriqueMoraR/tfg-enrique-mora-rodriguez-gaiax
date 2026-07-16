# Analisis Tecnico - Gaia-X Health Hardening

**Feature:** `feature-gaiax-health-hardening`  
**Version:** 1.0  
**Fecha creacion:** 2026-06-10

---

## Entrada Funcional
Esta feature endurece el MVP existente sin romper el flujo E2E:
- provider -> trust -> consumer -> dashboard;
- datos clinicos FHIR como formato principal;
- entorno de despliegue centralizado para demos, validacion y carga.

## Objetivo Tecnico
Introducir capas tecnicas de soberania y seguridad que acerquen el stack al modelo Gaia-X Health:
- validacion FHIR/IPS estricta;
- PEP/PDP con consentimiento granular;
- identidad federada OIDC/SIOP;
- minimizacion de datos en UI;
- despliegue con controles de red, secretos y trazabilidad.

## Decisiones Tecnicas
### DT-001: Provider como punto de validacion fuerte
- La entrada de datos debe validarse antes de cualquier persistencia o publicacion.
- La validacion no debe limitarse a checks manuales de campos; debe poder evolucionar a perfiles FHIR y validadores de esquema.
- Cada dataset debe llevar metadatos de soberania.

### DT-002: Trust-service como PDP y audit trail
- El trust-service pasa a ser la fuente de decision de politica.
- Debe evaluar:
  - vigencia temporal;
  - proposito;
  - receptor;
  - identidad federada.
- Debe mantener auditoria persistente o, como minimo, exportable.

### DT-003: Consumer con PEP y propagacion de identidad
- El consumer no debe consumir datos si no existe autorizacion valida.
- Debe propagar identidad y contexto de autorizacion a provider/trust.
- El acceso debe ser resistente a reintentos y fallos de trust-service.

### DT-004: Dashboard con minimizacion de datos
- El frontend debe pedir solo el subconjunto necesario.
- Donde sea posible, usar `_summary`/`_elements` o endpoints equivalentes.
- La interfaz debe mostrar al paciente que datos se estan visualizando y bajo que consentimiento.

### DT-005: Deployment seguro y reproducible
- Mantener `gaiax-health-deployment` como punto de entrada.
- Introducir:
  - TLS o terminacion segura;
  - secretos externos;
  - red segregada;
  - trazabilidad de acceso;
  - version matrix de compatibilidad.

### DT-006: Conector federado como evolucion de infraestructura
- No se introduce como repositorio nuevo obligatorio.
- Se modela como capa de integracion en deployment para evitar copia innecesaria de datos.
- La meta es que el trafico entre dominios pueda evolucionar a intercambio federado trazable.

## Arquitectura Objetivo
```text
Paciente/Consentimiento
        |
        v
[dashboard] ---> consultas minimizadas
        |
        v
[consumer PEP] ---> [trust PDP / audit]
        |                  |
        |                  v
        |            consentimiento vigente
        v
[provider] ---> validacion FHIR + metadatos soberania
        |
        v
[deployment] ---> red confiable / TLS / secretos / observabilidad
```

## Cambios por Repositorio
### gaiax-health-provider-node
- Validacion de entrada con respuesta FHIR/OperationOutcome equivalente.
- Enriquecimiento de metadatos con soberania.
- Restriccion de respuestas para no exponer payload completo sin necesidad.

### gaiax-health-trust-service
- Modelo de consentimiento formal.
- PEP/PDP separado por responsabilidad.
- Auditoria de decisiones y revocaciones.

### gaiax-health-consumer-node
- Verificacion de consentimiento antes de consumir.
- Propagacion de identidad y contexto.
- Manejo de autorizacion fallida sin fuga de datos.

### gaiax-health-dashboard
- Consultas parciales.
- Indicador de consentimiento visible.
- Vista del paciente con provenance y alcance de datos.

### gaiax-health-deployment
- Configuracion de red, puertos, secretos y TLS.
- Matriz de compatibilidad de versiones.
- Soporte para pruebas E2E y carga con entorno reproducible.

## Contratos y Validaciones
1. Entrada FHIR:
   - Bundle tipo `collection`.
   - Recursos `Observation` validados por caso clinico.
2. Politica:
   - consentimiento vigente;
   - receptor autorizado;
   - proposito permitido;
   - trazabilidad de decision.
3. UI:
   - no mostrar mas campos de los necesarios;
   - registrar el origen y el alcance visualizado.
4. Despliegue:
   - no exponer internals sin necesidad;
   - separar red interna y superficie publica.

## ADR Nuevos o Ajustados
### ADR-008 - Consentimiento granular como parte del flujo E2E
El consentimiento no se trata como un control externo, sino como una condicion operacional del acceso.

### ADR-009 - Minimizacion por defecto en dashboard
La UI debe solicitar y renderizar el minimo necesario para la demo y la defensa.

### ADR-010 - Red de despliegue segregada
El stack se despliega en una red controlada y no se asume confianza entre todos los servicios por defecto.

## Riesgos Tecnicos
1. Si la validacion FHIR se hace demasiado estricta sin perfiles claros, puede bloquear datasets validos del MVP.
2. Un PEP mal ubicado puede duplicar checks y complicar debugging.
3. Mover consentimiento a persistencia demasiado pronto puede introducir complejidad de schema y migraciones.
4. La UI puede sobrecargarse si se intenta exponer toda la trazabilidad en una sola vista.

## Plan de Integracion
1. Definir contrato de consentimiento y metadata de soberania.
2. Endurecer provider.
3. Introducir PDP/PEP en trust-service y consumer.
4. Alinear dashboard con consultas minimizadas.
5. Ajustar deployment con controles de red y secretos.
6. Ejecutar pruebas funcionales, unitarias y E2E.
