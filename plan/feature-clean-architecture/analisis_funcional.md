# Feature: clean-architecture

## Contexto
El repositorio ya funciona y cubre el flujo funcional del TFG, pero la estructura interna de varios módulos mezcla responsabilidades de API, lógica de negocio e infraestructura. Esta feature no introduce funcionalidad nueva para el usuario final. Su objetivo es reordenar el código para mejorar mantenibilidad, testabilidad y claridad arquitectónica.

## Objetivo funcional
Separar la solución en capas coherentes:
- `api`: entrada/salida HTTP y DTOs.
- `application`: casos de uso y orquestación.
- `domain`: reglas de negocio y modelos puros.
- `infrastructure`: persistencia, clientes externos y adaptadores técnicos.

En el frontend, reorganizar la aplicación por `features` para que cada funcionalidad tenga su propio contexto de UI, lógica y servicios auxiliares.

## Alcance funcional
1. Backend:
   - `provider`, `trust` y `consumer` adoptan una estructura por capas homogénea.
   - Los controladores dejan de contener lógica de negocio.
   - Las reglas de negocio se concentran en `domain` y `application`.
   - Las dependencias técnicas quedan aisladas en `infrastructure`.
2. Frontend:
   - El dashboard pasa de una estructura plana a una estructura por `features`.
   - Pacientes, mediciones y analítica quedan agrupadas por contexto funcional.
   - Los componentes de presentación reciben datos ya preparados.
3. Calidad:
   - La nueva estructura facilita tests unitarios sobre dominio y casos de uso.
   - La UI queda más predecible y más fácil de extender.

## Fuera de alcance
1. No cambia el comportamiento funcional visible del sistema.
2. No introduce nuevos contratos API públicos.
3. No altera el flujo E2E Gaia-X/FHIR ya validado.
4. No sustituye Spring Boot ni React/Vite.

## Casos de uso impactados
1. Publicación de datasets FHIR.
2. Solicitud y validación de acceso.
3. Consumo autorizado de datos.
4. Consulta y visualización en dashboard.
5. Analítica clínica sobre observaciones FHIR.

## Criterios de aceptacion
1. Cada backend expone claramente `api`, `application`, `domain` e `infrastructure`.
2. La lógica de negocio deja de residir en controllers o clientes HTTP.
3. El dashboard se organiza por `features` y no por carpetas genéricas sin contexto.
4. Las pruebas siguen pasando sin modificar el comportamiento público.
5. La refactorización queda documentada y trazable en el plan.

## Riesgos funcionales
1. Refactorizar capas sin cambiar contratos visibles puede ocultar regresiones si no se cubre bien con tests.
2. Una separación excesiva puede introducir sobrecarga innecesaria en un TFG si no se limita a los puntos de mayor valor.
3. La reestructuración del frontend puede generar roturas internas si no se migra por feature y no de golpe.

## Impacto esperado
- Mantenibilidad superior.
- Menor acoplamiento entre framework y dominio.
- Mejor testabilidad de reglas de negocio.
- Evolución más simple hacia una arquitectura limpia real.

