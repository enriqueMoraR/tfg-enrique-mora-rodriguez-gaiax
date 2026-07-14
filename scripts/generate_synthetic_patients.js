const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const postmanDir = path.join(__dirname, '../documentacion/postman');
const files = [
    'multipleFhirBundle.part-01.json',
    'multipleFhirBundle.part-02.json',
    'multipleFhirBundle.part-03.json',
    'multipleFhirBundle.part-04.json',
    'multipleFhirBundle.part-05.json',
    'multipleFhirBundle.part-06.json',
    'multipleFhirBundle.part-07.json',
    'multipleFhirBundle.part-08.json'
];

function uuid() {
    return crypto.randomUUID();
}

function randomChoice(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

function generateNIF() {
    const num = Math.floor(Math.random() * 100000000).toString().padStart(8, '0');
    const letters = "TRWAGMYFPDXBNJZSQVHLCKE";
    return num + letters[parseInt(num, 10) % 23];
}

function calculateAge(birthDate) {
    const dob = new Date(birthDate);
    const diff_ms = Date.now() - dob.getTime();
    const age_dt = new Date(diff_ms);
    return Math.abs(age_dt.getUTCFullYear() - 1970);
}

function getAntecedentes(age) {
    const allAntecedentes = [
        { tipo: 'Familiares', descripcion: 'Antecedentes de hipertensión paterna', cie_10: 'I10' },
        { tipo: 'Familiares', descripcion: 'Diabetes materna', cie_10: 'E11.9' },
        { tipo: 'Personales', descripcion: 'Alergia a la penicilina', cie_10: 'Z88.0' },
        { tipo: 'Sociales', descripcion: 'Fumador ocasional', cie_10: 'F17.200' },
        { tipo: 'Personales', descripcion: 'Operación de apendicitis en la infancia', cie_10: 'Z98.8' },
        { tipo: 'Personales', descripcion: 'Asma en la infancia', cie_10: 'J45.9' },
        { tipo: 'Familiares', descripcion: 'Madre con osteoporosis', cie_10: 'M81.0' },
        { tipo: 'Personales', descripcion: 'Colesterol alto hace 5 años', cie_10: 'E78.0' }
    ];

    const antecedents = [];
    // 30% chance of having no antecedents
    if (Math.random() < 0.3) {
        return [{
            id_antecedente: uuid(),
            tipo: 'Personales',
            descripcion: 'Sin antecedentes relevantes',
            fecha_inicio: new Date(Date.now() - 365 * 24 * 60 * 60 * 1000).toISOString(),
            es_activo: true,
            cie_10: 'Z00.0'
        }];
    }

    // Give 1 to 3 random antecedents
    const num = Math.floor(Math.random() * 3) + 1;
    for (let i = 0; i < num; i++) {
        const choice = allAntecedentes[Math.floor(Math.random() * allAntecedentes.length)];
        // Avoid exact duplicates
        if (!antecedents.find(a => a.descripcion === choice.descripcion)) {
            const pastYears = Math.floor(Math.random() * 20) + 1;
            antecedents.push({
                id_antecedente: uuid(),
                tipo: choice.tipo,
                descripcion: choice.descripcion,
                fecha_inicio: new Date(Date.now() - pastYears * 365 * 24 * 60 * 60 * 1000).toISOString(),
                es_activo: Math.random() > 0.5,
                cie_10: choice.cie_10
            });
        }
    }
    return antecedents;
}

function getDiagnosisAndTreatment(age) {
    if (age <= 12) {
        return randomChoice([
            { diag: 'Asma', cie10: 'J45.9', trat: 'Salbutamol', indic: 'A demanda', dosis: '100mcg' },
            { diag: 'Varicela', cie10: 'B01.9', trat: 'Paracetamol', indic: 'Para la fiebre', dosis: '1g' },
            { diag: 'Otitis', cie10: 'H66.9', trat: 'Amoxicilina', indic: 'Cada 8 horas', dosis: '500mg' }
        ]);
    } else if (age <= 30) {
        return randomChoice([
            { diag: 'Gastroenteritis', cie10: 'A09', trat: 'Suero oral', indic: 'Hidratación', dosis: 'A demanda' },
            { diag: 'Migraña', cie10: 'G43.9', trat: 'Ibuprofeno', indic: 'Inicio de síntomas', dosis: '400mg' },
            { diag: 'Ansiedad', cie10: 'F41.9', trat: 'Lorazepam', indic: 'En crisis', dosis: '1mg' }
        ]);
    } else if (age <= 50) {
        return randomChoice([
            { diag: 'Hipertensión', cie10: 'I10', trat: 'Enalapril', indic: 'Diaria', dosis: '20mg' },
            { diag: 'Diabetes tipo 2', cie10: 'E11.9', trat: 'Metformina', indic: 'Con comidas', dosis: '850mg' }
        ]);
    } else {
        return randomChoice([
            { diag: 'Osteoporosis', cie10: 'M81.0', trat: 'Ácido Alendrónico', indic: 'Semanal', dosis: '70mg' },
            { diag: 'Enfermedad coronaria', cie10: 'I25.1', trat: 'Aspirina', indic: 'Diaria', dosis: '100mg' },
            { diag: 'EPOC', cie10: 'J44.9', trat: 'Tiotropio', indic: 'Diaria', dosis: '2.5mcg' }
        ]);
    }
}

function processFile(filename) {
    const inputPath = path.join(postmanDir, filename);
    const outputPath = path.join(postmanDir, filename.replace('.json', '.sinteticos.json'));
    
    if (!fs.existsSync(inputPath)) {
        console.log(`Archivo no encontrado: ${inputPath}`);
        return;
    }

    const data = JSON.parse(fs.readFileSync(inputPath, 'utf8'));
    const patients = data.entry.filter(e => e.resource.resourceType === 'Patient').map(e => e.resource);
    
    const syntheticPatients = patients.map((p, index) => {
        const age = calculateAge(p.birthDate);
        const condition = getDiagnosisAndTreatment(age);
        
        const name = p.name && p.name[0] ? `${p.name[0].given ? p.name[0].given.join(' ') : ''} ${p.name[0].family || ''}`.trim() : `Paciente ${index}`;
        
        const now = new Date().toISOString();
        const past = new Date(Date.now() - 365 * 24 * 60 * 60 * 1000).toISOString();
        const future = new Date(Date.now() + 5 * 365 * 24 * 60 * 60 * 1000).toISOString();

        return {
            id_paciente: p.id || uuid(),
            nif_dni: generateNIF(),
            nombre_completo: name,
            fecha_nacimiento: p.birthDate,
            genero: p.gender || 'unknown',
            grupo_sanguineo: randomChoice(['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']),
            nacionalidad: 'Española',
            telefono: '+346000000' + Math.floor(Math.random() * 10).toString(),
            email: `paciente.${p.id}@example.com`,
            direccion_fisica: 'Dirección ficticia ' + Math.floor(Math.random() * 100),
            id_seguro_social: 'ES' + Math.floor(Math.random() * 100000000).toString().padStart(8, '0'),
            estado_activo: true,
            historial: {
                id_historial: uuid(),
                fecha_creacion: past,
                fecha_ultima_actualizacion: now,
                version_fhir: '4.0.1',
                estado: true,
                filiacion: [
                    {
                        id_filiacion: uuid(),
                        comunidad_autonoma: 'Madrid',
                        centro_asignado: 'CS Central',
                        nivel_socieconomico: 'Medio',
                        idioma_preferido: 'es'
                    }
                ],
                antecedentes: getAntecedentes(age),
                diagnosticos: [
                    {
                        id_diagnostico: uuid(),
                        cie_10: condition.cie10,
                        cie_11: 'Desconocido',
                        descripcion: condition.diag,
                        fecha_diagnostico: past,
                        fecha_resolucion: null,
                        severidad: 'Moderada'
                    }
                ],
                tratamientos: [
                    {
                        id_tratamiento: uuid(),
                        nombre_tratamiento: `Tratamiento para ${condition.diag}`,
                        indicaciones: condition.indic,
                        fecha_inicio: past,
                        fecha_fin: null,
                        es_activado: true,
                        frecuencia: 'Diaria',
                        medicaciones: [
                            {
                                id_medicacion: uuid(),
                                nombre_comercial: condition.trat,
                                principio_activo: condition.trat,
                                dosis: condition.dosis,
                                via_administracion: 'Oral',
                                frecuencia: 'Diaria',
                                fecha_inicio: past,
                                fecha_fin: null,
                                es_alergia: false
                            }
                        ]
                    }
                ],
                informes: [
                    {
                        id_informe: uuid(),
                        tipo: 'Resumen',
                        formato: 'PDF',
                        uri_documento: `https://pacs.example.com/reports/${p.id}`,
                        fecha_emision: now,
                        id_medico_autor: uuid(),
                        resumen_clinico: `Paciente evaluado por ${condition.diag}.`
                    }
                ],
                pruebas: [
                    {
                        id_prueba: uuid(),
                        tipo: 'Analitica',
                        resultado: 'Dentro de parámetros normales',
                        observaciones: 'Revisión anual',
                        fecha_realizacion: now,
                        uri_imagen: `https://pacs.example.com/images/${p.id}`,
                        codigo_loinc: '24356-8'
                    }
                ]
            },
            dispositivos: [
                {
                    id_dispositivo: uuid(),
                    tipo: 'Wearable',
                    modelo: 'SmartBand',
                    fabricante: 'HealthCorp',
                    fecha_instalacion: past,
                    conectado: true,
                    lecturas: [
                        {
                            id_lectura: uuid(),
                            valor: 60 + Math.random() * 40,
                            unidad: 'bpm',
                            timestamp: now,
                            calidad_dato: 'Alta'
                        }
                    ]
                }
            ],
            consentimientos: [
                {
                    id_consentimiento: uuid(),
                    id_proposito: uuid(),
                    fecha_inicio: past,
                    fecha_expiracion: future,
                    estado: 'Activo',
                    ambitos_consentidos: 'Tratamiento médico',
                    id_dominio_gaia_fk: uuid(),
                    firma_digital: 'sig_' + crypto.randomBytes(8).toString('hex')
                }
            ],
            auditorias: [
                {
                    id_audit: uuid(),
                    id_usuario_acceso: uuid(),
                    accion: 'Leer',
                    timestamp: now,
                    motivo_acceso: 'Consulta ordinaria',
                    ip_origen: '192.168.1.100',
                    resultado: 'Exitoso'
                }
            ]
        };
    });

    fs.writeFileSync(outputPath, JSON.stringify(syntheticPatients, null, 2));
    console.log(`Generado: ${outputPath} con ${syntheticPatients.length} pacientes.`);
}

files.forEach(processFile);
