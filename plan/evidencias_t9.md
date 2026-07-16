# Evidencias T-9: Validacion E2E y auditoria tecnica

## Fecha UTC
- 20260227T123717Z

## Estado de contenedores
```
NAME          IMAGE                              COMMAND                  SERVICE    CREATED          STATUS                    PORTS
gx-consumer   tfg-enrique-mora-gaia-x-consumer   "java -jar /app/app.…"   consumer   19 minutes ago   Up 18 minutes (healthy)   0.0.0.0:8083->8080/tcp, [::]:8083->8080/tcp
gx-provider   tfg-enrique-mora-gaia-x-provider   "java -jar /app/app.…"   provider   19 minutes ago   Up 18 minutes (healthy)   0.0.0.0:8081->8080/tcp, [::]:8081->8080/tcp
gx-trust      tfg-enrique-mora-gaia-x-trust      "java -jar /app/app.…"   trust      19 minutes ago   Up 18 minutes (healthy)   0.0.0.0:8082->8080/tcp, [::]:8082->8080/tcp
```

## Healthchecks
- provider (8081): {"groups":["liveness","readiness"],"status":"UP"}
- trust (8082): {"groups":["liveness","readiness"],"status":"UP"}
- consumer (8083): {"groups":["liveness","readiness"],"status":"UP"}

## Trazabilidad por paso
1. Publicacion dataset (provider)
- RequestId: req-t9-publish-20260227T123717Z
- HTTP: 201
- Response: {"datasetId":"ds-bp-20260227T123717Z","status":"PUBLISHED","publishedAt":"2026-02-27T12:37:17.410637049Z"}

2. Listado dataset (provider)
- RequestId: req-t9-list-20260227T123717Z
- HTTP: 200
- Response (resumen): {"total":1,"first":{"datasetId":"ds-bp-20260227T123717Z","clinicalCase":"heart-rate","status":"PUBLISHED","publishedAt":"2026-02-27T12:37:17.410637049Z"}}

3. Solicitud de acceso (trust)
- RequestId: req-t9-access-20260227T123717Z
- HTTP: 201
- Response: {"requestId":"ar-77afad26","status":"PENDING","createdAt":"2026-02-27T12:37:17.498763024Z"}

4. Resolucion de solicitud (trust)
- RequestId: req-t9-access-get-20260227T123717Z
- HTTP: 200
- Response: {"requestId":"ar-77afad26","datasetId":"ds-bp-20260227T123717Z","consumerId":"consumer-a","status":"APPROVED","decisionReason":"role-scope-purpose-match","decidedAt":"2026-02-27T12:37:17.519140746Z"}

5. Validacion de politica (trust)
- RequestId: req-t9-policy-20260227T123717Z
- HTTP: 200
- Response: {"allowed":true,"policyId":"policy-001","reason":"role-scope-purpose-match"}

6. Inicio de consumo (consumer)
- RequestId: req-t9-job-20260227T123717Z
- HTTP: 202
- Response: {"jobId":"cj-6b030867","status":"RUNNING","startedAt":"2026-02-27T12:37:17.601554431Z"}

7. Estado final de consumo (consumer)
- RequestId: req-t9-job-get-20260227T123717Z
- HTTP: 200
- Response: {"jobId":"cj-6b030867","status":"SUCCEEDED","datasetId":"ds-bp-20260227T123717Z","recordsProcessed":10000,"finishedAt":"2026-02-27T12:37:17.678144211Z"}

## IDs de correlacion
- datasetId: ds-bp-20260227T123717Z
- accessRequestId: ar-77afad26
- jobId: cj-6b030867

## Metricas HTTP (actuator)
- provider http.server.requests COUNT: 115.0
- trust http.server.requests COUNT: 117.0
- consumer http.server.requests COUNT: 115.0

## Conclusiones
- Flujo E2E completado sin errores criticos.
- Trazabilidad disponible por RequestId e IDs de negocio.
- Evidencia tecnica documentada para defensa.
