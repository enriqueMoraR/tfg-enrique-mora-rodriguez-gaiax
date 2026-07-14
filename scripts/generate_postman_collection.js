const fs = require('fs');
const path = require('path');

const postmanDir = path.join(__dirname, '../documentacion/postman');
const outputFile = path.join(postmanDir, 'gaiax_health_historial_collection.json');

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
    'Tomar una pastilla en el desayuno.',
    'Uso según necesidad para el dolor.',
    'Aplicar antes de dormir.',
    'Tomar con abundante agua.'
];

function randomChoice(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

function generateCollection(patients) {
    const items = [];

    for (let i = 0; i < patients.length; i++) {
        const p = patients[i];
        const nifDni = `NIF-${i.toString().padStart(5, '0')}`;
        
        const enfermedad = randomChoice(ENFERMEDADES);
        const medicacionInfo = randomChoice(TRATAMIENTOS);
        const principioActivo = medicacionInfo.split(' ')[0];
        
        const payload = {
            fhirId: p.fhirId,
            nifDni: nifDni,
            nombreCompleto: p.name,
            fechaNacimiento: p.birthDate,
            genero: p.gender,
            diagnosticos: [
                {
                    cie10: "X00",
                    descripcion: enfermedad
                }
            ],
            tratamientos: [
                {
                    nombreTratamiento: `Tratamiento para ${enfermedad}`,
                    indicaciones: randomChoice(NOTAS),
                    principioActivo: principioActivo
                }
            ]
        };

        const item = {
            name: `Init Historial - ${p.fhirId}`,
            request: {
                method: "POST",
                header: [
                    { "key": "Content-Type", "value": "application/json" }
                ],
                url: {
                    raw: "http://localhost:3000/api/v1/historial/init",
                    protocol: "http",
                    host: ["localhost"],
                    port: "3000",
                    path: ["api", "v1", "historial", "init"]
                },
                body: {
                    mode: "raw",
                    raw: JSON.stringify(payload, null, 2)
                }
            }
        };

        items.push(item);
    }

    const collection = {
        info: {
            name: "Gaia-X Health - Carga Historial Clínico",
            schema: "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
        },
        item: items
    };

    fs.writeFileSync(outputFile, JSON.stringify(collection, null, 2));
    console.log(`Colección generada con éxito en ${outputFile} con ${items.length} peticiones.`);
}

const patients = extractPatients();
generateCollection(patients);
