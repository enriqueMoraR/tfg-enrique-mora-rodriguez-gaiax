# Evidencia E2E - Gaia-X Health Hardening

## Fecha
- 2026-06-10

## Objetivo
Validar que el endurecimiento Gaia-X Health no rompe el flujo funcional y que la demo queda defendible con consentimiento, minimizacion y trazabilidad.

## Validaciones ejecutadas
- `gaiax-health-provider-node`: `mvn -Dmaven.repo.local=/tmp/m2 test`
  - Resultado: `BUILD SUCCESS`
  - Tests: `13`
- `gaiax-health-trust-service`: `mvn -Dmaven.repo.local=/tmp/m2 test`
  - Resultado: `BUILD SUCCESS`
  - Tests: `18`
- `gaiax-health-consumer-node`: `mvn -Dmaven.repo.local=/tmp/m2 test`
  - Resultado: `BUILD SUCCESS`
  - Tests: `20`
- `gaiax-health-dashboard`: `npm test -- --run src/tests/pages/Dashboard.test.tsx src/tests/hooks/usePatientData.test.tsx src/tests/services/consumerService.test.ts`
  - Resultado: `19 tests passed`
- `gaiax-health-dashboard`: `npm run build`
  - Resultado: `BUILD SUCCESS`
  - Aviso no bloqueante: chunk principal > 500 kB

## Evidencia funcional
- `provider` rechaza metadata de soberania incompleta o incoherente.
- `trust-service` rechaza ventanas de consentimiento vencidas y aprueba solo cuando identidad, proposito y scope encajan.
- `consumer` preserva el contexto de consentimiento, distingue vista resumen y vista detallada, y no expone datos sensibles en modo resumido.
- `dashboard` muestra el estado de consentimiento y provenance en la vista del paciente y usa consultas minimizadas.

## Conclusiones
- El flujo `provider -> trust -> consumer -> dashboard` se mantiene operativo a nivel funcional.
- La superficie de exposicion de datos ha sido reducida sin perder trazabilidad.
- El estado es defendible para demostracion tecnica; el siguiente paso recomendado es un smoke de despliegue completo en el entorno centralizado si se quiere reproducir el flujo con contenedores.
