const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

// Directorio de los JSON
const postmanDir = path.join(__dirname, '../documentacion/postman');
const outputFile = path.join(__dirname, '../gaiax-health-deployment/seed_all_patients.sql');

// Función para recrear UUID.nameUUIDFromBytes de Java en Node.js
function javaNameUUIDFromBytes(name) {
    const hash = crypto.createHash('md5').update(name, 'utf8').digest();
    
    // Set version to 3
    hash[6] = (hash[6] & 0x0f) | 0x30;
    // Set variant to 2
    hash[8] = (hash[8] & 0x3f) | 0x80;

    const hex = hash.toString('hex');
    return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20, 32)}`;
}

// Proposito Global (el que usa el frontend para consultar)
const GLOBAL_PROPOSITO_ID = '770e8400-e29b-41d4-a716-446655440000';
const GLOBAL_MEDICO_ID = '330e8400-e29b-41d4-a716-446655440000';
const GLOBAL_PROVEEDOR_ID = '440e8400-e29b-41d4-a716-446655440000';

function extractPatients() {
    const patients = new Map();
    const files = fs.readdirSync(postmanDir).filter(f => f.endsWith('.json') && f.includes('FhirBundle'));

    for (const file of files) {
        const filePath = path.join(postmanDir, file);
        const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        
        if (data.entry) {
            for (const entry of data.entry) {
                if (entry.resource && entry.resource.resourceType === 'Patient') {
                    const id = entry.resource.id;
                    if (!patients.has(id)) {
                        const name = entry.resource.name?.[0];
                        const textName = name?.text || `${name?.given?.[0] || ''} ${name?.family || ''}`.trim() || id;
                        patients.set(id, {
                            fhirId: id,
                            dbUuid: javaNameUUIDFromBytes(id),
                            name: textName,
                            gender: entry.resource.gender || 'unknown',
                            birthDate: entry.resource.birthDate || '1980-01-01'
                        });
                    }
                }
            }
        }
    }
    return Array.from(patients.values());
}

const ENFERMEDADES = ['Hipertensión', 'Diabetes Mellitus Tipo 2', 'Asma Bronquial', 'Dislipidemia', 'Migraña', 'Artritis Reumatoide', 'Ansiedad Generalizada', 'Hipotiroidismo'];
const TRATAMIENTOS = ['Ibuprofeno 400mg', 'Paracetamol 1g', 'Metformina 850mg', 'Losartán 50mg', 'Salbutamol Inhalador', 'Atorvastatina 20mg', 'Levotiroxina 50mcg'];
const NOTAS = [
    'Paciente estable, continuar tratamiento actual.',
    'Revisión en 6 meses.',
    'Requiere análisis de sangre en la próxima visita.',
    'Presenta mejoría significativa respecto a la última consulta.',
    'Se ajusta dosis de medicación por efectos secundarios leves.'
];

function randomChoice(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

function generateSql(patients) {
    let sql = `
-- Carga masiva de historiales clínicos generada automáticamente
-- Incluye ${patients.length} pacientes

-- Asegurarse de tener un médico y proveedor global (ignorando errores si ya existen usando ON CONFLICT DO NOTHING, o asumiendo BBDD vacía)
INSERT INTO medico (id_medico, nif_dni, nombre_completo, especialidad, numero_colegiado, estado_activo) 
VALUES ('${GLOBAL_MEDICO_ID}', '00000000A', 'Dr. Global Gaia-X', 'Medicina General', 'COL-0000', true)
ON CONFLICT (id_medico) DO NOTHING;

INSERT INTO proveedor_salud (id_proveedor, nif_cif, nombre_institucion, tipo_institucion, direccion_principal, contacto_emergencia, estado_activo) 
VALUES ('${GLOBAL_PROVEEDOR_ID}', 'A00000000', 'Hospital Gaia-X', 'Hospital Público', 'Calle Principal 1, Gaia City', '+34 900 000 000', true)
ON CONFLICT (id_proveedor) DO NOTHING;

`;

    for (let i = 0; i < patients.length; i++) {
        const p = patients[i];
        const nifDni = `NIF-${i.toString().padStart(5, '0')}`;
        
        sql += `\n-- Paciente: ${p.fhirId} (${p.name})\n`;
        
        // 1. Paciente
        sql += `INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('${p.dbUuid}', '${nifDni}', '${p.name.replace(/'/g, "''")}', '${p.birthDate}', '${p.gender}', true)
ON CONFLICT (id_paciente) DO NOTHING;\n`;

        // 2. Historial Clínico
        const historialId = javaNameUUIDFromBytes(`historial-${p.fhirId}`);
        sql += `INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('${historialId}', '${p.dbUuid}', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;\n`;

        // 3. Consentimiento Global (para que la API pueda acceder)
        const consentimientoId = javaNameUUIDFromBytes(`consent-${p.fhirId}`);
        sql += `INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('${consentimientoId}', '${p.dbUuid}', '${GLOBAL_PROPOSITO_ID}', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;\n`;

        // 4. Diagnóstico Aleatorio
        const diagId = javaNameUUIDFromBytes(`diag-${p.fhirId}`);
        const enfermedad = randomChoice(ENFERMEDADES);
        sql += `INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('${diagId}', '${historialId}', 'X00', '${enfermedad}', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;\n`;

        // 5. Tratamiento Aleatorio
        const tratId = javaNameUUIDFromBytes(`trat-${p.fhirId}`);
        const medicacion = randomChoice(TRATAMIENTOS);
        const nota = randomChoice(NOTAS);
        sql += `WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('${tratId}', '${historialId}', '${medicacion}', '${nota}', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, '${medicacion.split(' ')[0]}', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;\n`;
    }

    fs.writeFileSync(outputFile, sql);
    console.log(`Generado ${outputFile} con ${patients.length} pacientes.`);
}

const patients = extractPatients();
generateSql(patients);
