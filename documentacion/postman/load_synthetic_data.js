const fs = require('fs');
const path = require('path');

const DIR = '/home/emora/IdeaProjects/TFG/tfg-enrique-mora-rodriguez-gaiax/documentacion/postman';
const API_URL = 'http://localhost:3000/api/v1/historial/init';

async function loadData() {
    const files = fs.readdirSync(DIR).filter(f => f.endsWith('.sinteticos.json'));
    
    console.log(`Found ${files.length} files to process.`);
    
    let successCount = 0;
    let errorCount = 0;

    for (const file of files) {
        console.log(`\nProcessing file: ${file}`);
        const filePath = path.join(DIR, file);
        const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        
        for (const p of data) {
            // Map snake_case to camelCase for the API request
            const requestBody = {
                fhirId: p.id_paciente,
                nifDni: p.nif_dni,
                nombreCompleto: p.nombre_completo,
                fechaNacimiento: p.fecha_nacimiento,
                genero: p.genero,
                diagnosticos: p.historial?.diagnosticos?.map(d => ({
                    cie10: d.cie_10,
                    descripcion: d.descripcion
                })) || [],
                tratamientos: p.historial?.tratamientos?.map(t => ({
                    nombreTratamiento: t.nombre_tratamiento,
                    indicaciones: t.indicaciones,
                    principioActivo: t.medicaciones && t.medicaciones.length > 0 ? t.medicaciones[0].principio_activo : 'No especificado'
                })) || [],
                filiacion: p.historial?.filiacion?.map(f => ({
                    comunidadAutonoma: f.comunidad_autonoma,
                    centroAsignado: f.centro_asignado,
                    nivelSocieconomico: f.nivel_socieconomico,
                    idiomaPreferido: f.idioma_preferido
                })) || [],
                antecedentes: p.historial?.antecedentes?.map(a => ({
                    tipo: a.tipo,
                    descripcion: a.descripcion,
                    fechaInicio: a.fecha_inicio,
                    esActivo: a.es_activo,
                    cie10: a.cie_10
                })) || [],
                dispositivos: p.dispositivos?.map(d => ({
                    tipo: d.tipo,
                    modelo: d.modelo,
                    fabricante: d.fabricante,
                    fechaInstalacion: d.fecha_instalacion,
                    conectado: d.conectado,
                    lecturas: d.lecturas?.map(l => ({
                        valor: l.valor,
                        unidad: l.unidad,
                        timestamp: l.timestamp,
                        calidadDato: l.calidad_dato
                    })) || []
                })) || []
            };

            try {
                const response = await fetch(API_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Proposito-ID': '770e8400-e29b-41d4-a716-446655440000',
                        'X-User-ID': 'system-loader'
                    },
                    body: JSON.stringify(requestBody)
                });

                if (response.ok) {
                    successCount++;
                    process.stdout.write('.');
                } else {
                    const err = await response.text();
                    console.error(`\nError loading ${p.id_paciente}: HTTP ${response.status} - ${err}`);
                    errorCount++;
                }
            } catch (err) {
                console.error(`\nFetch error for ${p.id_paciente}: ${err.message}`);
                errorCount++;
            }
        }
    }

    console.log(`\n\nFinished loading. Success: ${successCount}, Errors: ${errorCount}`);
}

loadData().catch(console.error);
