// gaiax-health-test.js
// Script de prueba de carga para el stack gaiax-health-deployment

import http from 'k6/http';
import { check, sleep, group } from 'k6';
import { Trend, Rate } from 'k6/metrics';

// --- Métricas Personalizadas ---
const patientSearchTime = new Trend('trend_patient_search_duration');
const fhirRequestTime = new Trend('trend_fhir_request_duration'); // Métrica para el tiempo de la petición principal
const errorRate = new Rate('rate_errors');

// --- Opciones de la Prueba ---
// Ajustadas para un stack de microservicios en local.
export const options = {
  stages: [
    { duration: '1m', target: 10 }, // Rampa suave a 10 usuarios virtuales (VUs)
    { duration: '3m', target: 25 }, // Sube la carga a 25 VUs
    { duration: '5m', target: 25 }, // Mantiene la carga durante 5 minutos
    { duration: '1m', target: 0 },  // Rampa de bajada
  ],
  thresholds: {
    // El 95% de las peticiones deben ser más rápidas de 2 segundos.
    'http_req_duration': ['p(95)<2000'],
    // Menos del 1% de las peticiones deben fallar.
    'http_req_failed': ['rate<0.01'],
  },
};

// --- URLs de los servicios (configurable via environment variables) ---
const PROVIDER_URL = __ENV.PROVIDER_URL || 'http://localhost:8081';
const TRUST_URL = __ENV.TRUST_URL || 'http://localhost:8082';
const CONSUMER_URL = __ENV.CONSUMER_URL || 'http://localhost:8083';
const DASHBOARD_URL = __ENV.DASHBOARD_URL || 'http://localhost:3000';
const FHIR_PATIENT_NAME = __ENV.FHIR_PATIENT_NAME || 'Test';

// --- Flujo de Usuario Virtual ---
export default function () {
  let patientId = null;

  // Grupo 1: Buscar un Paciente por nombre
  group('01_Search_Patient', function () {
    const res = http.get(`${DASHBOARD_URL}/api/fhir/Patient?name=${FHIR_PATIENT_NAME}`, {
      tags: { name: 'FHIR_Patient_Search' },
    });

    const success = check(res, {
      'FHIR request status is 200': (r) => r.status === 200,
      'Patient Search response is a Bundle': (r) => {
        if (r.status !== 200) return false; // No intentar parsear JSON si la petición falló
        const body = r.json();
        // Extraemos el ID del primer paciente encontrado para usarlo en el siguiente paso
        if (body && body.resourceType === 'Bundle' && body.total > 0) {
          patientId = body.entry[0].resource.id;
          return true;
        }
        return false;
      },
    });

    patientSearchTime.add(res.timings.duration);
    errorRate.add(!success);
  });

  // Solo continuar si encontramos un paciente en el paso anterior
  if (!patientId) {
    sleep(1);
    return;
  }

  sleep(1); // Simula el tiempo que el usuario tarda en hacer clic en el paciente

  // Grupo 2: Obtener las Observaciones para ese Paciente
  group('02_Get_Patient_Observations', function () {
    const res = http.get(`${DASHBOARD_URL}/api/fhir/Observation?subject=Patient/${patientId}`, {
      tags: { name: 'FHIR_Observation_Search' },
    });

    const success = check(res, {
      'Observation Search status is 200': (r) => r.status === 200,
      'Observation Search response is a Bundle': (r) => {
        if (r.status !== 200) return false;
        const body = r.json();
        return body && body.resourceType === 'Bundle';
      },
    });

    // Esta es ahora nuestra métrica principal, ya que representa el flujo completo
    fhirRequestTime.add(res.timings.duration); 
    errorRate.add(!success);
  });
}
