const fs = require('fs');
const path = require('path');

const DIR = '/home/emora/IdeaProjects/TFG/tfg-enrique-mora-rodriguez-gaiax/documentacion/postman';
const API_URL = 'http://localhost:3000/api/fhir/Bundle';

async function loadBundles() {
    // Only get the standard bundle files, ignore the .sinteticos ones
    const files = fs.readdirSync(DIR).filter(f => f.startsWith('multipleFhirBundle.part-') && !f.endsWith('.sinteticos.json') && f.endsWith('.json'));
    
    console.log(`Found ${files.length} bundle files to process.`);
    
    let successCount = 0;
    let errorCount = 0;

    for (const file of files) {
        console.log(`\nProcessing bundle: ${file}`);
        const filePath = path.join(DIR, file);
        const data = fs.readFileSync(filePath, 'utf8');
        
        try {
            const response = await fetch(API_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/fhir+json'
                },
                body: data
            });

            if (response.ok) {
                successCount++;
                console.log(`Success loading ${file}`);
            } else {
                const err = await response.text();
                console.error(`Error loading ${file}: HTTP ${response.status} - ${err}`);
                errorCount++;
            }
        } catch (err) {
            console.error(`Fetch error for ${file}: ${err.message}`);
            errorCount++;
        }
    }

    console.log(`\nFinished loading FHIR bundles. Success: ${successCount}, Errors: ${errorCount}`);
}

loadBundles().catch(console.error);
