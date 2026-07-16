# Analisis Funcional - Gaia-X Health Hardening

**Feature:** `feature-gaiax-health-hardening`  
**Version:** 1.0 (refactor de alineacion Gaia-X Health)  
**Fecha creacion:** 2026-06-10

---

## Objetivo General
Endurecer el stack actual de Gaia-X Health para que el flujo provider -> trust -> consumer -> dashboard opere con principios de soberania, minimizacion de datos, interoperabilidad FHIR e identidad federada.

## Problema a Resolver
El MVP actual demuestra el flujo funcional, pero todavia expone brechas para un contexto Gaia-X Health:
- validacion FHIR parcial y artesanal;
- consentimiento no granular;
- autenticacion local implícita;
- acceso a datos no minimizado en el dashboard;
- despliegue sin controles de confianza ni trazabilidad de uso suficientes.

## Alcance Funcional
### Incluido
- Validacion estricta de recursos HL7 FHIR R4/R5 en la entrada del provider.
- Modelo de consentimiento granular por:
  - tiempo;
  - proposito;
  - receptor.
- Introduccion de un PEP/PDP entre consumer y trust-service.
- Identidad federada compatible con OIDC/SIOP.
- Metadatos de soberania por recurso:
  - propietario;
  - jurisdiccion;
  - finalidad de uso;
  - retencion;
  - trazabilidad.
- Dashboard con consultas minimizadas y vista explicita de consentimiento/provenance.
- Despliegue centralizado preparado para red confiable, TLS y aislamiento de trafico.

### Excluido
- Certificacion formal completa Gaia-X de produccion.
- Integracion total con todo el stack de federation services.
- DID/VC en produccion si bloquea el MVP.
- Gobierno multi-regional o multi-tenant avanzado.

## Actores
1. Ciudadano/paciente: autoriza o revoca uso de datos.
2. Proveedor de datos: publica recursos FHIR validados.
3. Consumidor autorizado: solicita y consume datos bajo consentimiento vigente.
4. Operador del despliegue: ejecuta y observa la plataforma.
5. Dashboard: visualiza solo el subconjunto autorizado y minimizado.

## Flujos Funcionales
### F1 - Publicacion controlada
1. El provider recibe un bundle FHIR.
2. Se valida contra esquema y perfil.
3. Se adjuntan metadatos de soberania.
4. El recurso se publica solo si la validacion es satisfactoria.

### F2 - Consentimiento y acceso
1. El consumidor solicita acceso con proposito y contexto de identidad.
2. El trust-service evalua consentimiento vigente.
3. Si la politica permite, se emite autorizacion.
4. Si no, se deniega con trazabilidad.

### F3 - Visualizacion minimizada
1. El dashboard consulta un subconjunto minimo de datos.
2. El sistema evita exponer campos no necesarios.
3. El paciente puede ver que datos se muestran y bajo que consentimiento.

### F4 - Despliegue soberano
1. El stack se levanta en un entorno centralizado controlado.
2. Se aislan traficos internos y secretos.
3. Se mantiene trazabilidad de solicitudes y decisiones.

## Requisitos Funcionales
- RF-01: validar FHIR antes de cualquier procesamiento.
- RF-02: impedir almacenamiento o consumo sin consentimiento vigente.
- RF-03: representar el motivo y la base del permiso o rechazo.
- RF-04: minimizar los datos que llegan al dashboard.
- RF-05: exponer metadatos de soberania por dataset o recurso.
- RF-06: mantener trazabilidad de decisiones y accesos.
- RF-07: preservar el flujo E2E del MVP.

## Criterios de Aceptacion
1. Un payload FHIR invalido se rechaza en provider antes de persistirse.
2. Un acceso sin consentimiento no llega a consumer ni al dashboard.
3. El dashboard muestra solo datos minimizados y el estado de consentimiento.
4. El despliegue centralizado funciona con variables de entorno y red segregada.
5. Las pruebas E2E y de contrato siguen pasando tras endurecer el stack.

## Riesgos
1. Aumentar la complejidad de la demo si se intenta cubrir demasiado alcance Gaia-X en una sola iteracion.
2. Introducir friccion si el consentimiento granular se modela demasiado pronto sin persistencia.
3. Romper la trazabilidad si se mezclan politicas, validacion y presentacion en una sola capa.

## Preguntas Pendientes
1. ¿El PEP debe bloquear en consumer, en provider o en ambos?
2. ¿Se prioriza OIDC pragmatico en MVP o un esquema SIOP/VC parcial desde el inicio?
3. ¿El dashboard debe mostrar un detalle de consentimiento auditable o solo un resumen?

## Impacto por Proyecto
### Provider
- Validacion FHIR estricta.
- Metadatos de soberania.
- Respuesta rechazada si el recurso no cumple perfil.

### Trust-service
- Consentimiento granular.
- PDP de politica.
- Auditoria de decisiones.

### Consumer
- Propagacion de identidad y contexto.
- Bloqueo si el consentimiento no es valido.
- Consumo minimizado y trazable.

### Dashboard
- Lectura minimizada.
- Transparencia sobre consentimiento.
- Visualizacion de provenance y estado de acceso.

### Deployment
- Red confiable.
- TLS y secretos.
- Orquestacion reproducible para defensa y pruebas.
