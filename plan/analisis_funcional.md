# Fase 1 - Analisis funcional

## Contexto del proyecto
El objetivo del TFG es construir un espacio de datos Gaia-X en dominio salud y evaluar su escalabilidad con pruebas de carga.  
El repositorio parte de una base minima y ya dispone de datasets FHIR de prueba (incluyendo volumen de 10.000 eventos).

## Decision funcional confirmada
- Estrategia seleccionada: `EDC-first` (Eclipse Dataspace Components como base del MVP).
- Implementacion prevista con tres roles operativos: proveedor, servicio de confianza/compliance y consumidor.

## Objetivo funcional principal
Permitir el intercambio soberano y controlado de datos de salud entre participantes autorizados, con trazabilidad de uso y evidencia de rendimiento bajo carga.

## Alcance funcional del MVP
1. Publicacion de datasets clinicos FHIR en dos casos del MVP:
   - Caso 1: observaciones de tension arterial.
   - Caso 2: observaciones de frecuencia cardiaca.
2. Descubrimiento de datasets disponibles mediante catalogo.
3. Solicitud y concesion/rechazo de acceso segun politica.
4. Transferencia de datos entre participantes autorizados.
5. Registro de auditoria de operaciones clave.
6. Ejecucion de pruebas de carga con reporte final de metricas.

## Fuera de alcance del MVP
1. Produccion multi-region.
2. Cobertura de todos los casos clinicos del whitepaper (Alzheimer, prostata, retinopatia, etc.).
3. Federated Learning completo.
4. Integracion total con todos los servicios Gaia-X Federation Services.

## Actores y responsabilidades
1. Proveedor de datos:
   - Publica datasets y metadatos.
   - Define condiciones de uso iniciales.
2. Servicio de confianza/compliance:
   - Gestiona identidad y validacion de politicas.
   - Mantiene evidencias de auditoria.
3. Consumidor de datos:
   - Solicita acceso.
   - Consume datasets autorizados para analitica/casos de uso.
4. Operador tecnico:
   - Despliega, monitoriza y ejecuta pruebas de carga.

## Flujos funcionales
### Flujo F1 - Alta de participante
1. Se registra participante.
2. Se asigna rol.
3. Queda habilitado para sus operaciones permitidas.

### Flujo F2 - Publicacion de dataset
1. El proveedor registra metadatos del dataset.
2. Se valida formato minimo y politica asociada.
3. El dataset pasa a estado publicable en catalogo.

### Flujo F3 - Solicitud de acceso
1. El consumidor solicita un dataset con finalidad.
2. El servicio de confianza evalua reglas.
3. Se concede o deniega el acceso.
4. El resultado queda auditado.

### Flujo F4 - Consumo de datos
1. Si existe autorizacion valida, se transfiere el dataset.
2. El consumidor procesa el recurso.
3. Se registra trazabilidad de transaccion.

### Flujo F5 - Pruebas de carga
1. Se ejecutan escenarios concurrentes de publicacion/solicitud/consumo.
2. Se recogen metricas.
3. Se genera informe comparativo para decisiones de escalado.

## Requisitos funcionales
- RF-01: El sistema debe permitir publicar datasets FHIR.
- RF-02: El sistema debe permitir listar y consultar datasets del catalogo.
- RF-03: El sistema debe gestionar solicitudes de acceso con estado trazable.
- RF-04: El sistema debe aplicar politicas de acceso antes de transferir datos.
- RF-05: El sistema debe registrar auditoria de las operaciones criticas.
- RF-06: El sistema debe soportar pruebas con al menos 10.000 eventos.
- RF-07: El sistema debe exponer un flujo demostrable con al menos 3 participantes.

## Criterios de aceptacion del MVP
1. Flujo extremo a extremo operativo: publicacion -> solicitud -> autorizacion -> consumo.
2. Evidencia de control de acceso y auditoria en transacciones.
3. Escenario de carga ejecutado con resultados medidos (latencia, throughput, errores).
4. Arquitectura documentada y reproducible para defensa del TFG.

## KPIs de rendimiento confirmados (nivel exigente)
1. `error_rate <= 0.5%` en escenario baseline.
2. `p95 <= 500 ms` en operaciones criticas de API.
3. `throughput >= 120 req/s` en baseline.
4. Mantener estabilidad de servicio bajo carga concurrente sostenida.

## Propuesta funcional para README.md
El README debe explicar:
1. Problema y objetivo del espacio de datos.
2. Arquitectura de 3 proyectos IntelliJ (provider, trust/compliance, consumer).
3. Flujo funcional extremo a extremo.
4. Pasos de arranque local.
5. Escenarios de carga y como interpretar resultados.
6. Limites del MVP y roadmap.

## Riesgos funcionales
1. Alcance excesivo para un TFG si se intenta cubrir demasiados casos de uso.
2. Ambiguedad en politicas de acceso si no se fijan reglas minimas desde el inicio.
3. Desalineacion entre objetivo academico (evaluar escalabilidad) y complejidad de integraciones.

## Preguntas funcionales pendientes
1. Confirmar si el catalogo sera interno al conector en esta primera iteracion.

## Impactos por feature
### feature-cobertura-tests
- Objetivo: ampliar cobertura de calidad con pruebas unitarias, funcionales y de sistema basadas en datasets FHIR reales del repositorio.
- Alcance enlazado: `plan/feature-cobertura-tests/analisis_funcional.md`.
- Impacto esperado: mayor deteccion temprana de regresiones en validacion FHIR, autorizacion y consumo E2E.

### feature-dashboard-pacientes
- Objetivo: dashboard web interactivo para pacientes con busqueda, tabla precargada de 20 registros, visualizacion de mediciones y trazabilidad.
- Alcance enlazado: `plan/feature-dashboard-pacientes/analisis_funcional.md`.
- Impacto esperado: demo autonoma para defensa tecnica con datos visibles al cargar la pagina y seleccion rapida por clic, manteniendo la busqueda manual como fallback.

### feature-monorepo-to-polyrepo
- Objetivo: migrar la arquitectura actual de backend y frontend hacia repositorios independientes para cada servicio y un orquestador de despliegue.
- Alcance enlazado: `plan/feature-monorepo-to-polyrepo/analisis_funcional.md`.
- Impacto esperado: versionado independiente, pipelines aislados y despliegue local reproducible manteniendo los mismos contratos API.

### feature-gaiax-health-hardening
- Objetivo: endurecer el stack actual para que el flujo de datos sea compatible con Gaia-X Health y con un enfoque EDS/HL7 FHIR realmente controlado.
- Alcance enlazado: `plan/feature-gaiax-health-hardening/analisis_funcional.md`.
- Impacto esperado: validacion FHIR estricta, consentimiento granular, identidad federada, minimizacion de datos en dashboard y despliegue preparado para certificacion.

### feature-fhir-observation
- Objetivo: hacer compatible el stack con recursos `Observation` directos y metadatos de soberania/provenance sin romper el contrato actual basado en `Bundle`.
- Alcance enlazado: `plan/feature-fhir-observation/analisis_funcional.md`.
- Impacto esperado: reutilizacion de payloads FHIR reales, mayor fidelidad al dominio clinico y pruebas mas cercanas a produccion.

### feature-analisis-mediciones
- Objetivo: nueva pagina de analitica clinica exploratoria para visualizar tendencias, distribuciones, comparaciones y anomalías sobre observaciones FHIR.
- Alcance enlazado: `plan/feature-analisis-mediciones/analisis_funcional.md`.
- Impacto esperado: capa de visualizacion avanzada con filtros, estadisticas dinamicas y exportacion sobre bundles FHIR de volumen medio/alto.

### feature-clean-architecture
- Objetivo: reorganizar el backend en capas `api / application / domain / infrastructure` y ordenar el frontend por `features` sin cambiar el comportamiento funcional.
- Alcance enlazado: `plan/feature-clean-architecture/analisis_funcional.md`.
- Impacto esperado: mayor mantenibilidad, menor acoplamiento y mejor testabilidad de provider, trust, consumer y dashboard.
