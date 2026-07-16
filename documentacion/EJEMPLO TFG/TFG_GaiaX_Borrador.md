# UNIVERSIDAD DE CASTILLA-LA MANCHA
## ESCUELA SUPERIOR DE INFORMÁTICA

## GRADO EN INGENIERÍA EN INFORMÁTICA

# Creación de un espacio de datos Gaia-X

**Autor/a:** Enrique Mora Rodriguez

**Tutor/a académico/a:** Félix Jesús Villanueva Molina

**Cotutor/a académico/a:** [NOMBRE Y APELLIDOS, si aplica]

**Curso académico:** 2025/2026

**Fecha de defensa:** julio de 2026

---

## Resumen

El presente trabajo tiene como objetivo crear un espacio de datos basado en el estándar Gaia-X y generar una serie de pruebas de carga para estudiar su escalabilidad. Para ello se ha configurado y desplegado una arquitectura distribuida mediante microservicios, orientada al intercambio privado de datos con estrictas medidas de seguridad.

La solución se apoya en una infraestructura compuesta por varios nodos y un orquestador de despliegue, empleando tecnologías como Kubernetes, Docker, Java y Python. Sobre esta base se ha implementado un flujo funcional que permite publicar datos, solicitar acceso, autorizar o denegar su uso y analizar posteriormente el comportamiento del sistema bajo carga.

El proyecto sigue una aproximación iterativa, en la que primero se analizan distintas implementaciones y alternativas de Gaia-X, después se configura la red distribuida de nodos, más tarde se diseñan e implementan pruebas de escalabilidad y, finalmente, se estudian los resultados obtenidos. De esta forma, el trabajo combina una demostración técnica reproducible con una evaluación cuantitativa de prestaciones.

**Texto pendiente de completar o ajustar:** [RESUMEN FINAL DEL TFG]

**Palabras clave:** Gaia-X, espacio de datos, microservicios, escalabilidad, Docker, Kubernetes.

## Abstract

This undergraduate dissertation aims to create a Gaia-X-based data space and develop load tests to study its scalability. To do so, a distributed architecture has been configured and deployed through microservices, with the goal of enabling private data sharing under strict security measures.

The solution relies on an infrastructure composed of several nodes and a deployment orchestrator, using technologies such as Kubernetes, Docker, Java and Python. On top of this foundation, a functional flow has been implemented to publish data, request access, approve or deny its use, and analyse the system behaviour under load.

The project follows an iterative approach: first, different Gaia-X implementations and alternatives are analysed; then, the distributed node network is deployed; afterwards, scalability tests are designed and implemented; and finally, the obtained results are evaluated. In this way, the work combines a reproducible technical demonstration with a quantitative performance assessment.

**Pending text to complete or refine:** [FINAL ABSTRACT]

**Keywords:** Gaia-X, data space, microservices, scalability, Docker, Kubernetes.

## Agradecimientos

Agradezco a mi tutor, Félix Jesús Villanueva Molina, el acompañamiento y las observaciones realizadas durante el desarrollo del trabajo. También agradezco el apoyo recibido durante la fase de implementación, pruebas y documentación, así como la ayuda de las personas que han revisado el prototipo y han contribuido a mejorar su claridad técnica y su presentación académica.

## Índice general

> [INSERTAR ÍNDICE AUTOMÁTICO EN WORD / ACTUALIZAR CAMPOS]

---

# 1. Introducción

## 1.1. Descripción del proyecto

Este proyecto parte de una idea sencilla: no basta con almacenar datos, sino que también hay que decidir cómo se comparten, con qué garantías y bajo qué condiciones. A partir de esa premisa, el trabajo plantea la creación de un espacio de datos basado en Gaia-X, aplicado al dominio de salud, donde la interoperabilidad, la soberanía y la trazabilidad no sean elementos decorativos, sino parte central de la arquitectura.

La propuesta no se limita a desplegar servicios de forma aislada. El objetivo es construir un entorno funcional en el que un proveedor pueda publicar información clínica estructurada, un servicio de confianza pueda evaluar si ese acceso está permitido, un consumidor pueda recuperar solo los datos autorizados y una interfaz de visualización permita interpretar el resultado de forma clara. Todo ello se apoya en una base tecnológica reproducible y en una serie de pruebas que permiten estudiar el comportamiento del sistema cuando aumenta la carga.

El alcance del proyecto combina, por tanto, tres capas complementarias. En primer lugar, una capa de datos e interoperabilidad, apoyada en HL7 FHIR y en el tratamiento de recursos clínicos reales. En segundo lugar, una capa de gobernanza, donde se modela el consentimiento y el control de acceso. Y, en tercer lugar, una capa de validación experimental, orientada a medir estabilidad, rendimiento y escalabilidad. La intención final es disponer de un prototipo sólido, entendible y defendible académicamente, que sirva como base para evoluciones posteriores más cercanas a un despliegue Gaia-X completo.

## 1.2. Objetivos

### Objetivo general

Diseñar e implementar un espacio de datos sanitario compatible con los principios de Gaia-X Health, capaz de publicar, autorizar y consumir información clínica de forma soberana.

### Objetivos específicos

- Publicar datasets clínicos estructurados en HL7 FHIR.
- Controlar el acceso mediante políticas y consentimiento.
- Minimizar la exposición de datos sensibles en el dashboard.
- Disponer de una arquitectura reproducible con Docker y/o Kubernetes.
- Ejecutar pruebas de carga y analizar la escalabilidad del sistema.

Los objetivos quedan alineados con el alcance finalmente ejecutado y con la memoria preparada para defensa.

## 1.3. Estructura del documento

Este documento se organiza en los siguientes capítulos:

1. Introducción.
2. Antecedentes y fundamentos teóricos.
3. Herramientas y metodología de trabajo.
4. Análisis, diseño e implementación.
5. Resultados, validación y evaluación.
6. Conclusiones y trabajo futuro.

## 1.4. Contribuciones

Las contribuciones principales de este trabajo son:

- Un prototipo funcional de espacio de datos Gaia-X Health.
- Un contrato de consentimiento y soberanía para el flujo de datos.
- Una capa de validación FHIR y minimización de exposición de datos.
- Una interfaz de visualización clínica para demo y defensa.
- Un escenario de pruebas para medir rendimiento y estabilidad.

---

# 2. Antecedentes y fundamentos teóricos

## 2.1. Antecedentes

El concepto de espacio de datos surge como respuesta a una limitación recurrente en los ecosistemas digitales: el valor de la información aumenta cuando se comparte, pero las organizaciones necesitan mantener el control sobre el uso, la trazabilidad y las condiciones de acceso. Frente al enfoque de repositorio centralizado, los espacios de datos proponen una infraestructura federada en la que cada participante conserva la soberanía sobre sus recursos y participa mediante políticas comunes, catálogos y mecanismos de confianza verificables [13], [14].

En este contexto, Gaia-X se presenta como uno de los marcos europeos de referencia para estructurar ese intercambio soberano. La documentación oficial de la iniciativa insiste en una arquitectura distribuida, interoperable y basada en reglas compartidas, donde la identidad federada, la trazabilidad y el control de acceso son componentes estructurales y no elementos accesorios [1], [2]. En el material específico sobre salud, la propuesta se refuerza con el uso de catálogos de datos y servicios, así como con la necesidad de que el intercambio esté gobernado por políticas explícitas de confianza, uso permitido y responsabilidad [14].

La interoperabilidad sanitaria aporta un segundo antecedente esencial. En este ámbito, HL7 FHIR se ha consolidado como el estándar de facto para representar y transportar información clínica estructurada de forma uniforme, especialmente cuando se requiere integrar sistemas heterogéneos o exponer recursos mediante servicios web. Su valor no reside solo en el formato de los datos, sino también en los mecanismos normalizados de búsqueda, validación y fragmentación de la información, que permiten minimizar la exposición de datos sensibles y adaptar la respuesta al caso de uso concreto [3], [5], [6].

Dentro del ecosistema FHIR, el modelo International Patient Summary (IPS) resulta especialmente relevante para este trabajo. IPS define un resumen clínico mínimo y reutilizable, pensado para trasladar la información esencial de un paciente entre dominios o jurisdicciones sin necesidad de exponer toda su historia clínica. Esta aproximación encaja con proyectos que buscan un equilibrio entre utilidad clínica, minimización de datos y portabilidad semántica, ya que permite conservar únicamente los elementos necesarios para la continuidad asistencial [4].

Desde la perspectiva de soberanía de datos, estos antecedentes convergen en una idea central: compartir no debe equivaler a renunciar al control. En salud, esta exigencia se traduce en decisiones explícitas sobre consentimiento, propósito, receptor, duración del acceso y trazabilidad de cada operación. Por ello, cualquier arquitectura alineada con Gaia-X y con interoperabilidad sanitaria debe incorporar controles de política, identidad federada y evidencia auditable que permitan demostrar quién accede a qué datos, con qué finalidad y bajo qué condiciones [1], [13], [14].

En síntesis, los antecedentes revisados justifican tres decisiones de diseño para este proyecto: adoptar un marco federado de espacio de datos como base de intercambio, normalizar la información clínica sobre HL7 FHIR/IPS para garantizar interoperabilidad y minimizar la exposición de datos, y construir la gobernanza sobre principios de soberanía, consentimiento y trazabilidad. Estos tres ejes constituyen el fundamento teórico del desarrollo posterior.

## 2.2. Gaia-X, espacios de datos y soberanía

Se describirá el concepto de espacio de datos, el papel de Gaia-X y la relación con los principios de soberanía, portabilidad, trazabilidad y confianza federada.

Gaia-X surge como un marco europeo para coordinar el intercambio de datos y servicios sin sustituir la propiedad de los activos por un repositorio centralizado. Su aportación principal no es solo tecnológica, sino también de gobernanza: introduce reglas compartidas, catálogos, mecanismos de verificación y principios de soberanía que permiten a cada participante decidir qué datos comparte, con quién, durante cuánto tiempo y bajo qué condiciones [1], [2], [13], [14].

En un espacio de datos, el valor proviene de la interoperabilidad entre organizaciones heterogéneas y no de la concentración de la información. Por ello, el diseño se apoya en identidades verificables, trazabilidad de acceso, políticas de uso y una semántica común para los recursos intercambiados. Este enfoque resulta especialmente relevante en salud, donde los datos tienen un alto valor asistencial y, al mismo tiempo, un nivel elevado de sensibilidad jurídica y ética.

El proyecto adopta esta visión como base conceptual: la publicación de datos no equivale a cesión de control, sino a exposición regulada mediante contratos y políticas. De este modo, el flujo entre proveedor, servicio de confianza y consumidor puede auditarse y restringirse sin necesidad de duplicar la información en sistemas intermedios.

## 2.3. Interoperabilidad sanitaria: HL7 FHIR e IPS

La interoperabilidad sanitaria exige un modelo común de representación clínica que permita integrar fuentes heterogéneas sin perder significado. HL7 FHIR se ha consolidado como estándar de referencia para este objetivo porque define recursos estructurados, mecanismos de validación y patrones de consulta adecuados para integraciones modernas sobre HTTP [3], [5], [6]. En este trabajo, el recurso `Observation` se utiliza como unidad principal para representar constantes vitales y mediciones de monitorización.

La estrategia de implementación no se limita a almacenar el recurso, sino que preserva sus metadatos clínicos y de soberanía para que el resto de componentes pueda trabajar sobre un contexto clínico completo. Esto incluye perfiles FHIR, etiquetas de gobernanza y relaciones con `Patient`, `Encounter`, `Device` y `performer`. Además, la búsqueda y exposición de datos se orienta a minimizar el volumen transferido, siguiendo las capacidades de consulta selectiva de FHIR y los principios de reducción de exposición descritos en la especificación [5], [6].

Como antecedente conceptual para la visualización clínica, el modelo IPS resulta útil porque propone un resumen mínimo y reutilizable del estado del paciente. Aunque el proyecto no pretende sustituir una historia clínica completa, sí adopta la lógica de resumen clínico reducido para ofrecer en el dashboard solo la información necesaria para la demostración y para el análisis de escalabilidad [4].

## 2.4. Identidad federada y control de acceso

La identidad federada constituye el segundo eje de la gobernanza en un espacio de datos. En lugar de autenticación local aislada por servicio, el sistema debe apoyarse en identidades verificables y en decisiones de autorización desacopladas del transporte de datos. En esta memoria, ese principio se materializa como un flujo donde la autorización depende del consentimiento, del propósito, del receptor y de la vigencia temporal del permiso [1], [13], [16].

El control de acceso se modela como una combinación de evaluación de políticas y punto de ejecución de políticas. En términos prácticos, el servicio de confianza decide si una petición es admisible, mientras que los servicios de publicación y consumo actúan como puntos de control que solo permiten avanzar cuando la política resultante es favorable. Este patrón facilita la trazabilidad, reduce la exposición accidental y hace explícita la responsabilidad de cada nodo en el flujo de datos.

El proyecto mantiene esta línea de diseño como base de evolución hacia una identidad federada más completa. La versión actual ya incorpora identificadores estables, trazabilidad por `X-Request-Id` y contratos de consentimiento, lo que permite preparar una transición posterior hacia mecanismos federados más estrictos sin rediseñar por completo el sistema.

## 2.5. Arquitectura distribuida y conectores

La arquitectura distribuida del proyecto se apoya en servicios desacoplados con responsabilidades claras: publicación, confianza/consentimiento, consumo y visualización. Esta separación responde a un principio básico de los espacios de datos federados: cada actor debe custodiar su parte del proceso y limitarse a compartir únicamente lo necesario para completar el caso de uso [1], [2], [13], [14].

En este marco, el conector federado se entiende como la capa que evita copias innecesarias de información y que permite operar con contratos de acceso y trazabilidad. Aunque la implementación actual del proyecto se basa en servicios HTTP y no en un conector industrial completo, la estructura lógica ya queda alineada con ese patrón: existe un proveedor de datos, un servicio de decisión y un consumidor que solo recibe el subconjunto autorizado.

Esta decisión permite defender el prototipo como una base técnicamente coherente para una futura incorporación de conectores específicos de Gaia-X o IDS, sin comprometer la reproducibilidad del MVP actual.

---

# 3. Herramientas y metodología de trabajo

## 3.1. Herramientas utilizadas

### 3.1.1. Lenguajes y frameworks

- Java 25
- Spring Boot
- TypeScript
- React
- Vite

Estas tecnologías cubren los dos planos del sistema: backend transaccional y frontend de visualización. Java y Spring Boot sostienen los servicios de publicación, confianza y consumo; TypeScript, React y Vite permiten construir una interfaz ligera, rápida y fácil de verificar durante la defensa.

### 3.1.2. Infraestructura y herramientas de desarrollo

- Docker / Docker Compose
- Kubernetes [si aplica]
- Maven
- Node.js / npm
- Git

La infraestructura local se basa en Docker Compose como mecanismo principal de despliegue reproducible. Kubernetes se mantiene como extensión futura para escenarios de escalado o demostración avanzada. Maven y npm se emplean para la construcción y ejecución de backend y frontend, respectivamente, mientras que Git garantiza la trazabilidad del trabajo y de las versiones del proyecto.

### 3.1.3. Datos y fixtures

- Payloads FHIR de prueba.
- Dataset de 10.000 eventos para escalabilidad.
- Snapshot de 20 pacientes precargados para la demo.

## 3.2. Metodología

La metodología adoptada es iterativa e incremental, con validación continua de cada bloque antes de integrarlo con el siguiente. El desarrollo se ha organizado en features y tareas, lo que permite documentar decisiones, validar resultados y mantener un historial de cambios comprensible tanto para revisión académica como para depuración técnica.

Esta forma de trabajo combina elementos de prototipado evolutivo y enfoque dirigido por especificaciones. Primero se define el alcance, después se formaliza el contrato técnico y, finalmente, se implementa y verifica cada pieza con pruebas reproducibles.

## 3.3. Planificación

La planificación del trabajo se divide, a alto nivel, en:

- Fase de análisis y diseño.
- Implementación de backend.
- Implementación de frontend.
- Endurecimiento y despliegue.
- Pruebas funcionales y de carga.
- Redacción y preparación de defensa.

La ejecución real del proyecto ha seguido un orden coherente con estas fases: primero se estableció la arquitectura base, después se cerraron los contratos de datos y políticas, más tarde se reforzó el sistema con pruebas y, por último, se completó la documentación de soporte para la defensa.

## 3.4. Estrategia de pruebas

La estrategia de pruebas combina cuatro niveles. En primer lugar, pruebas unitarias para validar la lógica de cada servicio. En segundo lugar, pruebas funcionales e integración para comprobar contratos, flujos de autorización y tratamiento de errores. En tercer lugar, pruebas E2E para verificar el recorrido completo entre publicación, consentimiento y consumo. Finalmente, pruebas de carga para medir latencia, throughput y tasa de error bajo condiciones controladas.

Los criterios de aceptación se basan en umbrales explícitos de rendimiento y en la compatibilidad de los recursos FHIR procesados. Esta aproximación permite presentar no solo un sistema que funciona, sino un sistema que demuestra su funcionamiento con evidencia cuantitativa.

---

# 4. Análisis, diseño e implementación

## 4.1. Requisitos del proyecto

### 4.1.1. Requisitos funcionales

- Publicación de datasets FHIR.
- Solicitud y evaluación de acceso.
- Consumo autorizado de datos.
- Visualización de pacientes y métricas.
- Trazabilidad y auditoría de eventos.

### 4.1.2. Requisitos no funcionales

- Escalabilidad.
- Seguridad.
- Trazabilidad.
- Reproducibilidad.
- Minimización de datos.

Los requisitos formales quedan alineados con el objetivo del TFG: un espacio de datos Gaia-X capaz de publicar información estructurada, controlar el acceso mediante políticas y consentimiento, ofrecer una visualización comprensible y demostrar estabilidad bajo carga.

## 4.2. Arquitectura del sistema

La arquitectura se compone de:

- `provider`: publicación y validación de datasets.
- `trust-service`: políticas, consentimiento y auditoría.
- `consumer`: consumo autorizado y procesamiento.
- `dashboard`: visualización y demo.
- `deployment`: orquestación y despliegue centralizado.

El flujo funcional es secuencial pero federado: el provider valida y publica, el trust-service decide, el consumer consume y transforma, y el dashboard presenta solo el subconjunto necesario. Esta división reduce acoplamiento, mejora la trazabilidad y facilita la evolución futura hacia una arquitectura de conectores más estricta.

A nivel interno, el backend se ha reorganizado siguiendo una separación de capas `api / application / domain / infrastructure` en los tres servicios principales. Esta decisión reduce el acoplamiento con Spring, aísla la lógica de negocio de los detalles de transporte y persistencia, y simplifica la evolución de cada servicio sin arrastrar dependencias innecesarias. En el frontend, la organización por `features` permite aislar la funcionalidad de pacientes y analítica sin mezclar la lógica de UI con el acceso a datos.

## 4.3. Diseño de datos y contratos

Se describirá:

- Modelo de metadatos del dataset.
- Contrato de consentimiento.
- Contratos API entre servicios.
- Estructuras FHIR principales.

El contrato de datos se apoya en recursos FHIR `Bundle` y `Observation`, metadatos de dataset con soberanía y un contrato de consentimiento que controla propósito, receptor y ventana temporal. Esta combinación permite separar el recurso clínico del contexto de gobernanza sin perder trazabilidad.

## 4.4. Implementación del provider

Se explicará la lógica de publicación, validación FHIR, metadatos de soberanía y almacenamiento interno.

El provider actúa como punto de entrada de datos clínicos. Valida la estructura FHIR, comprueba metadatos de soberanía, persiste el dataset y expone operaciones de consulta y listado. Además, conserva compatibilidad con los contratos actuales para no romper la demo ni los escenarios ya validados.

## 4.5. Implementación del trust-service

Se detallará el modelo de decisión de políticas, el consentimiento granular y la auditoría.

El trust-service implementa la evaluación de permisos como decisión de políticas y registra la evidencia de cada petición. Su función es impedir que un acceso continúe si el consentimiento no es válido o si la petición no cumple el propósito y el receptor esperados.

## 4.6. Implementación del consumer

Se explicará la solicitud de acceso, el consumo autorizado y la minimización del contexto transmitido.

El consumer solicita acceso, recibe la autorización y transforma la respuesta en un formato apto para consumo interno y para el dashboard. En la versión actual preserva contexto clínico suficiente para no perder provenance, pero sigue priorizando la minimización del dato visible.

## 4.7. Implementación del dashboard

Esta subsección describe una ampliación del dashboard elaborada con apoyo de Inteligencia Artificial y revisión manual posterior; se incluye como material complementario de visualización y no forma parte del núcleo experimental principal del TFG.

El dashboard funciona como capa de presentación y demo, pero su papel actual va más allá de una visualización estática. La navegación se organiza en vistas diferenciadas y la interfaz consume datos reales desde el stack FHIR para mostrar el estado actualizado del sistema. En la vista de pacientes, la tabla muestra un subconjunto de veinte registros por defecto para mantener la legibilidad, pero las métricas superiores se calculan sobre el conjunto completo cargado desde la API.

El buscador de pacientes también trabaja sobre todo el dataset disponible y no solo sobre el listado visible. Esto permite localizar cualquier paciente existente por ID y ofrecer un mensaje explícito tanto cuando el paciente se encuentra fuera de la vista inicial como cuando no existe ninguna coincidencia. Además, el indicador de conectividad con la FHIR API se mantiene con el mismo estilo visual, pero se ubica en una esquina discreta de la pantalla para no competir con el contenido principal.

En la parte analítica, el dashboard incorpora una nueva página de “Análisis de Mediciones” orientada a la exploración clínica de observaciones FHIR. Esta vista añade filtros por paciente, tipo de medición, sexo y edad, junto con tres modos de análisis: evolución temporal, distribución y comparación entre pacientes. También incluye exportación de la analítica en formato PNG y CSV, skeleton loaders durante la carga y mensajes claros cuando no existen datos para los filtros activos.

## 4.8. Despliegue e infraestructura

El despliegue centralizado se ejecuta mediante Docker Compose y separa claramente los servicios internos del punto de acceso público. Esta decisión garantiza reproducibilidad, simplifica la defensa y deja preparada la transición hacia un despliegue más robusto si se desea evolucionar el prototipo.

---

# 5. Resultados, validación y evaluación

## 5.1. Validación funcional

Se expondrá la validación del flujo extremo a extremo:

`publicación -> solicitud -> autorización -> consumo -> visualización`.

La validación funcional demuestra que el flujo completo opera de forma consistente con datasets FHIR reales y con control de acceso basado en consentimiento. El recorrido validado cubre tanto los casos clínicos base como la ampliación posterior con recursos `Observation` directos.

## 5.2. Validación técnica

Se describirán:

- tests unitarios
- tests funcionales
- tests de integración
- pruebas E2E

La matriz de validación técnica confirma que los servicios backend y el frontend superan las baterías de pruebas definidas, con verificación de contratos, tratamiento de errores y estabilidad funcional. En el estado actual del proyecto, la validación del dashboard queda reforzada con la nueva página de análisis clínico, el cálculo de métricas sobre el dataset completo, el buscador global por ID y la exportación de gráficos y datos filtrados.

En concreto, la suite del frontend se mantiene estable con `22` archivos de prueba ejecutados y `92` tests verdes, lo que da cobertura a la navegación principal, la capa de análisis, el buscador de pacientes, el comportamiento del estado de conexión con la FHIR API y la exportación de datos. Estos resultados permiten defender que la UI no solo es visualmente coherente, sino también funcionalmente consistente con los datos reales del sistema.

## 5.3. Pruebas de carga y escalabilidad

Se presentarán los escenarios de carga y los resultados de latencia, throughput y error rate.

Los escenarios de carga muestran que el sistema mantiene el rendimiento por encima de los umbrales definidos en el plan. En particular, el error rate permanece en valores nulos o despreciables, el throughput cumple el objetivo mínimo y la latencia p95 se mantiene muy por debajo del límite académico previsto.

## 5.4. Discusión de resultados

Se interpretarán los resultados obtenidos y se compararán con los objetivos iniciales.

La lectura global de resultados es positiva: el sistema cumple el objetivo académico de demostrar un espacio de datos Gaia-X funcional, reproducible y medible. Las limitaciones restantes no invalidan el prototipo, pero sí delimitan con claridad el paso que habría que dar para convertirlo en una solución de producción.

---

# 6. Conclusiones y trabajo futuro

## 6.1. Conclusiones

Este trabajo demuestra la viabilidad de un espacio de datos Gaia-X Health con control de acceso, soberanía y trazabilidad, manteniendo una base reproducible para evaluación académica.

La conclusión principal es que el enfoque federado permite construir una solución coherente con Gaia-X sin sacrificar la reproducibilidad que exige un TFG. El proyecto aporta una base técnica útil, una validación experimental razonable y una memoria documental suficiente para defender la decisión de arquitectura adoptada.

## 6.2. Trabajo futuro

Posibles líneas de evolución:

- Integración completa con conector federado.
- Identidad ciudadana avanzada.
- Más perfiles FHIR e IPS.
- Persistencia externa y auditoría inmutable.
- Escalado en Kubernetes con métricas comparativas.

Como trabajo futuro, la evolución natural sería profundizar en la identidad federada, incorporar un conector más cercano a los marcos Gaia-X/IDS y ampliar la cobertura clínica y de observabilidad. También sería razonable ejecutar una campaña de pruebas más extensa sobre una infraestructura orquestada con Kubernetes.

---

# Bibliografía

## 1. Referencias en formato APA 7

Gaia-X European Association for Data and Cloud AISBL. (n.d.). *Home*. Recuperado el 10 de junio de 2026, de https://gaia-x.eu/

Gaia-X European Association for Data and Cloud AISBL. (n.d.). *Developers*. Recuperado el 10 de junio de 2026, de https://gaia-x.eu/developers/

HL7 International. (n.d.). *FHIR v5.0.0 index*. Recuperado el 10 de junio de 2026, de https://www.hl7.org/fhir/

HL7 International. (2025). *International Patient Summary implementation guide* (Versión 2.0.0). Recuperado el 10 de junio de 2026, de https://www.hl7.org/fhir/uv/ips/

HL7 International. (n.d.). *Search*. Recuperado el 10 de junio de 2026, de https://build.fhir.org/search.html

HL7 International. (n.d.). *Validation*. Recuperado el 10 de junio de 2026, de https://build.fhir.org/validation.html

Docker Documentation. (n.d.). *Docker Compose*. Recuperado el 10 de junio de 2026, de https://docs.docker.com/compose/

Kubernetes Documentation. (n.d.). *Kubernetes documentation*. Recuperado el 10 de junio de 2026, de https://kubernetes.io/docs/home/

Spring. (n.d.). *Spring Boot*. Recuperado el 10 de junio de 2026, de https://spring.io/projects/spring-boot/

React. (n.d.). *React*. Recuperado el 10 de junio de 2026, de https://react.dev/

Vite. (n.d.). *Vite*. Recuperado el 10 de junio de 2026, de https://vite.dev/

Recharts. (n.d.). *Recharts*. Recuperado el 10 de junio de 2026, de https://recharts.org/en-US/

Gaia-X Hub Austria. (2023). *Building a dataspace: Technical overview* [White paper]. Documento consultado en `documentacion/WhitepaperGaiaX.pdf`.

Gaia-X Hub España. (2024). *Gaia X España: innovando desde la confianza* [Presentación]. Documento consultado en `documentacion/20240429-Presentación-Gaia-X-casos de uso-SALUD.pdf`.

Universidad de Castilla-La Mancha. (2026). *Creación de un espacio de datos Gaia-X* [Documento interno del proyecto].

Equipo del proyecto. (2026). *gaiax-health-deployment/docs/consent-contract.md* [Documento interno del proyecto].

## 2. Referencias en formato IEEE

[1] Gaia-X European Association for Data and Cloud AISBL, “Home,” [Online]. Available: https://gaia-x.eu/. [Accessed: Jun. 10, 2026].

[2] Gaia-X European Association for Data and Cloud AISBL, “Developers,” [Online]. Available: https://gaia-x.eu/developers/. [Accessed: Jun. 10, 2026].

[3] HL7 International, “FHIR v5.0.0 Index,” [Online]. Available: https://www.hl7.org/fhir/. [Accessed: Jun. 10, 2026].

[4] HL7 International, “International Patient Summary Implementation Guide v2.0.0,” [Online]. Available: https://www.hl7.org/fhir/uv/ips/. [Accessed: Jun. 10, 2026].

[5] HL7 International, “Search,” [Online]. Available: https://build.fhir.org/search.html. [Accessed: Jun. 10, 2026].

[6] HL7 International, “Validation,” [Online]. Available: https://build.fhir.org/validation.html. [Accessed: Jun. 10, 2026].

[7] Docker Documentation, “Docker Compose,” [Online]. Available: https://docs.docker.com/compose/. [Accessed: Jun. 10, 2026].

[8] Kubernetes Documentation, “Kubernetes documentation,” [Online]. Available: https://kubernetes.io/docs/home/. [Accessed: Jun. 10, 2026].

[9] Spring, “Spring Boot,” [Online]. Available: https://spring.io/projects/spring-boot/. [Accessed: Jun. 10, 2026].

[10] React, “React,” [Online]. Available: https://react.dev/. [Accessed: Jun. 10, 2026].

[11] Vite, “Vite,” [Online]. Available: https://vite.dev/. [Accessed: Jun. 10, 2026].

[12] Recharts, “Recharts,” [Online]. Available: https://recharts.org/en-US/. [Accessed: Jun. 10, 2026].

[13] Gaia-X Hub Austria, *Building a dataspace: Technical overview*, 2023. [White paper]. Document consultado en `documentacion/WhitepaperGaiaX.pdf`.

[14] Gaia-X Hub España, *Gaia X España: innovando desde la confianza*, 2024. [Presentación]. Document consultado en `documentacion/20240429-Presentación-Gaia-X-casos de uso-SALUD.pdf`.

[15] Universidad de Castilla-La Mancha, *Creación de un espacio de datos Gaia-X*, 2026. [Documento interno del proyecto].

[16] Equipo del proyecto, *gaiax-health-deployment/docs/consent-contract.md*, 2026. [Documento interno del proyecto].

---

# Anexos

## Anexo A. Configuración del despliegue

El despliegue centralizado del proyecto se ejecuta desde `gaiax-health-deployment`, que actúa como orquestador del stack completo. La solución se diseñó para levantar los cinco repositorios del ecosistema y mantener separada la red interna de servicios del punto de entrada público usado por la demostración.

### A.1. Topología de despliegue

El entorno actual queda compuesto por los siguientes servicios:

| Servicio | Rol | Puerto host | Puerto contenedor |
| --- | --- | --- | --- |
| `postgres` | Persistencia FHIR JSONB | `5432` | `5432` |
| `provider` | Publicación y validación de datasets FHIR | `8081` | `8081` |
| `trust` | Políticas, consentimiento y auditoría | `8082` | `8080` |
| `consumer` | Solicitud y consumo autorizado | `8083` | `8080` |
| `dashboard` | Visualización clínica y demo | `3000` | `80` |

Los servicios `postgres`, `provider`, `trust` y `consumer` se conectan a una red interna dedicada (`gaia-x-backend`) para aislar el tráfico entre nodos. El `dashboard` permanece fuera de esa red interna porque necesita consumir el endpoint del `provider` expuesto en el host para funcionar desde el navegador.

El orden efectivo de arranque del stack queda fijado como `postgres -> provider -> trust -> consumer -> dashboard`, apoyado en `depends_on` y en healthchecks encadenados. Esta secuencia evita que los servicios de negocio arranquen antes de que la base de datos y el provider estén listos.

### A.2. Configuración mínima

La puesta en marcha local se realiza con los siguientes pasos:

```bash
cd gaiax-health-deployment
cp .env.example .env
docker compose up -d --build
```

Una vez desplegado el stack, los puntos de acceso quedan disponibles en:

- `localhost:5432` para `postgres` (acceso interno del servicio)
- `http://localhost:8081` para `provider`
- `http://localhost:8082` para `trust`
- `http://localhost:8083` para `consumer`
- `http://localhost:3000` para `dashboard`

### A.3. Variables de entorno relevantes

La configuración por defecto introduce variables específicas para cada servicio:

- `GAIAX_DATA_JURISDICTION=ES`
- `GAIAX_POLICY_URI=https://gaiax-health.example/policies/default`
- `GAIAX_RECEIVER_DID=did:web:consumer.gaiax-health.local`
- `GAIAX_RETENTION_DAYS=30`
- `GAIAX_CONSENT_POLICY=consent-granular-v1`
- `GAIAX_TRUST_BASE_URL=http://trust:8080`
- `GAIAX_CONSUMER_DID=did:web:consumer.gaiax-health.local`
- `GAIAX_PURPOSE=research`

En el `dashboard`, la variable de compilación `VITE_FHIR_API_URL` se fija a `http://localhost:8081/api/fhir` para que el navegador pueda alcanzar el endpoint FHIR del `provider` publicado en el host. La interfaz ya no depende de datos precargados estáticos, sino de los recursos reales persistidos en PostgreSQL.

### A.4. Comprobaciones operativas

La verificación mínima del despliegue consiste en:

1. Ejecutar `docker compose ps` y comprobar que los contenedores están `healthy`.
2. Consultar los healthchecks:
   - `postgres` mediante `pg_isready` dentro del contenedor de `postgres`
   - `http://localhost:8081/actuator/health`
   - `http://localhost:8082/actuator/health`
   - `http://localhost:8083/actuator/health`
3. Abrir `http://localhost:3000` y validar que el dashboard carga la vista de pacientes reales y el estado de consentimiento.
4. Importar `documentacion/postman/gaiax-health-e2e.postman_collection.json` o revisar `POSTMAN.md` para ejecutar la ingesta, la consulta y la verificación.

### A.5. Documentación complementaria

El despliegue queda acompañado por:

- `docs/consent-contract.md`, donde se definen los campos mínimos del contrato de consentimiento y soberanía.
- `docs/version-matrix.md`, con la matriz de compatibilidad entre servicios.
- `docs/development-setup.md`, con notas de arranque local.
- `docs/troubleshooting.md`, con problemas habituales y solución.
- `documentacion/postman/gaiax-health-e2e.postman_collection.json`, con la colección importable de Postman para la prueba E2E.
- `POSTMAN.md`, con la guía de llamadas, cabeceras y endpoints.

Este anexo sirve como referencia de implementación para reproducir el entorno de defensa y para justificar la segregación de red, el control de puertos y la trazabilidad de configuración.

## Anexo B. Evidencias de pruebas

El proyecto ha sido validado mediante una combinación de pruebas unitarias, funcionales, E2E y pruebas de carga. Esta evidencia demuestra que la solución mantiene el flujo principal operativo mientras endurece el control de acceso, la minimización de datos y la trazabilidad.

### B.1. Validación funcional extremo a extremo

La evidencia de validación E2E recoge el flujo completo:

`publicación -> solicitud -> autorización -> consumo -> visualización`.

Se ha comprobado que:

- `provider` publica datasets FHIR y rechaza metadatos de soberanía inválidos.
- `trust-service` evalúa consentimiento, propósito, receptor y ventana temporal.
- `consumer` consume únicamente cuando existe autorización válida y preserva el contexto de consentimiento.
- `dashboard` muestra la información mínima necesaria y expone el estado del consentimiento al usuario.

La evidencia detallada queda recogida en los artefactos de pruebas E2E del repositorio y en las salidas de validación generadas durante la ejecución.

### B.2. Validación técnica por servicio

Se han ejecutado las baterías de pruebas de los tres servicios backend:

- `gaiax-health-provider-node`: `13` tests, `BUILD SUCCESS`.
- `gaiax-health-trust-service`: `18` tests, `BUILD SUCCESS`.
- `gaiax-health-consumer-node`: `20` tests, `BUILD SUCCESS`.

En el frontend se han ejecutado las pruebas focalizadas relevantes:

- `gaiax-health-dashboard`: `19` tests pasados en la batería de `Dashboard`, `usePatientData` y `consumerService`.
- `gaiax-health-dashboard`: build de producción completado correctamente.

Estas pruebas cubren:

- validación FHIR de entrada,
- validación de consentimiento y políticas,
- propagación del contexto de identidad,
- minimización de consultas en el dashboard,
- cálculo de totales reales sobre el dataset completo,
- búsqueda de pacientes por ID en todo el conjunto cargado,
- exportación de la analítica a PNG y CSV,
- skeleton loaders y estados vacíos,
- y consistencia de la capa de presentación.

### B.3. Pruebas de carga y escalabilidad

El informe de carga muestra que el sistema mantiene estabilidad en escenarios baseline y escalados para las tres operaciones principales:

- listado de datasets,
- validación de políticas,
- consulta del estado de trabajos de consumo.

Los resultados más relevantes del baseline se mantienen dentro de los umbrales establecidos en el plan:

- `error rate = 0%`
- `p95 <= 500 ms`
- `throughput >= 120 req/s` en los escenarios más exigentes del conjunto de pruebas documentado

Además, el dashboard de analítica queda preparado para trabajar con varios miles de observaciones sin degradación perceptible en la experiencia principal, ya que la capa de adaptación FHIR separa el dataset completo de la vista resumida inicial y los cálculos pesados se concentran fuera del renderizado directo.

La evidencia detallada se recoge en los artefactos de pruebas de carga y en los informes de ejecución generados durante la validación.

### B.4. Lectura de resultados

Los resultados indican que el sistema:

1. Es funcionalmente coherente de extremo a extremo.
2. Mantiene la trazabilidad por `datasetId`, `accessRequestId` y `jobId`.
3. Reduce la exposición de información sensible sin romper la demo.
4. Calcula métricas globales sobre el dataset completo sin limitarse a los veinte registros visibles.
5. Permite localizar pacientes por ID en todo el conjunto cargado, incluso si no aparecen en la vista previa.
6. Conserva una base reproducible para defensa técnica y futuras iteraciones.

### B.5. Riesgos residuales

Aunque la solución es válida para la defensa y para una demostración técnica controlada, siguen existiendo limitaciones que conviene explicitar:

- La identidad federada se encuentra modelada y parcialmente integrada, pero no completa al nivel de un despliegue productivo Gaia-X.
- El conector federado real no está implantado; el intercambio sigue dependiendo de servicios HTTP del stack actual.
- El dashboard prioriza la demostración y la claridad visual frente a una experiencia clínica completa.
- Las pruebas de carga documentadas sirven como baseline académica, pero no sustituyen una campaña de rendimiento en infraestructura productiva.

### B.6. Conclusión del anexo

La evidencia de pruebas demuestra que el proyecto cumple el objetivo de montar un espacio de datos Gaia-X Health reproducible, con validación técnica suficiente para la defensa del TFG y con una base sólida para evolucionar hacia una certificación más estricta.

## Anexo C. Capturas de interfaz

Este anexo recogerá las capturas finales de la interfaz de usuario una vez cerrada la maquetación de la memoria. Las figuras asociadas al dashboard forman parte de material de apoyo elaborado con ayuda de Inteligencia Artificial y revisión manual posterior, y se incluyen como complemento visual fuera del núcleo experimental principal del TFG. Para mantener coherencia con el estado actual del proyecto, se recomienda incluir al menos las siguientes figuras:

- **Figura C.1.** Pantalla inicial del dashboard con navegación principal y resumen visual.
- **Figura C.2.** Tabla de pacientes precargados con acceso directo al detalle y buscador global por ID.
- **Figura C.3.** Vista unificada del paciente con metadatos clínicos, contexto FHIR y consentimiento.
- **Figura C.4.** Nueva página de “Análisis de Mediciones” con filtros, modos de visualización y estadísticas dinámicas.
- **Figura C.5.** Ejemplo de exportación de la analítica en CSV o PNG.
- **Figura C.6.** Estado vacío y skeleton loader durante la carga de datos.

Cada captura debe ir acompañada de un pie de figura breve que explique qué parte del flujo funcional está validando y qué dato se está mostrando.
