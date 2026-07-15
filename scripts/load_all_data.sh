#!/bin/bash
set -e

# Movernos al directorio raíz del proyecto
cd "$(dirname "$0")/.."

echo "=========================================="
echo " Cargando datos locales en Gaia-X Health"
echo "=========================================="

# 1. Verificar si el contenedor de PostgreSQL está corriendo
if ! docker ps | grep -q "postgres-1"; then
    echo "Error: El contenedor de PostgreSQL no está en ejecución."
    echo "Asegúrate de haber levantado el entorno con 'docker compose up -d' primero."
    exit 1
fi

echo "[1/4] Cargando Proveedores de Salud y Médicos..."
cat gaiax-health-deployment/seed_proveedores.sql | docker exec -i gaiax-health-deployment-postgres-1 psql -U gaiax -d gaiax_health > /dev/null 2>&1

echo "[2/4] Cargando Paciente Estático de Prueba..."
cat gaiax-health-deployment/seed.sql | docker exec -i gaiax-health-deployment-postgres-1 psql -U gaiax -d gaiax_health > /dev/null 2>&1

echo "[3/4] Generando e inyectando pacientes relacionales (Historial)..."
node scripts/generate_clinical_history_seed.js
cat gaiax-health-deployment/seed_all_patients.sql | docker exec -i gaiax-health-deployment-postgres-1 psql -U gaiax -d gaiax_health > /dev/null 2>&1

echo "[4/4] Ingestando Bundles FHIR al Provider Node (Dashboard)..."
# Verificar disponibilidad de la API
echo "  Esperando a que la API esté lista (max 30s)..."
for i in {1..15}; do
  if curl -s http://localhost:3000/api/health/provider > /dev/null; then
      break
  fi
  sleep 2
done

# Enviar los 8 bundles originales
for i in {01..08}; do
  echo -n "  Enviando Bundle part-$i... "
  curl -s -X POST http://localhost:3000/api/fhir/Bundle \
    -H "Content-Type: application/json" \
    -d @documentacion/postman/multipleFhirBundle.part-$i.json \
    -o /dev/null \
    -w "HTTP %{http_code}\n"
done

echo "=========================================="
echo " ¡Carga de datos completada con éxito!"
echo " Puedes abrir http://localhost:3000"
echo "=========================================="
