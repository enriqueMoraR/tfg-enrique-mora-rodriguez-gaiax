# Informe T-10: Pruebas de carga

## Fecha UTC
- 20260427T170834Z

## Setup de datos
- datasetId: ds-load-20260427T170834Z
- accessRequestId: ar-353f077d
- consumptionJobId: cj-a7302084

## Escenarios versionados
1. provider_list | GET | /api/v1/datasets?clinicalCase=heart-rate&status=PUBLISHED
2. trust_policy  | POST | /api/v1/policies/validate
3. consumer_job_status | GET | /api/v1/consumption-jobs/{jobId}
Perfiles:
- baseline: requests=300, concurrency=10
- scaled: requests=1200, concurrency=40

## Resultados
| Escenario | Perfil | Requests | Concurrency | Total | OK | Error % | p50 ms | p95 ms | p99 ms | Throughput req/s | Duracion s |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| provider_list | baseline | 300 | 10 | 300 | 300 | 0 | 00 | 19 | 33 | 57 | 173 |
| provider_list | scaled | 1200 | 40 | 1200 | 1200 | 0 | 00 | 18 | 32 | 50 | 144 |
| trust_policy | baseline | 300 | 10 | 300 | 300 | 0 | 00 | 19 | 25 | 27 | 181 |
| trust_policy | scaled | 1200 | 40 | 1200 | 1200 | 0 | 00 | 17 | 21 | 28 | 176 |
| consumer_job_status | baseline | 300 | 10 | 300 | 300 | 0 | 00 | 19 | 25 | 28 | 177 |
| consumer_job_status | scaled | 1200 | 40 | 1200 | 1200 | 0 | 00 | 16 | 23 | 29 | 173 |

## Recursos (snapshot post-ejecucion por escenario/perfil)
### consumer_job_status_baseline.docker_stats.txt
```
gx-provider,0.14%,231.2MiB / 31.24GiB,1MB / 961kB,0B / 49.2kB
gx-trust,0.12%,256.2MiB / 31.24GiB,1.24MB / 811kB,0B / 49.2kB
gx-consumer,0.09%,242.7MiB / 31.24GiB,204kB / 187kB,0B / 49.2kB
```
### consumer_job_status_scaled.docker_stats.txt
```
gx-provider,0.11%,231MiB / 31.24GiB,1MB / 961kB,0B / 49.2kB
gx-trust,0.09%,256.2MiB / 31.24GiB,1.24MB / 811kB,0B / 49.2kB
gx-consumer,0.09%,248.6MiB / 31.24GiB,982kB / 928kB,0B / 49.2kB
```
### provider_list_baseline.docker_stats.txt
```
gx-provider,0.20%,222.8MiB / 31.24GiB,209kB / 193kB,0B / 32.8kB
gx-trust,0.11%,237MiB / 31.24GiB,9.89kB / 2.58kB,0B / 32.8kB
gx-consumer,0.25%,239.3MiB / 31.24GiB,9.21kB / 1.91kB,0B / 32.8kB
```
### provider_list_scaled.docker_stats.txt
```
gx-provider,0.11%,231.2MiB / 31.24GiB,1MB / 961kB,0B / 32.8kB
gx-trust,0.07%,237MiB / 31.24GiB,9.93kB / 2.62kB,0B / 32.8kB
gx-consumer,0.11%,239.3MiB / 31.24GiB,9.25kB / 1.95kB,0B / 32.8kB
```
### trust_policy_baseline.docker_stats.txt
```
gx-provider,0.11%,231.2MiB / 31.24GiB,1MB / 961kB,0B / 32.8kB
gx-trust,0.13%,240.7MiB / 31.24GiB,257kB / 164kB,0B / 32.8kB
gx-consumer,0.09%,239.3MiB / 31.24GiB,9.25kB / 1.95kB,0B / 32.8kB
```
### trust_policy_scaled.docker_stats.txt
```
gx-provider,0.12%,230.9MiB / 31.24GiB,1MB / 961kB,0B / 49.2kB
gx-trust,0.11%,256.4MiB / 31.24GiB,1.24MB / 811kB,0B / 49.2kB
gx-consumer,0.10%,239.3MiB / 31.24GiB,9.53kB / 1.95kB,0B / 49.2kB
```

## Recomendaciones
- Mantener el perfil baseline como umbral minimo en CI de performance.
- Si el throughput cae >20% en scaled o sube error rate, revisar limites de hilos y pooling HTTP.
- Para siguiente iteracion, añadir pruebas de escritura concurrente de publish/access y tracing distribuido.
