
-- Carga masiva de historiales clínicos generada automáticamente
-- Incluye 200 pacientes

-- Asegurarse de tener un médico y proveedor global (ignorando errores si ya existen usando ON CONFLICT DO NOTHING, o asumiendo BBDD vacía)
INSERT INTO medico (id_medico, nif_dni, nombre_completo, especialidad, numero_colegiado, estado_activo) 
VALUES ('330e8400-e29b-41d4-a716-446655440000', '00000000A', 'Dr. Global Gaia-X', 'Medicina General', 'COL-0000', true)
ON CONFLICT (id_medico) DO NOTHING;

INSERT INTO proveedor_salud (id_proveedor, nif_cif, nombre_institucion, tipo_institucion, direccion_principal, contacto_emergencia, estado_activo) 
VALUES ('440e8400-e29b-41d4-a716-446655440000', 'A00000000', 'Hospital Gaia-X', 'Hospital Público', 'Calle Principal 1, Gaia City', '+34 900 000 000', true)
ON CONFLICT (id_proveedor) DO NOTHING;


-- Paciente: patient-gx-00001 (Juan García Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('b16462f5-e50b-313c-9fd7-f3a6d2ca5b90', 'NIF-00000', 'Juan García Muñoz', '1940-01-01', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('ac20afce-bb70-321f-a3d2-7277459e4735', 'b16462f5-e50b-313c-9fd7-f3a6d2ca5b90', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ffcc41e6-708d-37a6-b9d4-557b777c590c', 'b16462f5-e50b-313c-9fd7-f3a6d2ca5b90', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('0af14444-d644-3720-b268-9171a09b9404', 'ac20afce-bb70-321f-a3d2-7277459e4735', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('3c50a930-fa34-343b-84b9-41bfe12c434a', 'ac20afce-bb70-321f-a3d2-7277459e4735', 'Paracetamol 1g', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00002 (Carmen López Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('1dfca807-bc06-3c96-a4da-0f1c21335a16', 'NIF-00001', 'Carmen López Muñoz', '1941-02-02', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('b27914df-07ec-3722-914a-e624a73d3159', '1dfca807-bc06-3c96-a4da-0f1c21335a16', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('65bf2778-055f-3f4a-a761-7fbe2b2ac45f', '1dfca807-bc06-3c96-a4da-0f1c21335a16', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('29d40d95-c901-3548-b20d-94ee2f26a13e', 'b27914df-07ec-3722-914a-e624a73d3159', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('96a3aa74-8b46-3f9a-bed5-a04bb0d665d1', 'b27914df-07ec-3722-914a-e624a73d3159', 'Levotiroxina 50mcg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00003 (Miguel Martínez Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('dadf2dfd-0e8e-3fdc-ad10-e9fe43b8af3b', 'NIF-00002', 'Miguel Martínez Muñoz', '1942-03-03', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('c9b368c0-0ed7-3e9d-8095-64d58add1b41', 'dadf2dfd-0e8e-3fdc-ad10-e9fe43b8af3b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('21375dfa-1836-3872-b227-6c83b33eb341', 'dadf2dfd-0e8e-3fdc-ad10-e9fe43b8af3b', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('8f854abd-0111-3074-be64-354f0ead47b6', 'c9b368c0-0ed7-3e9d-8095-64d58add1b41', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('c09a0586-2ea2-38fe-af67-4022604a2307', 'c9b368c0-0ed7-3e9d-8095-64d58add1b41', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00004 (Ana Sánchez Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('00fec8a0-9d06-3793-8ca1-af74f6081d9c', 'NIF-00003', 'Ana Sánchez Muñoz', '1943-04-04', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('8c08c73d-e29e-3f95-a383-866fe0a51dbd', '00fec8a0-9d06-3793-8ca1-af74f6081d9c', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('cccb05b9-0642-37c8-8563-2901d0e8d701', '00fec8a0-9d06-3793-8ca1-af74f6081d9c', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('122fa9bc-a183-3e3f-a43a-a5160863e8af', '8c08c73d-e29e-3f95-a383-866fe0a51dbd', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('c516fa6f-f200-3978-908b-2983aade598e', '8c08c73d-e29e-3f95-a383-866fe0a51dbd', 'Ibuprofeno 400mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00005 (Pablo Pérez Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('c5ee75d6-1b4e-3ded-be11-0dfab9c917fe', 'NIF-00004', 'Pablo Pérez Muñoz', '1944-05-05', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('ad3b4280-daae-350b-8484-4f816d4a9be1', 'c5ee75d6-1b4e-3ded-be11-0dfab9c917fe', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('8052e92f-9cfc-30a1-9a8a-ba95b33ee699', 'c5ee75d6-1b4e-3ded-be11-0dfab9c917fe', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('ce90f240-6f08-34a9-8b3c-13df5cb66077', 'ad3b4280-daae-350b-8484-4f816d4a9be1', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('bcee2954-422b-32be-9167-6a96d47a68cc', 'ad3b4280-daae-350b-8484-4f816d4a9be1', 'Paracetamol 1g', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00006 (Laura Gómez Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('9977310a-8066-31cd-a43d-06dc28da61ac', 'NIF-00005', 'Laura Gómez Muñoz', '1945-06-06', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('76e2be98-e084-3747-90b9-d4f80d10f22c', '9977310a-8066-31cd-a43d-06dc28da61ac', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ab2dfe2f-18ca-3813-b4d5-f4da35c864f3', '9977310a-8066-31cd-a43d-06dc28da61ac', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('648962e8-0f25-3fb1-8c43-9a1f4a21c93f', '76e2be98-e084-3747-90b9-d4f80d10f22c', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('8a6679c5-64a4-3d83-8aad-fe6947e1bee0', '76e2be98-e084-3747-90b9-d4f80d10f22c', 'Ibuprofeno 400mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00007 (Andrés Fernández Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('6ec7b300-8cd8-317a-b8f6-7aab57e462cf', 'NIF-00006', 'Andrés Fernández Muñoz', '1946-07-07', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('4edb899a-561c-3191-b75f-8e80b9f9ad36', '6ec7b300-8cd8-317a-b8f6-7aab57e462cf', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('d3b66645-b10c-35ab-9e73-f5efbe415435', '6ec7b300-8cd8-317a-b8f6-7aab57e462cf', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('87ff0809-534e-3cb3-983e-40016d1c8233', '4edb899a-561c-3191-b75f-8e80b9f9ad36', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('028e2638-6db3-3627-b2c7-3b8b73423037', '4edb899a-561c-3191-b75f-8e80b9f9ad36', 'Paracetamol 1g', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00008 (Sofía Díaz Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('4bbfed4c-0321-337a-b873-66943a06ebd7', 'NIF-00007', 'Sofía Díaz Muñoz', '1947-08-08', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('5263cc7c-0e1e-3ea1-94c0-85fd725601a4', '4bbfed4c-0321-337a-b873-66943a06ebd7', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('27e03b77-2a46-355b-b452-7e7f433fe5f7', '4bbfed4c-0321-337a-b873-66943a06ebd7', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('6044ac27-c8e7-39a5-a164-ceb6ae1a6473', '5263cc7c-0e1e-3ea1-94c0-85fd725601a4', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('97ec4f28-c1bf-32d1-924a-13b2e0cd4f7f', '5263cc7c-0e1e-3ea1-94c0-85fd725601a4', 'Paracetamol 1g', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00009 (Álvaro Álvarez Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('9869758a-3e14-3ab4-9311-e18662b9a710', 'NIF-00008', 'Álvaro Álvarez Muñoz', '1948-09-09', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('18961725-0972-35b1-8a0a-81b7a4df8a41', '9869758a-3e14-3ab4-9311-e18662b9a710', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('cbe23262-696f-3074-9d30-5f9da04cd645', '9869758a-3e14-3ab4-9311-e18662b9a710', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('572fd4e4-0e0f-3f32-88d0-151945da27df', '18961725-0972-35b1-8a0a-81b7a4df8a41', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('572de9aa-08dd-3eb1-b7e6-001cd50bac67', '18961725-0972-35b1-8a0a-81b7a4df8a41', 'Levotiroxina 50mcg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00010 (Nuria Romero Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('17dab2d7-4a84-3a97-9a8f-458108b198e2', 'NIF-00009', 'Nuria Romero Muñoz', '1949-10-10', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('eca19b71-4c15-311e-8978-e4831f9e5f62', '17dab2d7-4a84-3a97-9a8f-458108b198e2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('f46f4a89-1a52-33ca-b015-4384df21b277', '17dab2d7-4a84-3a97-9a8f-458108b198e2', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('d351c214-807c-3e3d-a4a5-577472360b89', 'eca19b71-4c15-311e-8978-e4831f9e5f62', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('41e82471-dc88-3129-8a93-c0d4b2520654', 'eca19b71-4c15-311e-8978-e4831f9e5f62', 'Ibuprofeno 400mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00011 (Juan Navarro Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('94aab623-30f9-3ae5-9e69-9d214a70c849', 'NIF-00010', 'Juan Navarro Muñoz', '1950-11-11', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('aa6d5f4d-37b0-3abe-8dd5-f7821c83fba1', '94aab623-30f9-3ae5-9e69-9d214a70c849', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('7399241b-bc2d-3bcd-9aff-f7e81e589d53', '94aab623-30f9-3ae5-9e69-9d214a70c849', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('a1734875-f764-3d29-8731-0860fcb2e920', 'aa6d5f4d-37b0-3abe-8dd5-f7821c83fba1', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('335a23d7-3571-3706-864b-f65e7f4fa5c6', 'aa6d5f4d-37b0-3abe-8dd5-f7821c83fba1', 'Paracetamol 1g', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00012 (Carmen Torres Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('4d3164c0-5d1d-395d-806b-2625f4350d5f', 'NIF-00011', 'Carmen Torres Muñoz', '1951-12-12', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('72e06439-367e-30bb-8de6-553670e50bf8', '4d3164c0-5d1d-395d-806b-2625f4350d5f', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('39f304e8-d25e-331b-9cc4-074005dca99d', '4d3164c0-5d1d-395d-806b-2625f4350d5f', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('0599a819-dd85-3525-bed8-9c1d63aa772a', '72e06439-367e-30bb-8de6-553670e50bf8', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('162a8893-a851-3db1-98d3-783ec163383f', '72e06439-367e-30bb-8de6-553670e50bf8', 'Salbutamol Inhalador', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00013 (Miguel Ruiz Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('9143f95f-2915-348e-977c-df6f41ada638', 'NIF-00012', 'Miguel Ruiz Muñoz', '1952-01-13', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('9de65468-5771-3cb5-9222-577c2598fbf7', '9143f95f-2915-348e-977c-df6f41ada638', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('72ad1905-548c-36b9-8839-d8d2b2322462', '9143f95f-2915-348e-977c-df6f41ada638', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('08670643-4eb8-3fb1-aa95-7cd5fe04e6ea', '9de65468-5771-3cb5-9222-577c2598fbf7', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('429d7380-d892-3205-81b3-d11741d50392', '9de65468-5771-3cb5-9222-577c2598fbf7', 'Losartán 50mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00014 (Ana Vega Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('eaca4e4e-6918-3683-891c-0f8e05534ead', 'NIF-00013', 'Ana Vega Muñoz', '1953-02-14', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('d0637931-ae77-3bae-b41f-4e9f10af545d', 'eaca4e4e-6918-3683-891c-0f8e05534ead', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('b47ef4ae-fcdf-39ae-85c8-1dcd8a11feea', 'eaca4e4e-6918-3683-891c-0f8e05534ead', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('30f72f1a-2432-3cd5-90fa-da3d0874a19f', 'd0637931-ae77-3bae-b41f-4e9f10af545d', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('fba8cb23-2649-313a-b75a-5c054946a544', 'd0637931-ae77-3bae-b41f-4e9f10af545d', 'Paracetamol 1g', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00015 (Pablo Molina Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('43a26349-d332-37ff-b26a-70d60f9142c1', 'NIF-00014', 'Pablo Molina Muñoz', '1954-03-15', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('a7808ef8-d2ba-3729-8983-c678aeac3586', '43a26349-d332-37ff-b26a-70d60f9142c1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('51b50e13-f0a1-3297-ba14-ea29916bf034', '43a26349-d332-37ff-b26a-70d60f9142c1', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('227ce8f7-de62-3726-bf30-6ae6a3d093cd', 'a7808ef8-d2ba-3729-8983-c678aeac3586', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('aa2a88f3-76cf-31f0-a5b0-8049a6b61521', 'a7808ef8-d2ba-3729-8983-c678aeac3586', 'Levotiroxina 50mcg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00016 (Laura Ortega Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('260144c5-726b-3150-86fa-abb5eae1c655', 'NIF-00015', 'Laura Ortega Muñoz', '1955-04-16', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('5757170a-836f-3190-81fd-c94c29c0c485', '260144c5-726b-3150-86fa-abb5eae1c655', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('d5e39b5f-7a8b-3bbc-95ff-c3b4b095b486', '260144c5-726b-3150-86fa-abb5eae1c655', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('be52eba5-f23f-3f89-87c4-a243e927e8c7', '5757170a-836f-3190-81fd-c94c29c0c485', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('df4c8cba-b2a1-3fb0-9e75-67dbaa23726f', '5757170a-836f-3190-81fd-c94c29c0c485', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00017 (Andrés Castro Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('c72a473c-fc87-3db9-a2bf-76e744a2a6b0', 'NIF-00016', 'Andrés Castro Muñoz', '1956-05-17', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('95ee45f4-a42f-3c88-beb8-04cb923c1bfa', 'c72a473c-fc87-3db9-a2bf-76e744a2a6b0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('1782caab-22d1-3628-84e9-566cec0b5585', 'c72a473c-fc87-3db9-a2bf-76e744a2a6b0', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('e1d8f2fd-428d-36a6-b97e-c5348498cf92', '95ee45f4-a42f-3c88-beb8-04cb923c1bfa', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('56885e99-2d2a-3ab7-b42b-52779ff389e7', '95ee45f4-a42f-3c88-beb8-04cb923c1bfa', 'Ibuprofeno 400mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00018 (Sofía Delgado Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('c0af5cf9-f603-3b7c-8324-0256d7710c66', 'NIF-00017', 'Sofía Delgado Muñoz', '1957-06-18', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('7167e6bc-d481-3da5-8674-a04c70ad1f32', 'c0af5cf9-f603-3b7c-8324-0256d7710c66', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('07a9e66c-e79c-322a-a8b5-573e026014e7', 'c0af5cf9-f603-3b7c-8324-0256d7710c66', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('2bb60a58-9c38-30d7-9073-333c333b4b16', '7167e6bc-d481-3da5-8674-a04c70ad1f32', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('b70a355e-413c-34b0-a92e-c8224c508e5b', '7167e6bc-d481-3da5-8674-a04c70ad1f32', 'Atorvastatina 20mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00019 (Álvaro Serrano Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('f1d54463-89fd-351d-bba2-642542494140', 'NIF-00018', 'Álvaro Serrano Muñoz', '1958-07-19', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('7cb182cc-4dc9-30fb-af19-3fd9f4a87ef0', 'f1d54463-89fd-351d-bba2-642542494140', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ddc9ee8d-478e-33d2-9e80-bad752b53566', 'f1d54463-89fd-351d-bba2-642542494140', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('3139e938-5c24-38e2-bd1e-5f600a9676c3', '7cb182cc-4dc9-30fb-af19-3fd9f4a87ef0', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('bccf80a1-57cd-3327-9714-b95393c42424', '7cb182cc-4dc9-30fb-af19-3fd9f4a87ef0', 'Paracetamol 1g', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00020 (Nuria Cortés Muñoz)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('1190bd6a-70a7-366c-b490-f4ddbdf92fcb', 'NIF-00019', 'Nuria Cortés Muñoz', '1959-08-20', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('919765fc-9490-3949-a9cb-65675b86479d', '1190bd6a-70a7-366c-b490-f4ddbdf92fcb', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('08840f1e-ad19-3751-ad54-aea9e2e33a62', '1190bd6a-70a7-366c-b490-f4ddbdf92fcb', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('971fb4ce-c543-3290-8e81-5d9b9c0393cd', '919765fc-9490-3949-a9cb-65675b86479d', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('f121930c-6a11-3506-ae38-fad0c4f27388', '919765fc-9490-3949-a9cb-65675b86479d', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00021 (Juan García Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('1274f9b3-4e4f-3dc4-a0c6-a3d472930f0b', 'NIF-00020', 'Juan García Ramos', '1960-09-21', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('90a39716-100a-3c40-b7d4-9b45969a8f26', '1274f9b3-4e4f-3dc4-a0c6-a3d472930f0b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('e575a3c1-efff-3d6b-bea8-51126d227314', '1274f9b3-4e4f-3dc4-a0c6-a3d472930f0b', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('e0c2b72a-9e59-3f26-bb41-7aed06265414', '90a39716-100a-3c40-b7d4-9b45969a8f26', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('ce6bbbbc-074c-3b9e-bac1-52116cbaf893', '90a39716-100a-3c40-b7d4-9b45969a8f26', 'Atorvastatina 20mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00022 (Carmen López Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('98b1f957-241c-3902-a31a-941ea7136d2c', 'NIF-00021', 'Carmen López Ramos', '1961-10-22', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('904be57b-c593-3938-bf11-11a0794f66b6', '98b1f957-241c-3902-a31a-941ea7136d2c', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('e9c1aec6-2231-3f65-94f2-91116d23ae07', '98b1f957-241c-3902-a31a-941ea7136d2c', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('8dca1aa5-47d5-3e3a-9934-92f89985ecc7', '904be57b-c593-3938-bf11-11a0794f66b6', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('0c891331-3f66-3f95-a13a-5142f56ef224', '904be57b-c593-3938-bf11-11a0794f66b6', 'Salbutamol Inhalador', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00023 (Miguel Martínez Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('a76ea946-e1d0-30bc-a3ae-c89ff65bfcac', 'NIF-00022', 'Miguel Martínez Ramos', '1962-11-23', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('d5681d2e-001d-3e31-b221-b0f4c991a3e5', 'a76ea946-e1d0-30bc-a3ae-c89ff65bfcac', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('f00af8d2-6781-38a5-b92c-3debed0e6208', 'a76ea946-e1d0-30bc-a3ae-c89ff65bfcac', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('7e4c8e1d-0289-3fa4-9f78-4b6d855ebe12', 'd5681d2e-001d-3e31-b221-b0f4c991a3e5', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('9e70ae11-1683-3179-91ac-739ece8ba86b', 'd5681d2e-001d-3e31-b221-b0f4c991a3e5', 'Levotiroxina 50mcg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00024 (Ana Sánchez Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('1e7c91c6-713c-35a8-90c9-894fe6abf2c8', 'NIF-00023', 'Ana Sánchez Ramos', '1963-12-24', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('f60222d1-eb2e-31f3-95ca-ed286bce8157', '1e7c91c6-713c-35a8-90c9-894fe6abf2c8', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('8bc77817-f4b5-38d0-95d4-a80b9c7a86e1', '1e7c91c6-713c-35a8-90c9-894fe6abf2c8', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('884f1992-0c26-3e73-a368-db945e31357b', 'f60222d1-eb2e-31f3-95ca-ed286bce8157', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('4dca77ef-ac62-348f-aa86-54dbaafcc02e', 'f60222d1-eb2e-31f3-95ca-ed286bce8157', 'Paracetamol 1g', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00025 (Pablo Pérez Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('ff63c0dd-c6e0-3129-940f-8ae5763a6211', 'NIF-00024', 'Pablo Pérez Ramos', '1964-01-25', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('c2e7b338-a869-3782-bed2-dc3ef04fd658', 'ff63c0dd-c6e0-3129-940f-8ae5763a6211', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('1bc4cbb0-b37e-3d3d-8b16-8ce0e395f58b', 'ff63c0dd-c6e0-3129-940f-8ae5763a6211', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('b7dfdedd-83ef-3648-9a3c-6376e23cb7f9', 'c2e7b338-a869-3782-bed2-dc3ef04fd658', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('c289788f-51fd-3f2d-a967-1e941376d1ef', 'c2e7b338-a869-3782-bed2-dc3ef04fd658', 'Salbutamol Inhalador', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00026 (Laura Gómez Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('f67210d9-538e-324c-93e8-a558bccc46f3', 'NIF-00025', 'Laura Gómez Ramos', '1965-02-26', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('5425c0bb-d2c3-3cd8-ad50-67bab149ddeb', 'f67210d9-538e-324c-93e8-a558bccc46f3', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('3b13afbc-8365-3edc-9b25-562f81e0bc97', 'f67210d9-538e-324c-93e8-a558bccc46f3', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('d663149c-7f2b-3cd1-a34a-19623ead0d76', '5425c0bb-d2c3-3cd8-ad50-67bab149ddeb', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('5a88fb2d-be50-3a4b-b1ac-6ff9e6d87a20', '5425c0bb-d2c3-3cd8-ad50-67bab149ddeb', 'Levotiroxina 50mcg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00027 (Andrés Fernández Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('107d3f1c-7f78-3a51-83eb-7b858d2826c2', 'NIF-00026', 'Andrés Fernández Ramos', '1966-03-27', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('ba6d25be-d548-3b18-83c2-a52c3d67ec72', '107d3f1c-7f78-3a51-83eb-7b858d2826c2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('10480bfa-a484-3394-a3f5-d731f88cee0e', '107d3f1c-7f78-3a51-83eb-7b858d2826c2', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('e80580f4-4a66-3e0a-9763-3560730e46bf', 'ba6d25be-d548-3b18-83c2-a52c3d67ec72', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('dca0ba6b-b1e9-3d36-baa1-edad019836a0', 'ba6d25be-d548-3b18-83c2-a52c3d67ec72', 'Levotiroxina 50mcg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00028 (Sofía Díaz Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('8848b188-16fe-3cb2-ade7-421baf6b732b', 'NIF-00027', 'Sofía Díaz Ramos', '1967-04-28', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('e5bbc2a0-914c-3bf4-884e-7c8a45b6ae1a', '8848b188-16fe-3cb2-ade7-421baf6b732b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('b46446cb-1efc-326c-8f1f-89a338b9e3af', '8848b188-16fe-3cb2-ade7-421baf6b732b', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('be9b339f-4694-325e-9fc1-e148b7642183', 'e5bbc2a0-914c-3bf4-884e-7c8a45b6ae1a', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('03cb984f-ba58-34e7-a6fa-5b3335ce4b85', 'e5bbc2a0-914c-3bf4-884e-7c8a45b6ae1a', 'Ibuprofeno 400mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00029 (Álvaro Álvarez Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('8a052c04-5efd-32c2-bcdc-734f978983be', 'NIF-00028', 'Álvaro Álvarez Ramos', '1968-05-01', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('cd1bec17-8758-35fe-a886-7b3261639121', '8a052c04-5efd-32c2-bcdc-734f978983be', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('b60c5355-6aeb-30d4-a5b0-cf64998f53de', '8a052c04-5efd-32c2-bcdc-734f978983be', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('45bf2806-cf33-3bc9-8acb-1db3844ac333', 'cd1bec17-8758-35fe-a886-7b3261639121', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('00014ece-0538-334e-9167-328b9bedbce5', 'cd1bec17-8758-35fe-a886-7b3261639121', 'Levotiroxina 50mcg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00030 (Nuria Romero Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('53a5d759-b9b2-3fbb-9b4b-1260ebaee386', 'NIF-00029', 'Nuria Romero Ramos', '1969-06-02', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('97a6b34b-0783-363e-a039-40ae183c505b', '53a5d759-b9b2-3fbb-9b4b-1260ebaee386', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('90a23afc-eb8f-3095-ba51-e1220a9b5a97', '53a5d759-b9b2-3fbb-9b4b-1260ebaee386', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('fdccc034-bdbf-3535-8cdc-90f264ad3c34', '97a6b34b-0783-363e-a039-40ae183c505b', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('5446bb72-d858-3621-b403-415aaf127228', '97a6b34b-0783-363e-a039-40ae183c505b', 'Levotiroxina 50mcg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00031 (Juan Navarro Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('5ccca639-0cc8-31d9-bf38-55d0327a4c13', 'NIF-00030', 'Juan Navarro Ramos', '1970-07-03', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('d6cae6f4-69a9-3f3f-9a6e-4f9efe4e6738', '5ccca639-0cc8-31d9-bf38-55d0327a4c13', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ad4455c1-ae00-33c6-99d6-03350e67e539', '5ccca639-0cc8-31d9-bf38-55d0327a4c13', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('58a8da84-dd5b-39a0-886a-afd1ef124a1c', 'd6cae6f4-69a9-3f3f-9a6e-4f9efe4e6738', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('23c488f9-a1de-30a5-938b-babd2e367ca7', 'd6cae6f4-69a9-3f3f-9a6e-4f9efe4e6738', 'Metformina 850mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00032 (Carmen Torres Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('29d918ac-5213-399a-aae8-c7dca2f6d22c', 'NIF-00031', 'Carmen Torres Ramos', '1971-08-04', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('9343f6bb-2dda-307a-b4a5-3bb3ac1c8367', '29d918ac-5213-399a-aae8-c7dca2f6d22c', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('e8e429b7-d2be-3a7d-b8d3-a7224d92fe25', '29d918ac-5213-399a-aae8-c7dca2f6d22c', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('68a6dcb2-0bcf-3d27-b949-275d38dcfa9b', '9343f6bb-2dda-307a-b4a5-3bb3ac1c8367', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('ce813ebe-9371-3bbb-a0fb-daebac96a14a', '9343f6bb-2dda-307a-b4a5-3bb3ac1c8367', 'Paracetamol 1g', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00033 (Miguel Ruiz Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('502fec14-51f6-308f-a3da-f8761408a071', 'NIF-00032', 'Miguel Ruiz Ramos', '1972-09-05', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('7a9ad2ef-5a9b-39c3-9c16-46bfb71cb442', '502fec14-51f6-308f-a3da-f8761408a071', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('9b32e345-f5e8-30b4-9f33-25d6e534c27a', '502fec14-51f6-308f-a3da-f8761408a071', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('1b43553c-4a1d-3bfd-86a6-b67269287c64', '7a9ad2ef-5a9b-39c3-9c16-46bfb71cb442', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('f5ca05ee-2e2b-3d37-bf1c-84e96f971c9c', '7a9ad2ef-5a9b-39c3-9c16-46bfb71cb442', 'Paracetamol 1g', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00034 (Ana Vega Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('55278128-f5a4-3489-86e9-f578de154a21', 'NIF-00033', 'Ana Vega Ramos', '1973-10-06', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('f7c3c11a-e3f2-3490-85a3-c9d5697300af', '55278128-f5a4-3489-86e9-f578de154a21', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('e70586d5-2bb9-36d9-ac78-6384c619e959', '55278128-f5a4-3489-86e9-f578de154a21', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('c32648f7-b431-3010-afbe-fdf50f092530', 'f7c3c11a-e3f2-3490-85a3-c9d5697300af', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('daa5f654-29ff-3dfd-b52d-e97b94607649', 'f7c3c11a-e3f2-3490-85a3-c9d5697300af', 'Metformina 850mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00035 (Pablo Molina Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('63e463ec-ed1a-3807-a6b6-4290e12bb802', 'NIF-00034', 'Pablo Molina Ramos', '1974-11-07', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('95cab662-34bf-355a-ae74-4f6ffec0d779', '63e463ec-ed1a-3807-a6b6-4290e12bb802', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('e01ba423-29c3-334c-8e0e-32239a52559b', '63e463ec-ed1a-3807-a6b6-4290e12bb802', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('e29d1c53-7b54-3304-a8b0-04d5630333dc', '95cab662-34bf-355a-ae74-4f6ffec0d779', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('d0b3ec3b-6b48-335b-8f2b-1bff5ae680dc', '95cab662-34bf-355a-ae74-4f6ffec0d779', 'Salbutamol Inhalador', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00036 (Laura Ortega Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('3ab816f7-8a72-356c-b4f8-2826525447a8', 'NIF-00035', 'Laura Ortega Ramos', '1975-12-08', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('d468a85f-f2d9-3569-b4eb-a97f62fc8d98', '3ab816f7-8a72-356c-b4f8-2826525447a8', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('f04cbea5-d903-3b9d-b0b6-a03a960dca0b', '3ab816f7-8a72-356c-b4f8-2826525447a8', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('56cb5f14-ad46-3dba-8a99-307e794f5215', 'd468a85f-f2d9-3569-b4eb-a97f62fc8d98', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('01e54c92-8cbf-3d1c-bbf4-12272dd71467', 'd468a85f-f2d9-3569-b4eb-a97f62fc8d98', 'Atorvastatina 20mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00037 (Andrés Castro Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('1fca0a7c-ca40-3b35-8172-3474e44e0ed7', 'NIF-00036', 'Andrés Castro Ramos', '1976-01-09', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('3929728a-dc72-31fb-8092-a171bde04314', '1fca0a7c-ca40-3b35-8172-3474e44e0ed7', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('c7443a19-a824-3fe3-8094-f62754dd709e', '1fca0a7c-ca40-3b35-8172-3474e44e0ed7', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('baaee7d1-0f1b-3307-9668-ef926022fdb8', '3929728a-dc72-31fb-8092-a171bde04314', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('0f0e5378-b437-39f5-a1b8-361457e619e2', '3929728a-dc72-31fb-8092-a171bde04314', 'Paracetamol 1g', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00038 (Sofía Delgado Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('018b5580-48f7-39cc-8a15-36ac7563ae7b', 'NIF-00037', 'Sofía Delgado Ramos', '1977-02-10', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('de48f9f0-6a11-35d9-88cf-3e78eef545a1', '018b5580-48f7-39cc-8a15-36ac7563ae7b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('25be0816-04e2-3094-9ce5-f136dae47dd1', '018b5580-48f7-39cc-8a15-36ac7563ae7b', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('c880df83-8e0b-3468-b653-ec4b0aca6508', 'de48f9f0-6a11-35d9-88cf-3e78eef545a1', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('6003ce5d-b669-3433-81ec-8d259e4c86d8', 'de48f9f0-6a11-35d9-88cf-3e78eef545a1', 'Metformina 850mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00039 (Álvaro Serrano Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('a355855f-50a7-384c-9e1f-a1e48774afca', 'NIF-00038', 'Álvaro Serrano Ramos', '1978-03-11', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('8c3a7b92-f775-37e4-92cc-57d22174c8c9', 'a355855f-50a7-384c-9e1f-a1e48774afca', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ea251f3e-d04c-38e3-8b2c-96aef5455b69', 'a355855f-50a7-384c-9e1f-a1e48774afca', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('f6915714-d149-3731-be12-5978e7a34983', '8c3a7b92-f775-37e4-92cc-57d22174c8c9', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('60fc157f-4db7-3c26-8f1f-09486cbb6bc9', '8c3a7b92-f775-37e4-92cc-57d22174c8c9', 'Losartán 50mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00040 (Nuria Cortés Ramos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('3a4639e6-9da7-36fc-b530-855ee7c24994', 'NIF-00039', 'Nuria Cortés Ramos', '1979-04-12', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('6f4c4aa3-cd28-37f3-a875-7e0dacd17561', '3a4639e6-9da7-36fc-b530-855ee7c24994', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('a73b7783-87e7-3d4e-9169-ad6048311a6a', '3a4639e6-9da7-36fc-b530-855ee7c24994', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('034f3af2-3b8e-384b-9f07-e5ac0c9c5c71', '6f4c4aa3-cd28-37f3-a875-7e0dacd17561', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('dc971612-9a23-368f-b00a-222a23869517', '6f4c4aa3-cd28-37f3-a875-7e0dacd17561', 'Metformina 850mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00041 (Juan García Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('54b95f97-dd39-3fb5-9e7c-8a8e7163ccc9', 'NIF-00040', 'Juan García Gil', '1980-05-13', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('f9e643ad-980e-333a-a668-9b098aadb24a', '54b95f97-dd39-3fb5-9e7c-8a8e7163ccc9', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('918c1aeb-10e3-3450-a2f3-d84d87196975', '54b95f97-dd39-3fb5-9e7c-8a8e7163ccc9', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('3d8d3a91-dcec-3ad5-b983-380f5dc34217', 'f9e643ad-980e-333a-a668-9b098aadb24a', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('d98bdd7f-c52d-3bd0-8551-64130e193ce5', 'f9e643ad-980e-333a-a668-9b098aadb24a', 'Paracetamol 1g', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00042 (Carmen López Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('2baf83e8-bdc3-3817-abfc-f1c2163cda3f', 'NIF-00041', 'Carmen López Gil', '1981-06-14', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('80c7e7f8-52bf-377f-933f-d608f0e11ce5', '2baf83e8-bdc3-3817-abfc-f1c2163cda3f', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('5adea4eb-5c43-31f4-a999-eba93ab952cf', '2baf83e8-bdc3-3817-abfc-f1c2163cda3f', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('9a04e448-43ec-3a97-adf5-15ced63fa19f', '80c7e7f8-52bf-377f-933f-d608f0e11ce5', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('30862e67-0dd4-3c1c-a1db-afc590b6c4c4', '80c7e7f8-52bf-377f-933f-d608f0e11ce5', 'Metformina 850mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00043 (Miguel Martínez Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('0547f0e2-4fd6-343e-a418-5bcd82806534', 'NIF-00042', 'Miguel Martínez Gil', '1982-07-15', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('51590610-8f21-305c-b27e-bb3c9102ddc4', '0547f0e2-4fd6-343e-a418-5bcd82806534', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('50aa891d-ae3e-3a8f-97bd-5b5606457cff', '0547f0e2-4fd6-343e-a418-5bcd82806534', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('8df54579-9ef2-3fd2-9d98-42609d5c9124', '51590610-8f21-305c-b27e-bb3c9102ddc4', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('9bf6b4dc-dd75-3a94-958e-386128da0038', '51590610-8f21-305c-b27e-bb3c9102ddc4', 'Losartán 50mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00044 (Ana Sánchez Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('e030336c-ba8a-334b-bc81-c85f1e859973', 'NIF-00043', 'Ana Sánchez Gil', '1983-08-16', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('77f3f0ac-5e2e-30f7-934a-e4b7bb7d234d', 'e030336c-ba8a-334b-bc81-c85f1e859973', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('16dab6c5-4f53-391b-b4ca-684361bacccf', 'e030336c-ba8a-334b-bc81-c85f1e859973', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('07e1c969-60e3-35a3-a74c-e5cb3ecacb5f', '77f3f0ac-5e2e-30f7-934a-e4b7bb7d234d', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('a13b881d-2ffe-301f-9c6d-003d07483886', '77f3f0ac-5e2e-30f7-934a-e4b7bb7d234d', 'Salbutamol Inhalador', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00045 (Pablo Pérez Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('c3770ed2-11f9-38d3-b72c-ab4ea24780e0', 'NIF-00044', 'Pablo Pérez Gil', '1984-09-17', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('2da59cac-a45a-3e5d-a445-c9d8bb32bd84', 'c3770ed2-11f9-38d3-b72c-ab4ea24780e0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('9be62684-66cc-3fc4-877b-06fe5e57a782', 'c3770ed2-11f9-38d3-b72c-ab4ea24780e0', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('4dc8cce3-d2fc-3e41-a3d6-01860a4a5d23', '2da59cac-a45a-3e5d-a445-c9d8bb32bd84', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('086cf492-32fa-3923-b1ca-67f0acaab619', '2da59cac-a45a-3e5d-a445-c9d8bb32bd84', 'Atorvastatina 20mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00046 (Laura Gómez Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('ce0ac3f4-59a6-34fe-be82-9956f4cbbcb6', 'NIF-00045', 'Laura Gómez Gil', '1985-10-18', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('182ce82f-238d-3b22-892a-f08ac8972aa9', 'ce0ac3f4-59a6-34fe-be82-9956f4cbbcb6', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('22f6b46d-aac8-322e-9777-3ad4a091f3a8', 'ce0ac3f4-59a6-34fe-be82-9956f4cbbcb6', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('a0cfbd29-1df9-394b-a290-db245162c05c', '182ce82f-238d-3b22-892a-f08ac8972aa9', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('81e48b4b-e639-35a8-830d-35d5eff59d8f', '182ce82f-238d-3b22-892a-f08ac8972aa9', 'Levotiroxina 50mcg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00047 (Andrés Fernández Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('3fc5abbd-490c-3bb7-ac0f-dfbbf2a87b43', 'NIF-00046', 'Andrés Fernández Gil', '1986-11-19', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('93803b5a-7d5a-39d1-9dce-a323970152cf', '3fc5abbd-490c-3bb7-ac0f-dfbbf2a87b43', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('366ded6e-ab79-325e-9db5-dcf3b5b886ce', '3fc5abbd-490c-3bb7-ac0f-dfbbf2a87b43', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('12dec4ea-8938-3147-825c-3d1086a6e998', '93803b5a-7d5a-39d1-9dce-a323970152cf', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('1307d88a-6d78-386a-9e06-29cf0f0e52e9', '93803b5a-7d5a-39d1-9dce-a323970152cf', 'Paracetamol 1g', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00048 (Sofía Díaz Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('7ce1974c-5e7a-3e78-a508-cbb5c31cd317', 'NIF-00047', 'Sofía Díaz Gil', '1987-12-20', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('fe916e5c-1db7-347b-adf2-fd7e79e8eb9a', '7ce1974c-5e7a-3e78-a508-cbb5c31cd317', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('1b2d305f-86b1-36ab-9622-8c304b5b195d', '7ce1974c-5e7a-3e78-a508-cbb5c31cd317', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('6d3a0301-f331-3fa1-aa65-4a6ecd14051c', 'fe916e5c-1db7-347b-adf2-fd7e79e8eb9a', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('79cd0b7d-9df4-3c10-8f55-04370870fcd9', 'fe916e5c-1db7-347b-adf2-fd7e79e8eb9a', 'Metformina 850mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00049 (Álvaro Álvarez Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('d1145ba7-2e07-365e-999d-fbb366cd80e3', 'NIF-00048', 'Álvaro Álvarez Gil', '1988-01-21', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('6d61c260-0814-3b09-a29d-5db5ebdc3354', 'd1145ba7-2e07-365e-999d-fbb366cd80e3', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('2687f77a-b1e7-39ef-8e52-202a26103331', 'd1145ba7-2e07-365e-999d-fbb366cd80e3', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('f913b63a-f20e-3acb-9bcb-e7e5a96b6303', '6d61c260-0814-3b09-a29d-5db5ebdc3354', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('d4576a3a-1685-3339-b857-db37b174f4f3', '6d61c260-0814-3b09-a29d-5db5ebdc3354', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00050 (Nuria Romero Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('4a60afa6-e221-3853-8326-bac5eb8f20a8', 'NIF-00049', 'Nuria Romero Gil', '1989-02-22', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('b983b721-7b5e-334a-a70f-ad047224534d', '4a60afa6-e221-3853-8326-bac5eb8f20a8', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('c7001352-977c-374c-97dd-d65569291a07', '4a60afa6-e221-3853-8326-bac5eb8f20a8', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('8956af87-5689-32ad-b7f9-6344f86b2fbb', 'b983b721-7b5e-334a-a70f-ad047224534d', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('9ca594fb-f98a-37e6-938b-8e4086c8701f', 'b983b721-7b5e-334a-a70f-ad047224534d', 'Levotiroxina 50mcg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00051 (Juan Navarro Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('be573a5f-b050-30ab-8ed7-15982ae1bfa2', 'NIF-00050', 'Juan Navarro Gil', '1940-03-23', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('cb144279-ba50-3cb5-adb9-e03ef8a8763b', 'be573a5f-b050-30ab-8ed7-15982ae1bfa2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('0dac5919-5e9e-353f-9211-808559419a62', 'be573a5f-b050-30ab-8ed7-15982ae1bfa2', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('a46def63-743b-32e0-82ce-f32845a17770', 'cb144279-ba50-3cb5-adb9-e03ef8a8763b', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('ce9640d8-59e0-3a54-9f1c-b1df386cd385', 'cb144279-ba50-3cb5-adb9-e03ef8a8763b', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00052 (Carmen Torres Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('585e7d95-22cd-37ca-942e-6760511c5d50', 'NIF-00051', 'Carmen Torres Gil', '1941-04-24', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('ec88694a-0667-324d-8361-91538e4a1108', '585e7d95-22cd-37ca-942e-6760511c5d50', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('dd80cbe2-f73b-3488-b4cc-08e7210de4a0', '585e7d95-22cd-37ca-942e-6760511c5d50', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('923559e0-7f99-3ab0-b11a-ca4c3f79c1c0', 'ec88694a-0667-324d-8361-91538e4a1108', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('e198cc31-1f10-36f7-a9d2-7b24f57f2e63', 'ec88694a-0667-324d-8361-91538e4a1108', 'Atorvastatina 20mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00053 (Miguel Ruiz Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('706331a3-aca9-35c3-a7c4-59fcf5e5b1cc', 'NIF-00052', 'Miguel Ruiz Gil', '1942-05-25', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('25962717-b6c9-3936-bbef-156df86818eb', '706331a3-aca9-35c3-a7c4-59fcf5e5b1cc', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('3a4f680b-ee84-3921-ad01-6fc92f05a41c', '706331a3-aca9-35c3-a7c4-59fcf5e5b1cc', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('13d32553-a772-3002-9b38-7066d44324ba', '25962717-b6c9-3936-bbef-156df86818eb', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('0709efd2-c478-3338-901e-d7a45584fd8e', '25962717-b6c9-3936-bbef-156df86818eb', 'Losartán 50mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00054 (Ana Vega Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('f2976bb0-eb15-3e21-8ec9-aa6dfc2b9048', 'NIF-00053', 'Ana Vega Gil', '1943-06-26', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('21b74b6e-11d9-34e2-a428-ae0184be3ac0', 'f2976bb0-eb15-3e21-8ec9-aa6dfc2b9048', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('b315ef89-6cb0-322b-b29d-662214136a91', 'f2976bb0-eb15-3e21-8ec9-aa6dfc2b9048', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('be086853-aefa-3321-8e9d-c48faed80865', '21b74b6e-11d9-34e2-a428-ae0184be3ac0', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('6d8f65e9-2d43-3808-ae80-2bf6d717a6fc', '21b74b6e-11d9-34e2-a428-ae0184be3ac0', 'Atorvastatina 20mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00055 (Pablo Molina Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('362d42ca-bc8d-385c-9c88-41fcc84e248a', 'NIF-00054', 'Pablo Molina Gil', '1944-07-27', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('94d628a8-078f-396e-a270-47742babc35d', '362d42ca-bc8d-385c-9c88-41fcc84e248a', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('19411bc6-c9f2-375c-a81b-c34c914c19ac', '362d42ca-bc8d-385c-9c88-41fcc84e248a', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('1a02b21c-6e5f-341d-bd4b-244f41ab5c01', '94d628a8-078f-396e-a270-47742babc35d', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('a00ee660-06df-344e-9388-97a8c20a63db', '94d628a8-078f-396e-a270-47742babc35d', 'Paracetamol 1g', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00056 (Laura Ortega Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('e88a9fe4-087d-36c9-9c46-5f0665387869', 'NIF-00055', 'Laura Ortega Gil', '1945-08-28', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('f50f25bf-13fa-3e21-80e4-fd7ecbae7d24', 'e88a9fe4-087d-36c9-9c46-5f0665387869', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('585028b3-fae9-3230-851c-7d01b4658645', 'e88a9fe4-087d-36c9-9c46-5f0665387869', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('3aa1465c-d31b-3798-9dd9-7ee02f416977', 'f50f25bf-13fa-3e21-80e4-fd7ecbae7d24', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('a0362f46-4e41-3772-bf02-d7d3660c575c', 'f50f25bf-13fa-3e21-80e4-fd7ecbae7d24', 'Paracetamol 1g', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00057 (Andrés Castro Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('f6492c12-b00d-3504-81ec-2281907cf99a', 'NIF-00056', 'Andrés Castro Gil', '1946-09-01', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('0b57fb89-a1ac-377c-851d-67cccef461a4', 'f6492c12-b00d-3504-81ec-2281907cf99a', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('1b5ae8de-45e8-3a8b-8dc8-3d328b9b4ecd', 'f6492c12-b00d-3504-81ec-2281907cf99a', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('dda48065-d737-335d-8565-4d1456b07417', '0b57fb89-a1ac-377c-851d-67cccef461a4', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('10e9de9f-d009-3479-8a4c-6815207efe14', '0b57fb89-a1ac-377c-851d-67cccef461a4', 'Levotiroxina 50mcg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00058 (Sofía Delgado Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('f36c792a-da66-3d15-9a88-574df23bafe6', 'NIF-00057', 'Sofía Delgado Gil', '1947-10-02', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('a8961b9f-87af-3f92-bc40-ea5fa9f53f9f', 'f36c792a-da66-3d15-9a88-574df23bafe6', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('01f9b443-a5a6-3d54-9ce4-784b58dd6259', 'f36c792a-da66-3d15-9a88-574df23bafe6', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('aa68cb6f-ba19-336f-a366-90ce11c54e41', 'a8961b9f-87af-3f92-bc40-ea5fa9f53f9f', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('3484e6b1-088f-3438-8b60-2e3e758c3b44', 'a8961b9f-87af-3f92-bc40-ea5fa9f53f9f', 'Atorvastatina 20mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00059 (Álvaro Serrano Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('42917168-6a7b-3fb0-9f1b-6daab6a0196c', 'NIF-00058', 'Álvaro Serrano Gil', '1948-11-03', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('4d4642e1-8d1f-38a1-8f7e-9a2675c2014f', '42917168-6a7b-3fb0-9f1b-6daab6a0196c', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('31acddf7-fdcb-3c66-8498-06904f918edc', '42917168-6a7b-3fb0-9f1b-6daab6a0196c', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('f4211839-3ad0-302b-b8b8-80e6a2e2efa6', '4d4642e1-8d1f-38a1-8f7e-9a2675c2014f', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('14f8ce94-8431-3e53-828c-2db1693a3f51', '4d4642e1-8d1f-38a1-8f7e-9a2675c2014f', 'Ibuprofeno 400mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00060 (Nuria Cortés Gil)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('cdcbcff3-27b5-3255-a085-3fa3c9dfed61', 'NIF-00059', 'Nuria Cortés Gil', '1949-12-04', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('9d73cfcf-c705-3a14-b279-b0e315173ddf', 'cdcbcff3-27b5-3255-a085-3fa3c9dfed61', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('9f15ad2b-3733-3217-9c78-ada40dbe2744', 'cdcbcff3-27b5-3255-a085-3fa3c9dfed61', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('4cb770fb-4f27-3d54-b277-78888918630a', '9d73cfcf-c705-3a14-b279-b0e315173ddf', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('25f834c7-f33a-38d3-b68e-270169618e59', '9d73cfcf-c705-3a14-b279-b0e315173ddf', 'Metformina 850mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00061 (Juan García Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('6f97fa6e-ccb1-32e1-b59b-e99cda0adad3', 'NIF-00060', 'Juan García Suárez', '1950-01-05', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('395357d4-f240-3686-9404-5e48470929ea', '6f97fa6e-ccb1-32e1-b59b-e99cda0adad3', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('f6ed2bf2-8100-3ac1-bddb-5aa6483dd871', '6f97fa6e-ccb1-32e1-b59b-e99cda0adad3', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('b02aaf9c-75d0-30db-bb0f-5f34e7f6d0c1', '395357d4-f240-3686-9404-5e48470929ea', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('9c981980-61f7-3923-8b83-d2db4ad51cfd', '395357d4-f240-3686-9404-5e48470929ea', 'Levotiroxina 50mcg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00062 (Carmen López Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('a004ba94-ff96-3279-a16b-a18f58ce8fe4', 'NIF-00061', 'Carmen López Suárez', '1951-02-06', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('334716d4-4a7a-3577-b905-ae1a1fe07ccb', 'a004ba94-ff96-3279-a16b-a18f58ce8fe4', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('4c8ed87f-2222-3c52-87bd-3cb2ebdb40dd', 'a004ba94-ff96-3279-a16b-a18f58ce8fe4', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('f2c30267-f6a8-3a90-9e55-4129f543c8d2', '334716d4-4a7a-3577-b905-ae1a1fe07ccb', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('34aebde2-0234-3b8a-9df8-9974d5859a98', '334716d4-4a7a-3577-b905-ae1a1fe07ccb', 'Losartán 50mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00063 (Miguel Martínez Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('10907f2a-8257-3bb8-82f5-7a9030151616', 'NIF-00062', 'Miguel Martínez Suárez', '1952-03-07', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('ff64696e-0771-3108-b55b-46d6cc3d62f9', '10907f2a-8257-3bb8-82f5-7a9030151616', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('02e541e8-e263-39f7-90ec-6878cd7eba50', '10907f2a-8257-3bb8-82f5-7a9030151616', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('aaf4e699-9406-3a29-8be6-413c107b2717', 'ff64696e-0771-3108-b55b-46d6cc3d62f9', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('8347e0b7-804d-3dcb-aea9-62356f948a6c', 'ff64696e-0771-3108-b55b-46d6cc3d62f9', 'Losartán 50mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00064 (Ana Sánchez Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('673d7024-8a27-3d17-a298-482a4449a07d', 'NIF-00063', 'Ana Sánchez Suárez', '1953-04-08', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('eb9a50c1-166c-36bf-a32e-cb0942c40daa', '673d7024-8a27-3d17-a298-482a4449a07d', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('7f78a8c0-bb23-3e73-a4c1-e41ceb612a7f', '673d7024-8a27-3d17-a298-482a4449a07d', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('a747f065-e6eb-3193-9e38-76c40c82cd50', 'eb9a50c1-166c-36bf-a32e-cb0942c40daa', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('0405e178-49d0-3b80-ac7b-9b9023ef2f59', 'eb9a50c1-166c-36bf-a32e-cb0942c40daa', 'Salbutamol Inhalador', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00065 (Pablo Pérez Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('a985fc6a-4575-3b35-b672-dbe4dc30f513', 'NIF-00064', 'Pablo Pérez Suárez', '1954-05-09', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('a3227032-c255-31c5-9fca-011be7a9512c', 'a985fc6a-4575-3b35-b672-dbe4dc30f513', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('9fbff822-dee3-3e0f-a07b-0f0242d084bf', 'a985fc6a-4575-3b35-b672-dbe4dc30f513', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('36b2c609-c8d3-3593-8540-c3f4ff5c27a7', 'a3227032-c255-31c5-9fca-011be7a9512c', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('8ed07adf-c924-323f-887a-a3e2353cafa9', 'a3227032-c255-31c5-9fca-011be7a9512c', 'Atorvastatina 20mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00066 (Laura Gómez Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('94da88fc-914b-3884-b856-e2ef8b2d2452', 'NIF-00065', 'Laura Gómez Suárez', '1955-06-10', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('a2fc656c-aaee-3f66-b70c-d97bcedf7747', '94da88fc-914b-3884-b856-e2ef8b2d2452', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ff290d37-7be9-3b2b-8df6-c3dff4980d85', '94da88fc-914b-3884-b856-e2ef8b2d2452', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('de68dafc-9bf5-3b24-8b9a-535efb2c134e', 'a2fc656c-aaee-3f66-b70c-d97bcedf7747', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('b51a41d7-a767-3e9a-a7fd-1fcd70c7c88f', 'a2fc656c-aaee-3f66-b70c-d97bcedf7747', 'Losartán 50mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00067 (Andrés Fernández Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('d5e9bbff-44e6-3170-8153-291c63c8e20d', 'NIF-00066', 'Andrés Fernández Suárez', '1956-07-11', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('d01e0fc6-03dd-30b5-8cee-b65ac57fec6c', 'd5e9bbff-44e6-3170-8153-291c63c8e20d', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('df1d8408-eca9-3ecc-8cd4-2843a97df6f2', 'd5e9bbff-44e6-3170-8153-291c63c8e20d', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('bf5fdd07-525e-34ac-a1e6-e556ea5db76f', 'd01e0fc6-03dd-30b5-8cee-b65ac57fec6c', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('80940694-ced6-3da5-989f-6bf0eb29d1b9', 'd01e0fc6-03dd-30b5-8cee-b65ac57fec6c', 'Paracetamol 1g', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00068 (Sofía Díaz Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('46af45ff-676f-3cc8-b2a1-f149055c6950', 'NIF-00067', 'Sofía Díaz Suárez', '1957-08-12', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('49205f67-fc1e-3d94-a708-79a22bc69f96', '46af45ff-676f-3cc8-b2a1-f149055c6950', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ba5cacb5-9b8d-347c-bbff-d8352237f67e', '46af45ff-676f-3cc8-b2a1-f149055c6950', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('31a0d181-ea81-35db-a391-c7417533a4c0', '49205f67-fc1e-3d94-a708-79a22bc69f96', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('8fbe0679-4981-3950-b62a-6c7eb0d55f63', '49205f67-fc1e-3d94-a708-79a22bc69f96', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00069 (Álvaro Álvarez Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('a902181f-12f7-3a0f-96a2-111075a937ac', 'NIF-00068', 'Álvaro Álvarez Suárez', '1958-09-13', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('a1eaa8cd-89e5-35b9-9118-bc3764a97510', 'a902181f-12f7-3a0f-96a2-111075a937ac', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('d1cd85f5-f8fd-3e77-ab1d-2bc197166175', 'a902181f-12f7-3a0f-96a2-111075a937ac', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('c1508e8c-5c48-3b06-9062-6f6f611d68f5', 'a1eaa8cd-89e5-35b9-9118-bc3764a97510', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('a46c8028-278b-38aa-bf13-82a5d3d06bfc', 'a1eaa8cd-89e5-35b9-9118-bc3764a97510', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00070 (Nuria Romero Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('9e27658c-9eab-3b8c-9435-5bd05880b423', 'NIF-00069', 'Nuria Romero Suárez', '1959-10-14', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('916b6905-b0d8-3f9c-b79a-59e768af23c9', '9e27658c-9eab-3b8c-9435-5bd05880b423', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('20767a35-1bcd-3854-9fe1-ad6c35f558eb', '9e27658c-9eab-3b8c-9435-5bd05880b423', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('f16bbe1e-1b7b-3e8e-8a18-1161bc78614b', '916b6905-b0d8-3f9c-b79a-59e768af23c9', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('89b61c79-ec4d-3766-87fe-243437aaf752', '916b6905-b0d8-3f9c-b79a-59e768af23c9', 'Levotiroxina 50mcg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00071 (Juan Navarro Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('40317777-4452-36cb-bd45-99022c090d38', 'NIF-00070', 'Juan Navarro Suárez', '1960-11-15', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('6dec76e7-2396-3ee1-a889-3ce30e9ee30f', '40317777-4452-36cb-bd45-99022c090d38', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('fcc19ba7-2191-3c00-81f0-100a8c37420b', '40317777-4452-36cb-bd45-99022c090d38', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('f42bd0c5-d7b1-3df5-b2ae-0840c62f706f', '6dec76e7-2396-3ee1-a889-3ce30e9ee30f', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('c0e225b6-b468-32d8-9a63-303603449b20', '6dec76e7-2396-3ee1-a889-3ce30e9ee30f', 'Paracetamol 1g', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00072 (Carmen Torres Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('28b99fc3-6209-32c8-aefe-d96c5b44f280', 'NIF-00071', 'Carmen Torres Suárez', '1961-12-16', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('4091c716-ded7-30bf-848a-ae17c4fd8f98', '28b99fc3-6209-32c8-aefe-d96c5b44f280', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('b7bf56b6-451e-3070-846b-4c2c2d87373d', '28b99fc3-6209-32c8-aefe-d96c5b44f280', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('58138190-3f43-3912-aa20-2055f46e67f8', '4091c716-ded7-30bf-848a-ae17c4fd8f98', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('f6a6e9ba-0ae6-3421-9588-7ee5f60edeb7', '4091c716-ded7-30bf-848a-ae17c4fd8f98', 'Paracetamol 1g', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00073 (Miguel Ruiz Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('1099b26d-9b7b-3ddd-bc85-dee6b7ff5f49', 'NIF-00072', 'Miguel Ruiz Suárez', '1962-01-17', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('6234ace5-ef8b-3608-b68e-80fb263827dd', '1099b26d-9b7b-3ddd-bc85-dee6b7ff5f49', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('6e99d3b5-d0f5-3aa2-ae93-15374a9052cf', '1099b26d-9b7b-3ddd-bc85-dee6b7ff5f49', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('3639d724-2fbd-3c0b-8a4b-11d2ab7f18ea', '6234ace5-ef8b-3608-b68e-80fb263827dd', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('c290d734-25e2-36aa-8a81-f6bbdf372ab3', '6234ace5-ef8b-3608-b68e-80fb263827dd', 'Levotiroxina 50mcg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00074 (Ana Vega Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('2d60fd99-d469-357c-8914-1160e74dcff8', 'NIF-00073', 'Ana Vega Suárez', '1963-02-18', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('3e6c58c2-fb41-31bc-b0e3-61da6bf7ad1d', '2d60fd99-d469-357c-8914-1160e74dcff8', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('c9da5147-7499-34f9-963e-c9fc87ed1e6f', '2d60fd99-d469-357c-8914-1160e74dcff8', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('d9852464-1b53-3479-9f0d-eb778279137c', '3e6c58c2-fb41-31bc-b0e3-61da6bf7ad1d', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('9aa605a6-6341-3b88-b6d8-6fc12028daa4', '3e6c58c2-fb41-31bc-b0e3-61da6bf7ad1d', 'Levotiroxina 50mcg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00075 (Pablo Molina Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('fbe6207e-a999-3c93-b3c8-3d9b30c30dc8', 'NIF-00074', 'Pablo Molina Suárez', '1964-03-19', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('ca7359dc-8b21-38f4-b6c2-e01af00c4317', 'fbe6207e-a999-3c93-b3c8-3d9b30c30dc8', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('bfe8e50c-b6a8-3e40-8f73-d07582a5de6f', 'fbe6207e-a999-3c93-b3c8-3d9b30c30dc8', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('1d49629f-8186-36cc-87a2-2685f992e44c', 'ca7359dc-8b21-38f4-b6c2-e01af00c4317', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('03b70eb2-0dff-34b6-bd53-2f2f07f244c0', 'ca7359dc-8b21-38f4-b6c2-e01af00c4317', 'Paracetamol 1g', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00076 (Laura Ortega Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('f37c3307-c8e5-354c-b0c3-5fc3df26c279', 'NIF-00075', 'Laura Ortega Suárez', '1965-04-20', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('747adb5b-be37-3073-b78c-88dc1ff08568', 'f37c3307-c8e5-354c-b0c3-5fc3df26c279', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('b99063f6-5152-3cab-bb9b-ccabaa8ae292', 'f37c3307-c8e5-354c-b0c3-5fc3df26c279', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('39c2b369-9305-3a1c-9d01-85929197034f', '747adb5b-be37-3073-b78c-88dc1ff08568', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('a49ee709-2b21-399e-9fac-9698555e919f', '747adb5b-be37-3073-b78c-88dc1ff08568', 'Ibuprofeno 400mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00077 (Andrés Castro Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('ab9b6653-6c1c-3201-9d68-daf416599473', 'NIF-00076', 'Andrés Castro Suárez', '1966-05-21', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('b09685cf-7295-3d83-be17-e9ff8d12e600', 'ab9b6653-6c1c-3201-9d68-daf416599473', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ca5790cf-7323-34e7-920d-759c15003ca5', 'ab9b6653-6c1c-3201-9d68-daf416599473', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('460bdedb-38ae-3320-be17-3ba71d0b642e', 'b09685cf-7295-3d83-be17-e9ff8d12e600', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('cf20544b-ff68-3d77-9770-ff04b3c8ae8c', 'b09685cf-7295-3d83-be17-e9ff8d12e600', 'Levotiroxina 50mcg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00078 (Sofía Delgado Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('8df78d01-b1ef-376d-ab1d-36dc3a3a4b2f', 'NIF-00077', 'Sofía Delgado Suárez', '1967-06-22', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('c7dd5fd7-154e-3170-98ca-1bfe37a6e5e8', '8df78d01-b1ef-376d-ab1d-36dc3a3a4b2f', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('1b6fcdf8-9f4c-3625-9714-5cdbf6eb6a58', '8df78d01-b1ef-376d-ab1d-36dc3a3a4b2f', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('3b19f72c-3cf6-369b-8f01-9e0ff5a91c77', 'c7dd5fd7-154e-3170-98ca-1bfe37a6e5e8', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('abf8dc66-c237-38e0-b14c-f186948f1c95', 'c7dd5fd7-154e-3170-98ca-1bfe37a6e5e8', 'Levotiroxina 50mcg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00079 (Álvaro Serrano Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('82b36a35-df1d-334a-a414-8ca1ce1f2444', 'NIF-00078', 'Álvaro Serrano Suárez', '1968-07-23', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('7f3151a8-c190-3e14-b08a-6fa9d8c88c42', '82b36a35-df1d-334a-a414-8ca1ce1f2444', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('21441c64-108a-3126-a940-d8df04b4ee06', '82b36a35-df1d-334a-a414-8ca1ce1f2444', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('ee69cbd3-2641-3c1b-9acf-c28525a79688', '7f3151a8-c190-3e14-b08a-6fa9d8c88c42', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('c53c2b9c-c5f0-3e75-9036-b569c3a7584a', '7f3151a8-c190-3e14-b08a-6fa9d8c88c42', 'Metformina 850mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00080 (Nuria Cortés Suárez)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('401a2ea7-c32b-3921-8acb-206ef6b4eb12', 'NIF-00079', 'Nuria Cortés Suárez', '1969-08-24', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('fa86b0ff-928d-3bed-bd91-b89314517add', '401a2ea7-c32b-3921-8acb-206ef6b4eb12', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('52cdcd04-f796-323c-9653-64a4ea9e61de', '401a2ea7-c32b-3921-8acb-206ef6b4eb12', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('6073f9e3-ad51-329e-a41b-e3e619abdede', 'fa86b0ff-928d-3bed-bd91-b89314517add', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('4154cb2a-dcad-3be2-90af-64a787e432f2', 'fa86b0ff-928d-3bed-bd91-b89314517add', 'Metformina 850mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00081 (Juan García Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('1c037b97-7493-340b-9f01-75b52b049d0c', 'NIF-00080', 'Juan García Navarro', '1970-09-25', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('29608783-7bdc-35b8-9597-0a63e44c921d', '1c037b97-7493-340b-9f01-75b52b049d0c', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('f9405531-b595-3f3f-9495-c6d7c9d018cd', '1c037b97-7493-340b-9f01-75b52b049d0c', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('02044022-c2a6-3f26-aa99-ddbcb531143a', '29608783-7bdc-35b8-9597-0a63e44c921d', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('25d9962a-db42-3936-8d8d-1dfb1d0e496f', '29608783-7bdc-35b8-9597-0a63e44c921d', 'Atorvastatina 20mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00082 (Carmen López Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('ad275019-d2ef-31cf-a4ac-7716a2a8507c', 'NIF-00081', 'Carmen López Navarro', '1971-10-26', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('bf0ff79a-b3c5-3c88-900d-be1871074313', 'ad275019-d2ef-31cf-a4ac-7716a2a8507c', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ce440f72-212f-3bd9-b489-06f6450e7e4c', 'ad275019-d2ef-31cf-a4ac-7716a2a8507c', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('d654c549-1e9a-3b2a-8aaa-8160c8dcdaaf', 'bf0ff79a-b3c5-3c88-900d-be1871074313', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('9687a9a9-6bb2-39a0-97bd-25cb741d25ec', 'bf0ff79a-b3c5-3c88-900d-be1871074313', 'Ibuprofeno 400mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00083 (Miguel Martínez Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('a64330b3-fc03-3c58-9d4f-6e7b6d9c5518', 'NIF-00082', 'Miguel Martínez Navarro', '1972-11-27', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('fe79e837-b463-3b5d-a861-e8104652f09c', 'a64330b3-fc03-3c58-9d4f-6e7b6d9c5518', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('0ec44da7-5e17-3db3-b99b-b6439ec45e1f', 'a64330b3-fc03-3c58-9d4f-6e7b6d9c5518', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('28d56f53-889a-3394-82cb-003e290a161e', 'fe79e837-b463-3b5d-a861-e8104652f09c', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('8f4f10aa-d685-32f7-b20b-59c7f1cca2cd', 'fe79e837-b463-3b5d-a861-e8104652f09c', 'Metformina 850mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00084 (Ana Sánchez Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('1a4a9b9e-0bdf-3561-9ee4-be1e3d53a75d', 'NIF-00083', 'Ana Sánchez Navarro', '1973-12-28', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('d6f9fe49-9cf5-33da-872f-68595f66acef', '1a4a9b9e-0bdf-3561-9ee4-be1e3d53a75d', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('d8c35d17-d044-3162-8b97-bcc04d96dd4d', '1a4a9b9e-0bdf-3561-9ee4-be1e3d53a75d', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('b48a8d58-08b0-3be9-b1f0-077bcdc2c321', 'd6f9fe49-9cf5-33da-872f-68595f66acef', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('c7402220-3f47-38e0-a7f1-584056f67cc9', 'd6f9fe49-9cf5-33da-872f-68595f66acef', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00085 (Pablo Pérez Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('7d7ac9e8-65d9-3ff2-9fc3-74ee5d2bc806', 'NIF-00084', 'Pablo Pérez Navarro', '1974-01-01', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('0acdd131-ff49-30bd-85f9-7883dc98e009', '7d7ac9e8-65d9-3ff2-9fc3-74ee5d2bc806', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('dfb7ed8d-b829-388a-88ec-e5de7d20631a', '7d7ac9e8-65d9-3ff2-9fc3-74ee5d2bc806', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('7793e4ca-e23a-3aac-9082-95745686359a', '0acdd131-ff49-30bd-85f9-7883dc98e009', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('db7bdea7-e3d0-38a5-9a21-d59fe31f0b94', '0acdd131-ff49-30bd-85f9-7883dc98e009', 'Losartán 50mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00086 (Laura Gómez Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('f0a64dc8-6edc-39ab-957e-33b32216f9ed', 'NIF-00085', 'Laura Gómez Navarro', '1975-02-02', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('cad91d76-e0d6-3da7-a102-b0bccbb79fd1', 'f0a64dc8-6edc-39ab-957e-33b32216f9ed', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('15a3087c-48ff-32bc-87cb-2ff44b5f81a7', 'f0a64dc8-6edc-39ab-957e-33b32216f9ed', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('5bd90ba4-a775-3e79-8bba-afb7559f1008', 'cad91d76-e0d6-3da7-a102-b0bccbb79fd1', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('1dd51123-6f49-350c-a99a-522c291ce0ca', 'cad91d76-e0d6-3da7-a102-b0bccbb79fd1', 'Atorvastatina 20mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00087 (Andrés Fernández Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('3898b5f6-0a95-3c78-a49b-eed9327b1bf5', 'NIF-00086', 'Andrés Fernández Navarro', '1976-03-03', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('02bc9dad-5928-39e8-b594-f67ab81cba4f', '3898b5f6-0a95-3c78-a49b-eed9327b1bf5', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('23662c7c-2027-391b-85c3-c7397e3f082d', '3898b5f6-0a95-3c78-a49b-eed9327b1bf5', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('645c5ed3-b668-30db-a52b-adeae5de5c43', '02bc9dad-5928-39e8-b594-f67ab81cba4f', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('3524480c-0e9f-3455-9f63-b0cb2a08e9d1', '02bc9dad-5928-39e8-b594-f67ab81cba4f', 'Losartán 50mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00088 (Sofía Díaz Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('e252dab4-efac-3960-8d50-56719ba88d21', 'NIF-00087', 'Sofía Díaz Navarro', '1977-04-04', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('76351f16-f7c1-3a69-a737-e10c49d05995', 'e252dab4-efac-3960-8d50-56719ba88d21', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('262b48c5-3a49-37cd-bf9a-ee60a0121924', 'e252dab4-efac-3960-8d50-56719ba88d21', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('6aab06c3-3485-3b03-8a73-cdba0dd716fc', '76351f16-f7c1-3a69-a737-e10c49d05995', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('1f685a23-36f3-3572-8b04-a5aef1988cb4', '76351f16-f7c1-3a69-a737-e10c49d05995', 'Paracetamol 1g', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00089 (Álvaro Álvarez Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('b54e1f7d-4656-393b-9a41-da6baf8bc1e2', 'NIF-00088', 'Álvaro Álvarez Navarro', '1978-05-05', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('98cd54e8-e39c-37ee-a367-84e3107e98f5', 'b54e1f7d-4656-393b-9a41-da6baf8bc1e2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('54a40a32-f123-39cc-85fc-30e6472fa039', 'b54e1f7d-4656-393b-9a41-da6baf8bc1e2', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('e133c858-7101-36b8-afff-703adba07aa5', '98cd54e8-e39c-37ee-a367-84e3107e98f5', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('91557c2d-9c63-3c12-901e-5ea870edb1f3', '98cd54e8-e39c-37ee-a367-84e3107e98f5', 'Paracetamol 1g', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00090 (Nuria Romero Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('6ff31a8a-dd7e-379c-b0b4-3f32240dc1a4', 'NIF-00089', 'Nuria Romero Navarro', '1979-06-06', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('41b4adc8-448e-33b7-b5e1-b9c067420316', '6ff31a8a-dd7e-379c-b0b4-3f32240dc1a4', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('d3667f25-97b1-3d37-9546-421ea5df621e', '6ff31a8a-dd7e-379c-b0b4-3f32240dc1a4', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('0939e466-9c19-3a75-89f6-7ed90da446dd', '41b4adc8-448e-33b7-b5e1-b9c067420316', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('e4e86eee-c6d3-395e-becb-b4527de5b47b', '41b4adc8-448e-33b7-b5e1-b9c067420316', 'Levotiroxina 50mcg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00091 (Juan Navarro Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('017ccedc-b036-38e4-8148-fc7b3d1d6ff5', 'NIF-00090', 'Juan Navarro Navarro', '1980-07-07', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('efe05d07-19c1-35e8-aed2-55f2e0e2821e', '017ccedc-b036-38e4-8148-fc7b3d1d6ff5', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('36181ccc-2625-3a83-bd53-1d129f985eba', '017ccedc-b036-38e4-8148-fc7b3d1d6ff5', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('10cda6d1-99fe-35fd-a756-310aef2a90a2', 'efe05d07-19c1-35e8-aed2-55f2e0e2821e', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('5cd829f8-3b28-3601-8398-4635bd824450', 'efe05d07-19c1-35e8-aed2-55f2e0e2821e', 'Ibuprofeno 400mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00092 (Carmen Torres Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('5b2bf4d0-6cd1-3c4b-ad85-1acc5fab672f', 'NIF-00091', 'Carmen Torres Navarro', '1981-08-08', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('4a8fd107-d9ae-3b3f-82ee-f4fb9f81e09f', '5b2bf4d0-6cd1-3c4b-ad85-1acc5fab672f', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ac2276df-fd92-3309-9a2e-5729e0dd54cc', '5b2bf4d0-6cd1-3c4b-ad85-1acc5fab672f', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('4283a95d-99d2-33bd-9588-c706b366c9c8', '4a8fd107-d9ae-3b3f-82ee-f4fb9f81e09f', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('873b7f93-8239-39e5-9197-4e98805b56be', '4a8fd107-d9ae-3b3f-82ee-f4fb9f81e09f', 'Ibuprofeno 400mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00093 (Miguel Ruiz Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('7cc6e6ac-3875-3a17-821d-b1ebc8761554', 'NIF-00092', 'Miguel Ruiz Navarro', '1982-09-09', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('09b7b70a-a7fc-3e1c-a572-80f42054bf18', '7cc6e6ac-3875-3a17-821d-b1ebc8761554', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('3b971ed0-2c5d-36c9-9900-4149fe5a2d44', '7cc6e6ac-3875-3a17-821d-b1ebc8761554', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('e1df1289-d89a-349e-a73a-7755a9ca547f', '09b7b70a-a7fc-3e1c-a572-80f42054bf18', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('56c86d66-e1d2-3cc5-b3da-256a2f7da1be', '09b7b70a-a7fc-3e1c-a572-80f42054bf18', 'Losartán 50mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00094 (Ana Vega Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('fc831c60-a0a5-3b96-9233-a50fc94eb780', 'NIF-00093', 'Ana Vega Navarro', '1983-10-10', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('c4ab7626-e3bf-3762-9564-9d407508205f', 'fc831c60-a0a5-3b96-9233-a50fc94eb780', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('c993b8b8-5902-3bd3-9297-6331d4efe638', 'fc831c60-a0a5-3b96-9233-a50fc94eb780', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('70b67d2e-9e2e-3cc4-8412-085eaa2dad46', 'c4ab7626-e3bf-3762-9564-9d407508205f', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('7441e526-beab-3c4e-b7fc-211c76cf54ea', 'c4ab7626-e3bf-3762-9564-9d407508205f', 'Atorvastatina 20mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00095 (Pablo Molina Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('1b1a5050-fbb3-34d7-883f-5d76aba4a0a4', 'NIF-00094', 'Pablo Molina Navarro', '1984-11-11', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('65a35ff0-5711-3676-9e8b-670bb41c2f8a', '1b1a5050-fbb3-34d7-883f-5d76aba4a0a4', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('db2e217c-05f3-3b51-90c5-515237a2c7da', '1b1a5050-fbb3-34d7-883f-5d76aba4a0a4', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('b7ef28b3-e19a-3c12-9eb0-e2ca00e48107', '65a35ff0-5711-3676-9e8b-670bb41c2f8a', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('077101ac-30b9-37b9-9c4c-c1e8f1873ff0', '65a35ff0-5711-3676-9e8b-670bb41c2f8a', 'Ibuprofeno 400mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00096 (Laura Ortega Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('10a8c062-0ab4-3dc6-8848-52adea5e51bc', 'NIF-00095', 'Laura Ortega Navarro', '1985-12-12', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('d481336f-bb99-3384-a4b3-ae7e19c0190a', '10a8c062-0ab4-3dc6-8848-52adea5e51bc', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('4e12f04b-b9ab-33da-9204-35428f0d0a42', '10a8c062-0ab4-3dc6-8848-52adea5e51bc', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('b3f8677b-ad58-3397-8ad6-c5542be6e638', 'd481336f-bb99-3384-a4b3-ae7e19c0190a', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('6a39cf96-8d80-3aa5-9cc6-b9b70b34452d', 'd481336f-bb99-3384-a4b3-ae7e19c0190a', 'Atorvastatina 20mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00097 (Andrés Castro Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('7351c6d5-fb10-3ace-8d86-46dd53481af1', 'NIF-00096', 'Andrés Castro Navarro', '1986-01-13', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('fe340a6b-7b1b-3a68-bc95-30130166a430', '7351c6d5-fb10-3ace-8d86-46dd53481af1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('d21b5788-aa4a-352d-87a0-4e94599956b1', '7351c6d5-fb10-3ace-8d86-46dd53481af1', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('f07ea2ab-345d-3a69-b0d7-2d26c7bd9470', 'fe340a6b-7b1b-3a68-bc95-30130166a430', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('5c5d4a5b-ed17-302c-8689-419cd208026f', 'fe340a6b-7b1b-3a68-bc95-30130166a430', 'Paracetamol 1g', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00098 (Sofía Delgado Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('5de96663-2c41-3f58-b398-f884458160df', 'NIF-00097', 'Sofía Delgado Navarro', '1987-02-14', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('3d591768-e9dd-3ea9-b0e8-c4cd2e155934', '5de96663-2c41-3f58-b398-f884458160df', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('80603ebf-4519-3afa-94f0-bc2e31684fc3', '5de96663-2c41-3f58-b398-f884458160df', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('a8d636f9-017b-3320-874e-370693a84c08', '3d591768-e9dd-3ea9-b0e8-c4cd2e155934', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('a89f97db-12e7-3ad0-9134-ee8dc5fa487b', '3d591768-e9dd-3ea9-b0e8-c4cd2e155934', 'Atorvastatina 20mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00099 (Álvaro Serrano Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('4360b8dc-5f57-32ad-9905-dc8db37b1ba6', 'NIF-00098', 'Álvaro Serrano Navarro', '1988-03-15', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('469a477b-3496-3131-8529-9b684ec91baf', '4360b8dc-5f57-32ad-9905-dc8db37b1ba6', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('fd6ed242-838a-3e8c-b497-b80b6a1e5d24', '4360b8dc-5f57-32ad-9905-dc8db37b1ba6', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('0af07f2a-19e6-36fc-89b2-b6ab47058bb7', '469a477b-3496-3131-8529-9b684ec91baf', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('47b186ee-4abe-34c0-91b2-14a41bdfcd7d', '469a477b-3496-3131-8529-9b684ec91baf', 'Paracetamol 1g', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00100 (Nuria Cortés Navarro)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('2dcf9261-70ad-3e13-a6c0-c37d3a4fd354', 'NIF-00099', 'Nuria Cortés Navarro', '1989-04-16', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('7088e6b3-bd04-3c5e-ac93-2478b0b9f0c6', '2dcf9261-70ad-3e13-a6c0-c37d3a4fd354', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('8f20acfd-83a9-36d1-acf6-c0cf882f0d4d', '2dcf9261-70ad-3e13-a6c0-c37d3a4fd354', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('77202df1-23fd-36eb-a55e-53ffffeb3ff3', '7088e6b3-bd04-3c5e-ac93-2478b0b9f0c6', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('22893c97-4297-3618-9dc6-a548162c383c', '7088e6b3-bd04-3c5e-ac93-2478b0b9f0c6', 'Metformina 850mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00101 (Juan García Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('4f6f9429-5faf-32c9-b60d-fb7161a0392e', 'NIF-00100', 'Juan García Mendoza', '1940-05-17', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('6ead0d6b-c2c0-37d3-948b-c4bad4e3af81', '4f6f9429-5faf-32c9-b60d-fb7161a0392e', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('078da241-5e84-31e8-8b83-4dc4f42b0273', '4f6f9429-5faf-32c9-b60d-fb7161a0392e', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('63809937-3af8-3bd5-97e4-157168f2c1dd', '6ead0d6b-c2c0-37d3-948b-c4bad4e3af81', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('42d489c2-b3cc-319f-83e1-5806b89fbb9d', '6ead0d6b-c2c0-37d3-948b-c4bad4e3af81', 'Ibuprofeno 400mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00102 (Carmen López Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('35c17195-3f98-3b65-b0c3-f56618645a5f', 'NIF-00101', 'Carmen López Mendoza', '1941-06-18', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('43f7c84f-b727-3f74-a47d-c0f4bf55b6bc', '35c17195-3f98-3b65-b0c3-f56618645a5f', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('382c754b-c3d7-3045-93fa-64779ebf35af', '35c17195-3f98-3b65-b0c3-f56618645a5f', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('160dd345-56b5-3337-b466-5bbb0fef4dd0', '43f7c84f-b727-3f74-a47d-c0f4bf55b6bc', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('eb802420-6c8d-3324-80a0-f47eb94240e2', '43f7c84f-b727-3f74-a47d-c0f4bf55b6bc', 'Losartán 50mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00103 (Miguel Martínez Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('2234d72c-65d4-343c-8d41-24d9c296e44f', 'NIF-00102', 'Miguel Martínez Mendoza', '1942-07-19', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('0eeb989d-616c-3931-8fe4-9037db80bb63', '2234d72c-65d4-343c-8d41-24d9c296e44f', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('87d2e761-c789-35fd-8cc9-e7606e3ecf1b', '2234d72c-65d4-343c-8d41-24d9c296e44f', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('6d9653e0-e80b-3613-b335-de9aa9fdf0a2', '0eeb989d-616c-3931-8fe4-9037db80bb63', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('36ef4198-d5eb-3451-97e8-3700a0a0a7d9', '0eeb989d-616c-3931-8fe4-9037db80bb63', 'Levotiroxina 50mcg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00104 (Ana Sánchez Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('f4f10058-6b3c-3571-8de4-2c9dcd35e7ab', 'NIF-00103', 'Ana Sánchez Mendoza', '1943-08-20', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('8dc3e839-32c7-3794-b828-e63af301dcce', 'f4f10058-6b3c-3571-8de4-2c9dcd35e7ab', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('be671df3-7d91-34f7-b057-9eb68e48b181', 'f4f10058-6b3c-3571-8de4-2c9dcd35e7ab', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('496f0113-0370-3832-a160-f5fb3ce59553', '8dc3e839-32c7-3794-b828-e63af301dcce', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('72549bef-0e65-3678-a3a4-6d6e382e8037', '8dc3e839-32c7-3794-b828-e63af301dcce', 'Ibuprofeno 400mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00105 (Pablo Pérez Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('987bc2a8-176f-3b4b-8304-bc9c7ba2f428', 'NIF-00104', 'Pablo Pérez Mendoza', '1944-09-21', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('5caa3685-c8f1-31df-a9a1-2156b0298dc4', '987bc2a8-176f-3b4b-8304-bc9c7ba2f428', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('67fb1952-624a-309c-b351-b0781398b0c9', '987bc2a8-176f-3b4b-8304-bc9c7ba2f428', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('9d04bc3c-5c5b-3996-8ee0-17c8b49fc044', '5caa3685-c8f1-31df-a9a1-2156b0298dc4', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('57f9c053-a774-3ea5-868b-7deefb03eadf', '5caa3685-c8f1-31df-a9a1-2156b0298dc4', 'Ibuprofeno 400mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00106 (Laura Gómez Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('8afb9b9d-1922-337a-9a47-86213a56a5fa', 'NIF-00105', 'Laura Gómez Mendoza', '1945-10-22', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('d62921b4-4d8f-3cfd-9e67-3e3516313d28', '8afb9b9d-1922-337a-9a47-86213a56a5fa', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('2fad0b22-cee6-388c-be3e-8af40c810c05', '8afb9b9d-1922-337a-9a47-86213a56a5fa', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('28b5c417-e7d8-30b2-b2a9-35bcd3eca711', 'd62921b4-4d8f-3cfd-9e67-3e3516313d28', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('1b02a9e8-dc43-3f6e-9292-675be88abe7f', 'd62921b4-4d8f-3cfd-9e67-3e3516313d28', 'Paracetamol 1g', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00107 (Andrés Fernández Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('f9751536-9de3-3629-ab30-559e3a287f13', 'NIF-00106', 'Andrés Fernández Mendoza', '1946-11-23', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('f09f35ec-c827-31d2-8ed6-62e73942a41c', 'f9751536-9de3-3629-ab30-559e3a287f13', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('2b6bedce-989c-321b-82f7-8781b9b0feda', 'f9751536-9de3-3629-ab30-559e3a287f13', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('3d82448b-9855-37b1-ba67-6530d6b9acae', 'f09f35ec-c827-31d2-8ed6-62e73942a41c', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('36db6f95-9714-3287-bfb1-1fd041369ae4', 'f09f35ec-c827-31d2-8ed6-62e73942a41c', 'Metformina 850mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00108 (Sofía Díaz Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('09516ea6-0a85-34e8-ad79-e21046b664cb', 'NIF-00107', 'Sofía Díaz Mendoza', '1947-12-24', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('4f9c933f-0d52-39da-8e29-03a0fb150095', '09516ea6-0a85-34e8-ad79-e21046b664cb', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('fd8e78ed-250e-34d6-976a-d297c97bebb0', '09516ea6-0a85-34e8-ad79-e21046b664cb', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('8e64dc3f-4b94-35e6-a4ee-eb52c124f2ec', '4f9c933f-0d52-39da-8e29-03a0fb150095', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('2918b4cc-6cb2-3a4d-8a28-4c4c419e8912', '4f9c933f-0d52-39da-8e29-03a0fb150095', 'Levotiroxina 50mcg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00109 (Álvaro Álvarez Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('ce366381-e58e-3ccf-954e-b477f15e9846', 'NIF-00108', 'Álvaro Álvarez Mendoza', '1948-01-25', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('44a8fdb0-4a81-357b-b1b3-a909c2f19abd', 'ce366381-e58e-3ccf-954e-b477f15e9846', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('cea82b0a-4502-364a-ae48-2578fd61c05c', 'ce366381-e58e-3ccf-954e-b477f15e9846', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('b7f500cd-54e2-3f37-8840-cdae12a76d6b', '44a8fdb0-4a81-357b-b1b3-a909c2f19abd', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('3f9bd7f5-3e09-381d-b41d-5db748b3463b', '44a8fdb0-4a81-357b-b1b3-a909c2f19abd', 'Paracetamol 1g', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00110 (Nuria Romero Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('d6a807c5-e739-34ff-814f-baa8e28bc1b3', 'NIF-00109', 'Nuria Romero Mendoza', '1949-02-26', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('b6632ad1-3831-3376-80f5-cf7dcc8e795e', 'd6a807c5-e739-34ff-814f-baa8e28bc1b3', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('d0ca8e7e-051d-3803-8a99-c5ca841da066', 'd6a807c5-e739-34ff-814f-baa8e28bc1b3', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('b3907ef2-f4d5-333b-8fd7-7ead4580a673', 'b6632ad1-3831-3376-80f5-cf7dcc8e795e', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('33b2db49-43f2-38d4-a38c-43649918d1d5', 'b6632ad1-3831-3376-80f5-cf7dcc8e795e', 'Losartán 50mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00111 (Juan Navarro Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('98a662ec-1766-34b7-bb51-418ab467b2b7', 'NIF-00110', 'Juan Navarro Mendoza', '1950-03-27', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('fb1406ee-05e0-32ed-a42b-1cc5dca28e3f', '98a662ec-1766-34b7-bb51-418ab467b2b7', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('346ede03-9f00-34b9-b565-0747f908b428', '98a662ec-1766-34b7-bb51-418ab467b2b7', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('04855057-6cd1-39ac-bd99-921081060509', 'fb1406ee-05e0-32ed-a42b-1cc5dca28e3f', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('3b5e05bf-a275-3255-97b2-a3b0841ad7de', 'fb1406ee-05e0-32ed-a42b-1cc5dca28e3f', 'Losartán 50mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00112 (Carmen Torres Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('0be6e549-d320-3555-87b8-cb9e8812bdd5', 'NIF-00111', 'Carmen Torres Mendoza', '1951-04-28', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('3cbaec62-4797-3b34-895a-8856a1924466', '0be6e549-d320-3555-87b8-cb9e8812bdd5', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('3a0cb884-240a-3c10-9d00-06833464c351', '0be6e549-d320-3555-87b8-cb9e8812bdd5', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('499363f2-b6f9-30ce-b399-bdc6b2c98570', '3cbaec62-4797-3b34-895a-8856a1924466', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('8a07da0e-0f2b-39bf-a124-da29f45976fa', '3cbaec62-4797-3b34-895a-8856a1924466', 'Paracetamol 1g', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00113 (Miguel Ruiz Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('ff067c30-8884-39aa-9d65-698b8eb67dd5', 'NIF-00112', 'Miguel Ruiz Mendoza', '1952-05-01', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('347a8f0b-e12f-3575-bfa8-e39f19481826', 'ff067c30-8884-39aa-9d65-698b8eb67dd5', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('33e6081c-3fd5-36ce-ac57-b747bbe0f54c', 'ff067c30-8884-39aa-9d65-698b8eb67dd5', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('2f5428ff-f711-36b2-bf1c-57b086d6159f', '347a8f0b-e12f-3575-bfa8-e39f19481826', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('278e23ff-e575-3e61-94a0-704164b11b01', '347a8f0b-e12f-3575-bfa8-e39f19481826', 'Atorvastatina 20mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00114 (Ana Vega Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('c9926e55-429c-3cb8-9014-3d062bbb7aa3', 'NIF-00113', 'Ana Vega Mendoza', '1953-06-02', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('273d15b1-b644-3dd0-9788-19937237fdb0', 'c9926e55-429c-3cb8-9014-3d062bbb7aa3', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ae799b01-4471-396d-8eaf-8963b6fb8968', 'c9926e55-429c-3cb8-9014-3d062bbb7aa3', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('653d3b85-f5fd-3591-b009-fdf98b56df38', '273d15b1-b644-3dd0-9788-19937237fdb0', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('9e0c2fb4-41a2-361f-8d59-b7bb0da21457', '273d15b1-b644-3dd0-9788-19937237fdb0', 'Salbutamol Inhalador', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00115 (Pablo Molina Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('96ac2281-7973-3516-b24e-7fe5ab02d000', 'NIF-00114', 'Pablo Molina Mendoza', '1954-07-03', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('f0542f8f-beb7-3084-a517-4867b45b1812', '96ac2281-7973-3516-b24e-7fe5ab02d000', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('dd9e21f0-2e1c-386d-b815-f117cc466ef2', '96ac2281-7973-3516-b24e-7fe5ab02d000', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('75c49d58-d427-3a02-bf2a-d709d9e31c81', 'f0542f8f-beb7-3084-a517-4867b45b1812', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('5d7d1554-6fc8-34a6-8c62-161164d85a80', 'f0542f8f-beb7-3084-a517-4867b45b1812', 'Atorvastatina 20mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00116 (Laura Ortega Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('8febfc0b-6e9c-3e2d-b9c5-de46f6dcc056', 'NIF-00115', 'Laura Ortega Mendoza', '1955-08-04', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('0e7a6e43-79fd-3314-8482-04dad2981d23', '8febfc0b-6e9c-3e2d-b9c5-de46f6dcc056', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('970f7f5b-a171-36d4-98af-28a939c906e2', '8febfc0b-6e9c-3e2d-b9c5-de46f6dcc056', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('b207dc1f-8df7-3585-a593-00a58421dc07', '0e7a6e43-79fd-3314-8482-04dad2981d23', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('407b67ab-2c4a-37e7-8d27-ffb5ef2f0d0c', '0e7a6e43-79fd-3314-8482-04dad2981d23', 'Paracetamol 1g', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00117 (Andrés Castro Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('85b52e71-b942-3da7-8ecc-57bed8f4eae9', 'NIF-00116', 'Andrés Castro Mendoza', '1956-09-05', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('78c241c2-d42c-31f6-bbf1-05d516ad35f7', '85b52e71-b942-3da7-8ecc-57bed8f4eae9', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('f8d48db5-efe7-33ce-b56d-d9ad216bfe87', '85b52e71-b942-3da7-8ecc-57bed8f4eae9', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('54e6167d-a43a-3244-bf62-1ce903aaa6b5', '78c241c2-d42c-31f6-bbf1-05d516ad35f7', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('94f36550-de06-3568-ab5b-bdfc1c0dbb10', '78c241c2-d42c-31f6-bbf1-05d516ad35f7', 'Losartán 50mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00118 (Sofía Delgado Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('5d5b2e48-d76c-3ebc-a64c-6d134ba2d0ff', 'NIF-00117', 'Sofía Delgado Mendoza', '1957-10-06', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('bab277d1-5595-3691-8f4c-3e84279b9264', '5d5b2e48-d76c-3ebc-a64c-6d134ba2d0ff', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('8e5f6c5b-4268-328c-8fff-e6c89d4b8759', '5d5b2e48-d76c-3ebc-a64c-6d134ba2d0ff', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('f077bd5e-d8be-36b8-8a0e-2216d568971a', 'bab277d1-5595-3691-8f4c-3e84279b9264', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('e0bc72b2-f149-3ac5-8370-ee5d09b2436d', 'bab277d1-5595-3691-8f4c-3e84279b9264', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00119 (Álvaro Serrano Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('0a03abaf-d6b0-3f9d-8eb8-5cb54c338698', 'NIF-00118', 'Álvaro Serrano Mendoza', '1958-11-07', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('e6613a8f-e5e3-3a67-800b-ec56615cb40c', '0a03abaf-d6b0-3f9d-8eb8-5cb54c338698', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('fb8a6917-bf73-3cf9-87d2-69a7e3053dd2', '0a03abaf-d6b0-3f9d-8eb8-5cb54c338698', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('027ed9a2-e5d8-3ca2-92fd-45a1b0b656e7', 'e6613a8f-e5e3-3a67-800b-ec56615cb40c', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('98701eb6-19b8-3d20-ac21-df54ff5ee8ba', 'e6613a8f-e5e3-3a67-800b-ec56615cb40c', 'Paracetamol 1g', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00120 (Nuria Cortés Mendoza)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('15045070-27db-30c0-850d-8149fb060eb1', 'NIF-00119', 'Nuria Cortés Mendoza', '1959-12-08', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('2ca4bf1d-9cf3-3f99-b021-60e71e0beb58', '15045070-27db-30c0-850d-8149fb060eb1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('86a9bde3-1a58-3258-9006-7a46c6f06184', '15045070-27db-30c0-850d-8149fb060eb1', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('7d0fde3a-a5cb-3261-afad-a19d84095b97', '2ca4bf1d-9cf3-3f99-b021-60e71e0beb58', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('12db7f44-39e3-382b-a455-c1a5c27bb713', '2ca4bf1d-9cf3-3f99-b021-60e71e0beb58', 'Salbutamol Inhalador', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00121 (Juan García Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('ce406242-0d2d-3b9c-aa83-5ae27397c273', 'NIF-00120', 'Juan García Prieto', '1960-01-09', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('b3d13acc-8129-3cc6-bc3d-76133a8b608a', 'ce406242-0d2d-3b9c-aa83-5ae27397c273', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('0a42d806-2f74-314b-bf82-677ae6c74aae', 'ce406242-0d2d-3b9c-aa83-5ae27397c273', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('515a1934-2399-3967-931a-c3c21faecd12', 'b3d13acc-8129-3cc6-bc3d-76133a8b608a', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('07f9d21f-6e01-3ba5-b9c5-ff67501cc06b', 'b3d13acc-8129-3cc6-bc3d-76133a8b608a', 'Atorvastatina 20mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00122 (Carmen López Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('53e80929-85ee-356d-87e9-6dd267c49aac', 'NIF-00121', 'Carmen López Prieto', '1961-02-10', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('4ada2154-16a0-3086-93a8-f8c06136adf1', '53e80929-85ee-356d-87e9-6dd267c49aac', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ed3a9f05-1548-3853-bba5-34398bfca37a', '53e80929-85ee-356d-87e9-6dd267c49aac', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('8301beae-850c-3b0c-927a-19c8b316b19c', '4ada2154-16a0-3086-93a8-f8c06136adf1', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('6aafef70-8b2a-3926-a5b5-47a3d360c0ba', '4ada2154-16a0-3086-93a8-f8c06136adf1', 'Ibuprofeno 400mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00123 (Miguel Martínez Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('a458e1eb-ae67-3e4e-a7ec-cdac0fe1dcfd', 'NIF-00122', 'Miguel Martínez Prieto', '1962-03-11', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('689599f0-beb4-3063-85b6-35c207eb1f8a', 'a458e1eb-ae67-3e4e-a7ec-cdac0fe1dcfd', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ffdd3a67-6e1b-3aad-9af5-53288ba1e4bf', 'a458e1eb-ae67-3e4e-a7ec-cdac0fe1dcfd', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('04815bfd-eed8-3427-8484-4de55ccc2cdf', '689599f0-beb4-3063-85b6-35c207eb1f8a', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('22081894-6f11-351f-87dd-497175a3643c', '689599f0-beb4-3063-85b6-35c207eb1f8a', 'Atorvastatina 20mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00124 (Ana Sánchez Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('477d3c20-1065-39a4-a258-9d312a644ade', 'NIF-00123', 'Ana Sánchez Prieto', '1963-04-12', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('f9869a64-8acd-33b5-a007-8b251dc191b7', '477d3c20-1065-39a4-a258-9d312a644ade', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('4eb6ac89-f662-3628-a3a7-f961a22b963b', '477d3c20-1065-39a4-a258-9d312a644ade', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('8aa92506-0ee8-3d9b-83f2-c8950c8b2c00', 'f9869a64-8acd-33b5-a007-8b251dc191b7', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('b10e9cb1-8441-3388-a915-6fa953d8c751', 'f9869a64-8acd-33b5-a007-8b251dc191b7', 'Ibuprofeno 400mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00125 (Pablo Pérez Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('0cc83fdd-79ad-38d8-9d4e-af955e9a3a70', 'NIF-00124', 'Pablo Pérez Prieto', '1964-05-13', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('3511d3a8-00ae-3b75-b949-2ddafc1daf8f', '0cc83fdd-79ad-38d8-9d4e-af955e9a3a70', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('767630fa-9775-3574-a2cf-10d03e13daf6', '0cc83fdd-79ad-38d8-9d4e-af955e9a3a70', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('b6210115-b87f-3217-aac2-7d9ff6e9bdf1', '3511d3a8-00ae-3b75-b949-2ddafc1daf8f', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('fb4aaf9f-5590-3b35-aa7f-eefd3704db39', '3511d3a8-00ae-3b75-b949-2ddafc1daf8f', 'Atorvastatina 20mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00126 (Laura Gómez Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('2f4087cc-4c85-3cf8-ae78-cd15de1ea1ed', 'NIF-00125', 'Laura Gómez Prieto', '1965-06-14', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('892b9fd4-1975-34dc-808e-136c73d70118', '2f4087cc-4c85-3cf8-ae78-cd15de1ea1ed', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('a5fa021c-386d-3c19-bb63-3200af6cea57', '2f4087cc-4c85-3cf8-ae78-cd15de1ea1ed', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('185c58bf-f58e-36be-abef-aed348e5aad4', '892b9fd4-1975-34dc-808e-136c73d70118', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('5504bfde-23d6-3eb2-9ec9-2f524bb514da', '892b9fd4-1975-34dc-808e-136c73d70118', 'Salbutamol Inhalador', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00127 (Andrés Fernández Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('2376db4b-9074-31d8-b632-77b1c3c7ed99', 'NIF-00126', 'Andrés Fernández Prieto', '1966-07-15', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('c08b9f73-fe31-300b-86dc-d6d3da4bb8e3', '2376db4b-9074-31d8-b632-77b1c3c7ed99', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('3066420a-d104-35aa-9ac7-bcf183dcd360', '2376db4b-9074-31d8-b632-77b1c3c7ed99', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('c1fe4e0e-eb15-3803-9bfc-76581f362fe3', 'c08b9f73-fe31-300b-86dc-d6d3da4bb8e3', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('ebe694d7-c541-31c5-8dff-f67cf80cb9e7', 'c08b9f73-fe31-300b-86dc-d6d3da4bb8e3', 'Metformina 850mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00128 (Sofía Díaz Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('ee8970c2-03f2-3488-93a0-39d4e137d93f', 'NIF-00127', 'Sofía Díaz Prieto', '1967-08-16', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('d674a5f4-64a9-3676-8612-9fc8ba808c21', 'ee8970c2-03f2-3488-93a0-39d4e137d93f', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('e469140a-d821-34d5-a785-0796e5b8f78e', 'ee8970c2-03f2-3488-93a0-39d4e137d93f', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('58c04a9d-545e-35c7-9e62-2203cdae78b9', 'd674a5f4-64a9-3676-8612-9fc8ba808c21', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('49cba3fb-ceb4-322b-a479-e422f169ad77', 'd674a5f4-64a9-3676-8612-9fc8ba808c21', 'Ibuprofeno 400mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00129 (Álvaro Álvarez Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('d60fc934-930c-3ee7-8612-9729bd22449d', 'NIF-00128', 'Álvaro Álvarez Prieto', '1968-09-17', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('e9bd787f-6b4d-34c3-80ff-1499e429ee2d', 'd60fc934-930c-3ee7-8612-9729bd22449d', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('818a85d1-e1c4-383b-821a-572916e834dc', 'd60fc934-930c-3ee7-8612-9729bd22449d', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('8797a827-7b04-3a13-9958-9e9048eb84b9', 'e9bd787f-6b4d-34c3-80ff-1499e429ee2d', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('5a37df9d-68a2-3285-a410-252ba70064a3', 'e9bd787f-6b4d-34c3-80ff-1499e429ee2d', 'Ibuprofeno 400mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00130 (Nuria Romero Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('fa3b7a38-41ae-3789-8f5b-cec15025d6c2', 'NIF-00129', 'Nuria Romero Prieto', '1969-10-18', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('de1bfcde-c015-36cc-9a5d-39349c0f634c', 'fa3b7a38-41ae-3789-8f5b-cec15025d6c2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('b1bbfe28-f081-3204-83c4-c7a080a5b403', 'fa3b7a38-41ae-3789-8f5b-cec15025d6c2', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('084374c0-cf02-3e63-9587-0a47425a2599', 'de1bfcde-c015-36cc-9a5d-39349c0f634c', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('26b6646f-274d-3f25-9be1-f3e02c300d2d', 'de1bfcde-c015-36cc-9a5d-39349c0f634c', 'Losartán 50mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00131 (Juan Navarro Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('4938573f-7c1c-33be-981c-308a6e5d4e2e', 'NIF-00130', 'Juan Navarro Prieto', '1970-11-19', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('12b6b6f2-0a72-3c84-893c-1f3d80153b0a', '4938573f-7c1c-33be-981c-308a6e5d4e2e', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('7c05728d-05dc-375f-b539-f1d41d38b7ee', '4938573f-7c1c-33be-981c-308a6e5d4e2e', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('6d77e9f1-f7d5-35c8-816b-af32f4d2d881', '12b6b6f2-0a72-3c84-893c-1f3d80153b0a', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('d761541c-ee5d-314c-b1ca-41da3c69afe8', '12b6b6f2-0a72-3c84-893c-1f3d80153b0a', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00132 (Carmen Torres Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('ef8a91f6-9c13-35e6-a0e3-07b838fe4061', 'NIF-00131', 'Carmen Torres Prieto', '1971-12-20', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('19a4b829-4037-3571-8ea4-985b6ea2c684', 'ef8a91f6-9c13-35e6-a0e3-07b838fe4061', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('2b473b0e-1e5a-3138-92bf-bc2f56279453', 'ef8a91f6-9c13-35e6-a0e3-07b838fe4061', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('3e7c26c5-fb80-3556-9161-7c1bad867c14', '19a4b829-4037-3571-8ea4-985b6ea2c684', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('bc175e5a-38a5-3774-b252-db81e4ddc1fd', '19a4b829-4037-3571-8ea4-985b6ea2c684', 'Atorvastatina 20mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00133 (Miguel Ruiz Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('2802a4f7-1f3a-317e-b7cb-20d8cc8852ae', 'NIF-00132', 'Miguel Ruiz Prieto', '1972-01-21', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('7df9109e-c3a6-3aea-ade8-ee4b468b2baa', '2802a4f7-1f3a-317e-b7cb-20d8cc8852ae', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('abf1ce5f-4d2d-341f-b92c-5cd3b58870a2', '2802a4f7-1f3a-317e-b7cb-20d8cc8852ae', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('a7eb0d51-bcdb-331c-930b-22a9bf8dd4db', '7df9109e-c3a6-3aea-ade8-ee4b468b2baa', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('8626de3b-5a28-3436-a2b1-ca43ff498d28', '7df9109e-c3a6-3aea-ade8-ee4b468b2baa', 'Losartán 50mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00134 (Ana Vega Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('6265922e-51c3-3acd-982d-d85e3d5390f7', 'NIF-00133', 'Ana Vega Prieto', '1973-02-22', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('07a3ce4a-8714-3f1f-b1e8-7baf2fe8d11c', '6265922e-51c3-3acd-982d-d85e3d5390f7', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('99614b0c-a520-38a0-afb9-b95b503355d1', '6265922e-51c3-3acd-982d-d85e3d5390f7', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('95283428-0088-39be-a6b1-21dbd8fb3fc5', '07a3ce4a-8714-3f1f-b1e8-7baf2fe8d11c', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('ce1448b1-1202-39da-9fe6-dfe36f37d9ca', '07a3ce4a-8714-3f1f-b1e8-7baf2fe8d11c', 'Atorvastatina 20mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00135 (Pablo Molina Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('eeda8e94-ed0a-31cc-9b63-43710444bfc3', 'NIF-00134', 'Pablo Molina Prieto', '1974-03-23', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('07380049-6736-3a7d-9ea4-c14eebde2b0a', 'eeda8e94-ed0a-31cc-9b63-43710444bfc3', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('2a4b0483-1ffb-3943-8376-4d3878db0e59', 'eeda8e94-ed0a-31cc-9b63-43710444bfc3', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('25c98a59-7b03-3eb5-8570-80f5c1e613b3', '07380049-6736-3a7d-9ea4-c14eebde2b0a', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('49e9d8e7-5084-3419-b173-b81f1615af09', '07380049-6736-3a7d-9ea4-c14eebde2b0a', 'Paracetamol 1g', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00136 (Laura Ortega Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('4bcd03d2-6ed0-3fb0-8d27-b62a3af2357b', 'NIF-00135', 'Laura Ortega Prieto', '1975-04-24', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('9aa2600d-c4d1-36d2-ac69-8554e5c898e8', '4bcd03d2-6ed0-3fb0-8d27-b62a3af2357b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('746df428-c8ef-3501-a31e-92dadb2716e5', '4bcd03d2-6ed0-3fb0-8d27-b62a3af2357b', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('d3a8e082-120b-3e68-ab3a-0723116b5184', '9aa2600d-c4d1-36d2-ac69-8554e5c898e8', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('1ea24613-2d7b-3ce4-88bb-b2bece201ccb', '9aa2600d-c4d1-36d2-ac69-8554e5c898e8', 'Metformina 850mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00137 (Andrés Castro Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('a5a91fa1-94d8-3790-9d50-0b4b4e8196de', 'NIF-00136', 'Andrés Castro Prieto', '1976-05-25', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('96bcc79d-9058-3df0-9a35-afa39ba9148d', 'a5a91fa1-94d8-3790-9d50-0b4b4e8196de', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('b6a7a59d-5bb1-3f07-8034-feb045567fed', 'a5a91fa1-94d8-3790-9d50-0b4b4e8196de', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('134989a8-9cba-3854-922e-6e4713beaa8c', '96bcc79d-9058-3df0-9a35-afa39ba9148d', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('16532732-b91e-3628-b515-8890812010a1', '96bcc79d-9058-3df0-9a35-afa39ba9148d', 'Levotiroxina 50mcg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00138 (Sofía Delgado Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('39e1f3cc-9495-30f3-b44a-29b1f8904ff9', 'NIF-00137', 'Sofía Delgado Prieto', '1977-06-26', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('9c680236-c55b-32e8-b167-757b594a8516', '39e1f3cc-9495-30f3-b44a-29b1f8904ff9', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('d1a54f2d-9534-3dce-be97-36829d6aea69', '39e1f3cc-9495-30f3-b44a-29b1f8904ff9', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('55267411-6937-3286-8834-e1b858983e41', '9c680236-c55b-32e8-b167-757b594a8516', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('85f715c5-c48b-3410-867e-19f1591b21ec', '9c680236-c55b-32e8-b167-757b594a8516', 'Metformina 850mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00139 (Álvaro Serrano Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('b5416893-5808-30ea-a130-4404cede3ef1', 'NIF-00138', 'Álvaro Serrano Prieto', '1978-07-27', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('d948761b-e136-3487-8783-84052a7de17e', 'b5416893-5808-30ea-a130-4404cede3ef1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('21ff2c2e-c789-3c75-a737-4f725c140284', 'b5416893-5808-30ea-a130-4404cede3ef1', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('5358638b-6694-3ea1-9710-8c5e24b23174', 'd948761b-e136-3487-8783-84052a7de17e', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('521bfbf7-32da-3a61-a9ad-e94f515b9768', 'd948761b-e136-3487-8783-84052a7de17e', 'Losartán 50mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00140 (Nuria Cortés Prieto)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('e71af49e-075e-36e0-a24c-c4f715d1e556', 'NIF-00139', 'Nuria Cortés Prieto', '1979-08-28', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('7e0a1108-6d11-36ed-9ee6-0a0fbb22d9c8', 'e71af49e-075e-36e0-a24c-c4f715d1e556', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('82d7b3eb-6262-3fb3-9b81-f424efc6df53', 'e71af49e-075e-36e0-a24c-c4f715d1e556', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('7f1cea13-54a0-30dd-96af-ba342a037a33', '7e0a1108-6d11-36ed-9ee6-0a0fbb22d9c8', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('4a6947ef-e2ba-3fa2-ae33-297d211e62cc', '7e0a1108-6d11-36ed-9ee6-0a0fbb22d9c8', 'Atorvastatina 20mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00141 (Juan García Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('0769ede1-f411-3e3a-b531-ad78be7f9270', 'NIF-00140', 'Juan García Santos', '1980-09-01', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('24832874-a1ca-3bb1-9e75-bfa51d1fd07a', '0769ede1-f411-3e3a-b531-ad78be7f9270', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('05a8d4bc-0dfa-3901-81e9-b29cfcf60f17', '0769ede1-f411-3e3a-b531-ad78be7f9270', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('466e7109-368e-3646-a5d2-355a82b03823', '24832874-a1ca-3bb1-9e75-bfa51d1fd07a', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('e61c0837-eb69-3c28-bd0b-d3097c1b1023', '24832874-a1ca-3bb1-9e75-bfa51d1fd07a', 'Losartán 50mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00142 (Carmen López Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('3d006418-6e02-309d-a950-2854ae1d82db', 'NIF-00141', 'Carmen López Santos', '1981-10-02', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('b910a27f-42a6-37b6-841b-2b30184a8861', '3d006418-6e02-309d-a950-2854ae1d82db', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('6c123139-cf11-384e-a39c-a65ac6835dd4', '3d006418-6e02-309d-a950-2854ae1d82db', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('559e2a2d-6886-3e20-a5ea-d53dc8a9a597', 'b910a27f-42a6-37b6-841b-2b30184a8861', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('96021ff6-9efa-325b-ad78-5b806ffb826a', 'b910a27f-42a6-37b6-841b-2b30184a8861', 'Losartán 50mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00143 (Miguel Martínez Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('315c4d48-0228-3655-9e72-e47a211a0516', 'NIF-00142', 'Miguel Martínez Santos', '1982-11-03', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('05ff886b-6f3f-3f41-a3d0-53861fb2ed01', '315c4d48-0228-3655-9e72-e47a211a0516', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('e9f00e6a-9add-31d7-8ecd-c62c5861af07', '315c4d48-0228-3655-9e72-e47a211a0516', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('7c772d7b-d2d5-35f3-a382-c1f39afac9b2', '05ff886b-6f3f-3f41-a3d0-53861fb2ed01', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('410be23f-766b-3862-8869-249dd6f7f76d', '05ff886b-6f3f-3f41-a3d0-53861fb2ed01', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00144 (Ana Sánchez Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('763c5997-21f4-357d-93a9-8d1efff97c2a', 'NIF-00143', 'Ana Sánchez Santos', '1983-12-04', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('3588d04e-32ba-317c-907d-6d57398427b3', '763c5997-21f4-357d-93a9-8d1efff97c2a', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('e18d0bdf-c6f2-334a-b076-dc82e7dc299b', '763c5997-21f4-357d-93a9-8d1efff97c2a', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('72a4d519-3832-3fb0-a93d-7af648517d8a', '3588d04e-32ba-317c-907d-6d57398427b3', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('f7debb91-6245-3731-b3a4-2025786ea2b2', '3588d04e-32ba-317c-907d-6d57398427b3', 'Atorvastatina 20mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00145 (Pablo Pérez Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('35b72b6f-d5a0-3ce2-bb5a-7636b8e3b3da', 'NIF-00144', 'Pablo Pérez Santos', '1984-01-05', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('53c3538f-c337-3a1b-805e-a0ccee3a6cf8', '35b72b6f-d5a0-3ce2-bb5a-7636b8e3b3da', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ab912774-059f-3ce9-83a1-d72fc5e34699', '35b72b6f-d5a0-3ce2-bb5a-7636b8e3b3da', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('451e2ebd-1ffe-3906-8ad0-d2b284e2839e', '53c3538f-c337-3a1b-805e-a0ccee3a6cf8', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('b27d90ca-9219-3b1b-905f-3ddd495e7576', '53c3538f-c337-3a1b-805e-a0ccee3a6cf8', 'Atorvastatina 20mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00146 (Laura Gómez Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('41969f24-9bda-34b5-968e-f9dbf28870e2', 'NIF-00145', 'Laura Gómez Santos', '1985-02-06', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('29f8f69f-872a-36b4-8c6a-b463be16e56e', '41969f24-9bda-34b5-968e-f9dbf28870e2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('35d8ae02-5ba7-3025-bfab-ca4107078f59', '41969f24-9bda-34b5-968e-f9dbf28870e2', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('5c8f1c14-6775-3fad-8947-51ba72b26106', '29f8f69f-872a-36b4-8c6a-b463be16e56e', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('386b2157-8e70-3078-87c9-cd95a69f2849', '29f8f69f-872a-36b4-8c6a-b463be16e56e', 'Salbutamol Inhalador', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00147 (Andrés Fernández Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('8d0271ad-8a5d-3aad-ba10-a28198c742ca', 'NIF-00146', 'Andrés Fernández Santos', '1986-03-07', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('3043954f-2fde-3f05-b77a-2b0fcc6f027b', '8d0271ad-8a5d-3aad-ba10-a28198c742ca', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('c4307e4a-78ef-38f1-a9de-98bca0326642', '8d0271ad-8a5d-3aad-ba10-a28198c742ca', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('356165a1-67cd-3eed-a675-543a56347e2d', '3043954f-2fde-3f05-b77a-2b0fcc6f027b', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('54acaf6b-bdd5-39f2-8f19-6725216a5076', '3043954f-2fde-3f05-b77a-2b0fcc6f027b', 'Levotiroxina 50mcg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00148 (Sofía Díaz Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('de315a31-b0ce-3519-899f-77d1f7d2e0e1', 'NIF-00147', 'Sofía Díaz Santos', '1987-04-08', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('814cdf55-61d6-3694-82fc-5f4f763c56ea', 'de315a31-b0ce-3519-899f-77d1f7d2e0e1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('7505b7f6-6fd0-333a-8c6b-c24a9dca66f6', 'de315a31-b0ce-3519-899f-77d1f7d2e0e1', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('b8fc15b9-f93a-3a18-a54e-df728cba45d3', '814cdf55-61d6-3694-82fc-5f4f763c56ea', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('88e21d56-0603-3d6b-9d8e-3acbaefd2186', '814cdf55-61d6-3694-82fc-5f4f763c56ea', 'Losartán 50mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00149 (Álvaro Álvarez Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('95a240c8-545d-3377-aa23-8863e0d40a5d', 'NIF-00148', 'Álvaro Álvarez Santos', '1988-05-09', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('456170e3-5bd0-3dc7-b057-f69a26194a49', '95a240c8-545d-3377-aa23-8863e0d40a5d', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('2b122c88-85bd-3c48-9bae-4e462fb167be', '95a240c8-545d-3377-aa23-8863e0d40a5d', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('359dd648-25ba-399e-b8c5-cccc5b858d84', '456170e3-5bd0-3dc7-b057-f69a26194a49', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('39aabc0e-7e34-3e69-a7cd-ab245f39015b', '456170e3-5bd0-3dc7-b057-f69a26194a49', 'Ibuprofeno 400mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00150 (Nuria Romero Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('52276a9f-f9f6-3f81-98f8-c611c7136ae5', 'NIF-00149', 'Nuria Romero Santos', '1989-06-10', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('9ae9a046-5f07-3167-a1f7-211df2f78980', '52276a9f-f9f6-3f81-98f8-c611c7136ae5', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('57409d16-fa6a-3cbc-ba41-4b2c2423ee52', '52276a9f-f9f6-3f81-98f8-c611c7136ae5', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('552c0c96-046f-33ab-bf24-2c608f470a4b', '9ae9a046-5f07-3167-a1f7-211df2f78980', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('c48b264c-11c8-3342-8643-a62d68bea38f', '9ae9a046-5f07-3167-a1f7-211df2f78980', 'Ibuprofeno 400mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00151 (Juan Navarro Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('7707d911-f55d-3058-9b67-b0073e3d0c49', 'NIF-00150', 'Juan Navarro Santos', '1940-07-11', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('c0c6e385-c154-36a3-85cb-792a37b73371', '7707d911-f55d-3058-9b67-b0073e3d0c49', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('c171cd24-9161-34d3-97b6-6e2a3a1ff6ad', '7707d911-f55d-3058-9b67-b0073e3d0c49', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('574f95fc-fbf3-3644-ad41-b2076a7063fb', 'c0c6e385-c154-36a3-85cb-792a37b73371', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('83339110-fd91-3d79-880b-cc48c48dc969', 'c0c6e385-c154-36a3-85cb-792a37b73371', 'Atorvastatina 20mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00152 (Carmen Torres Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('c60e6c69-8f8b-3955-8560-d398e3621e56', 'NIF-00151', 'Carmen Torres Santos', '1941-08-12', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('1ad89d4e-284b-3e14-a46b-4ba27e4dbdfe', 'c60e6c69-8f8b-3955-8560-d398e3621e56', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('3e5aff06-3551-3ca1-8ae1-dc1231d9528a', 'c60e6c69-8f8b-3955-8560-d398e3621e56', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('0e20434d-287d-3968-a582-13e0a78a199c', '1ad89d4e-284b-3e14-a46b-4ba27e4dbdfe', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('25e2e4cc-1fe8-3b49-99fd-153a896a8e46', '1ad89d4e-284b-3e14-a46b-4ba27e4dbdfe', 'Salbutamol Inhalador', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00153 (Miguel Ruiz Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('fd64d8ee-2c40-32db-817e-7de9b0278ed7', 'NIF-00152', 'Miguel Ruiz Santos', '1942-09-13', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('b530f50b-ec49-385a-8b89-c27e16a87ddf', 'fd64d8ee-2c40-32db-817e-7de9b0278ed7', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('22f85f2a-da03-3f12-8ffa-192fa108a00e', 'fd64d8ee-2c40-32db-817e-7de9b0278ed7', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('4a5d2649-7377-3cf7-8d57-f894d39387f0', 'b530f50b-ec49-385a-8b89-c27e16a87ddf', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('d5df3690-749e-322f-a375-50571bbb575c', 'b530f50b-ec49-385a-8b89-c27e16a87ddf', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00154 (Ana Vega Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('f2fa6b6b-04b5-31a8-ae38-ca161ba3da3f', 'NIF-00153', 'Ana Vega Santos', '1943-10-14', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('2b9481da-8d86-34d8-9890-f2eaa5a68c92', 'f2fa6b6b-04b5-31a8-ae38-ca161ba3da3f', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('5b460f0f-9b0d-3022-b29c-7011c4993444', 'f2fa6b6b-04b5-31a8-ae38-ca161ba3da3f', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('4b325010-8ed7-316a-9f43-1ab977e82bf3', '2b9481da-8d86-34d8-9890-f2eaa5a68c92', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('99dcf5da-94da-32a8-ba3c-ad1f2aa346df', '2b9481da-8d86-34d8-9890-f2eaa5a68c92', 'Salbutamol Inhalador', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00155 (Pablo Molina Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('12ef13ee-4909-3126-af18-e656936af688', 'NIF-00154', 'Pablo Molina Santos', '1944-11-15', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('a33ed6d6-25f4-35e1-bdd3-da4190948684', '12ef13ee-4909-3126-af18-e656936af688', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('ca541f7b-0f62-3655-9b30-83a5a4489e68', '12ef13ee-4909-3126-af18-e656936af688', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('d5a6352d-acb5-312f-a8c1-665bcd672b27', 'a33ed6d6-25f4-35e1-bdd3-da4190948684', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('bb195dcd-b1e0-3409-a181-8bfa5d3fbc50', 'a33ed6d6-25f4-35e1-bdd3-da4190948684', 'Atorvastatina 20mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00156 (Laura Ortega Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('d284ccc9-22e4-3fde-b428-0ff535a1c17a', 'NIF-00155', 'Laura Ortega Santos', '1945-12-16', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('711b7297-f780-3afe-9ea1-6166d8bcc1af', 'd284ccc9-22e4-3fde-b428-0ff535a1c17a', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('62db2202-f858-3712-8496-31f2b08c2cb0', 'd284ccc9-22e4-3fde-b428-0ff535a1c17a', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('c73e56d0-4ac1-337e-a197-14e466c77aca', '711b7297-f780-3afe-9ea1-6166d8bcc1af', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('cbeef986-5859-3e3a-8335-61737a03fece', '711b7297-f780-3afe-9ea1-6166d8bcc1af', 'Levotiroxina 50mcg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00157 (Andrés Castro Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('d4194657-86ae-34b2-a07a-1c53c78e2bed', 'NIF-00156', 'Andrés Castro Santos', '1946-01-17', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('e50af16c-6115-353a-961c-4ecf54cfabd6', 'd4194657-86ae-34b2-a07a-1c53c78e2bed', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('aefac6cd-0df9-3a3e-b25c-a9bd4f88339c', 'd4194657-86ae-34b2-a07a-1c53c78e2bed', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('3a3ee800-1020-3833-b730-ce3aec4a8bab', 'e50af16c-6115-353a-961c-4ecf54cfabd6', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('bd40deb5-5c19-3c78-b477-cbeee42d6893', 'e50af16c-6115-353a-961c-4ecf54cfabd6', 'Levotiroxina 50mcg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00158 (Sofía Delgado Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('7ec9a733-b26a-3e19-8a54-d4f41cdf61e4', 'NIF-00157', 'Sofía Delgado Santos', '1947-02-18', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('93167ef1-5902-3e13-b354-0a2da3d7f007', '7ec9a733-b26a-3e19-8a54-d4f41cdf61e4', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('dc01c2c8-94fb-3ccf-b382-3bfea1e1185e', '7ec9a733-b26a-3e19-8a54-d4f41cdf61e4', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('70c483fc-d083-3f13-9d11-3de3f93b304d', '93167ef1-5902-3e13-b354-0a2da3d7f007', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('a1e65f59-53a8-379c-a1da-9e55b8bc444a', '93167ef1-5902-3e13-b354-0a2da3d7f007', 'Losartán 50mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00159 (Álvaro Serrano Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('f6f46fe1-c7ad-3635-8984-5a20cfde1925', 'NIF-00158', 'Álvaro Serrano Santos', '1948-03-19', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('e8fba3b4-31d2-3826-8700-ac2d81ba05e0', 'f6f46fe1-c7ad-3635-8984-5a20cfde1925', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('b7687a94-4549-3ecb-9ade-532dad5f9a99', 'f6f46fe1-c7ad-3635-8984-5a20cfde1925', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('a54053a6-989c-3ad0-bc4a-0abb2c6d650f', 'e8fba3b4-31d2-3826-8700-ac2d81ba05e0', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('b5216cdd-25c9-317e-8473-aaede972c697', 'e8fba3b4-31d2-3826-8700-ac2d81ba05e0', 'Paracetamol 1g', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00160 (Nuria Cortés Santos)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('9a5f14b7-1c3c-36c6-98ac-f0ab37acdb99', 'NIF-00159', 'Nuria Cortés Santos', '1949-04-20', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('823a46c6-fb95-3706-a3e7-aa9750227506', '9a5f14b7-1c3c-36c6-98ac-f0ab37acdb99', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('aeac733a-1b17-37f6-97b2-46429bb0a8d7', '9a5f14b7-1c3c-36c6-98ac-f0ab37acdb99', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('97552696-5375-392c-a1e3-56d7d6de5ca3', '823a46c6-fb95-3706-a3e7-aa9750227506', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('f0bd70f8-837f-3ae1-82dd-47e4f089190a', '823a46c6-fb95-3706-a3e7-aa9750227506', 'Metformina 850mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00161 (Juan García Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('bd5b82f8-8028-37db-a5be-48259df7ee27', 'NIF-00160', 'Juan García Iglesias', '1950-05-21', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('f8d4a30d-1844-3414-84ae-bdcd3c7b4a9e', 'bd5b82f8-8028-37db-a5be-48259df7ee27', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('832b2e4a-3e57-3025-bcf0-f10b2c44501f', 'bd5b82f8-8028-37db-a5be-48259df7ee27', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('811fd439-6d48-3421-8a07-51bfd38d4a86', 'f8d4a30d-1844-3414-84ae-bdcd3c7b4a9e', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('a62fc9a6-96b3-33da-bca9-616a9efb9a74', 'f8d4a30d-1844-3414-84ae-bdcd3c7b4a9e', 'Salbutamol Inhalador', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00162 (Carmen López Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('66e1cb3e-d181-3f7b-bcc5-93e2f45c3a9c', 'NIF-00161', 'Carmen López Iglesias', '1951-06-22', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('cdcefcb7-4534-3e38-b8b4-228d651d1908', '66e1cb3e-d181-3f7b-bcc5-93e2f45c3a9c', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('84e666ed-403a-3cb2-8cfe-ed99e42a7c2d', '66e1cb3e-d181-3f7b-bcc5-93e2f45c3a9c', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('65f12fdc-9f2b-389f-8cfa-784e143c843f', 'cdcefcb7-4534-3e38-b8b4-228d651d1908', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('afa873ed-23d1-3d57-8466-8fc8d4fce65c', 'cdcefcb7-4534-3e38-b8b4-228d651d1908', 'Salbutamol Inhalador', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00163 (Miguel Martínez Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('0759eae2-7b01-3fdd-9d4e-924c110c9b88', 'NIF-00162', 'Miguel Martínez Iglesias', '1952-07-23', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('6de73ed5-775a-39b7-9c7b-60d06e4661c0', '0759eae2-7b01-3fdd-9d4e-924c110c9b88', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('17b33372-ea9a-3aec-a9a8-f49a5a54e8f4', '0759eae2-7b01-3fdd-9d4e-924c110c9b88', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('34b5429f-35a6-3d6f-9d1b-26a8cbbea3cb', '6de73ed5-775a-39b7-9c7b-60d06e4661c0', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('47741795-9599-3512-9ef0-4f83ed45369d', '6de73ed5-775a-39b7-9c7b-60d06e4661c0', 'Levotiroxina 50mcg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00164 (Ana Sánchez Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('488c649e-b5c8-343d-86cd-a30b91e9aa10', 'NIF-00163', 'Ana Sánchez Iglesias', '1953-08-24', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('bb0093f6-9559-39cf-b8fe-910d75e8943f', '488c649e-b5c8-343d-86cd-a30b91e9aa10', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('a02f7448-5e6b-3b0e-92e1-09dd049518aa', '488c649e-b5c8-343d-86cd-a30b91e9aa10', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('ae4a5b7d-410d-3136-9760-771ecf4cc1c4', 'bb0093f6-9559-39cf-b8fe-910d75e8943f', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('6537a6f9-c95f-3f75-bcc5-e7e628371574', 'bb0093f6-9559-39cf-b8fe-910d75e8943f', 'Atorvastatina 20mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00165 (Pablo Pérez Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('363c45f2-9778-3d87-a69a-bb9507b4785a', 'NIF-00164', 'Pablo Pérez Iglesias', '1954-09-25', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('a0570e98-e4f3-374a-87f3-131f90aeb242', '363c45f2-9778-3d87-a69a-bb9507b4785a', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('06a5f973-a1e3-3f82-9c0a-e8fc2da6baa2', '363c45f2-9778-3d87-a69a-bb9507b4785a', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('665ab372-0875-379a-b98c-b87a49742bc0', 'a0570e98-e4f3-374a-87f3-131f90aeb242', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('1e972702-6866-3d88-9b56-d9017d24f786', 'a0570e98-e4f3-374a-87f3-131f90aeb242', 'Losartán 50mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00166 (Laura Gómez Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('e8ef6144-e233-3866-a23c-2857e9206cbe', 'NIF-00165', 'Laura Gómez Iglesias', '1955-10-26', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('8738d6a7-d8de-3440-9495-dadd2cb700c6', 'e8ef6144-e233-3866-a23c-2857e9206cbe', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('a17f2ae3-0bc0-3aec-880c-b5189a2fbaa5', 'e8ef6144-e233-3866-a23c-2857e9206cbe', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('c7cd6e45-0a29-33ba-8f4d-6eeded81e7f4', '8738d6a7-d8de-3440-9495-dadd2cb700c6', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('258cbc01-ab79-36e5-bf2a-b36e34b2105d', '8738d6a7-d8de-3440-9495-dadd2cb700c6', 'Salbutamol Inhalador', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00167 (Andrés Fernández Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('0fd9c6d6-6f7c-3eb2-b2a4-7296896697c3', 'NIF-00166', 'Andrés Fernández Iglesias', '1956-11-27', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('3beb1c96-758a-3bc0-85f8-1bc57f7eb77f', '0fd9c6d6-6f7c-3eb2-b2a4-7296896697c3', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('4e7f8cab-d3d6-3e36-8fd7-07e8ce94b65b', '0fd9c6d6-6f7c-3eb2-b2a4-7296896697c3', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('ccd3843d-a324-384d-8afa-88035a0691b2', '3beb1c96-758a-3bc0-85f8-1bc57f7eb77f', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('25e6e0ff-85fe-3146-bfb3-0e71cf6c29bb', '3beb1c96-758a-3bc0-85f8-1bc57f7eb77f', 'Metformina 850mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00168 (Sofía Díaz Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('f6e39e71-a704-3969-ad81-03d8cec30c83', 'NIF-00167', 'Sofía Díaz Iglesias', '1957-12-28', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('bdebc579-0f07-38f1-8e13-4ba54bd31565', 'f6e39e71-a704-3969-ad81-03d8cec30c83', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('d0923ff0-03f7-3c47-8c90-39e7f86adc27', 'f6e39e71-a704-3969-ad81-03d8cec30c83', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('bf037f90-d109-3cc2-88e4-22241dd67ef3', 'bdebc579-0f07-38f1-8e13-4ba54bd31565', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('367847af-7850-3616-8dac-a111d27eaa45', 'bdebc579-0f07-38f1-8e13-4ba54bd31565', 'Atorvastatina 20mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00169 (Álvaro Álvarez Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('4878c9e6-d417-3567-b025-14721259a955', 'NIF-00168', 'Álvaro Álvarez Iglesias', '1958-01-01', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('a284fcfe-af06-3f37-8c45-5525b92c48a5', '4878c9e6-d417-3567-b025-14721259a955', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('87d6ea90-072d-30b6-a7f8-687690471607', '4878c9e6-d417-3567-b025-14721259a955', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('7e9fa006-5e3f-3b94-90f1-d85857fb44d7', 'a284fcfe-af06-3f37-8c45-5525b92c48a5', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('3b081443-e90e-39ae-805e-e555082ab038', 'a284fcfe-af06-3f37-8c45-5525b92c48a5', 'Losartán 50mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00170 (Nuria Romero Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('51bed55c-c46c-3df6-8db3-6263f09c97fd', 'NIF-00169', 'Nuria Romero Iglesias', '1959-02-02', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('718f6a50-268d-3e33-8bfa-657b78fe5075', '51bed55c-c46c-3df6-8db3-6263f09c97fd', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('6a4abfb4-81a5-3e11-8774-0f5f664f8fdb', '51bed55c-c46c-3df6-8db3-6263f09c97fd', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('88c38bbe-7e62-339d-bd34-9fb612ed1e56', '718f6a50-268d-3e33-8bfa-657b78fe5075', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('383e3b94-0725-31fb-975c-789d7f32c13f', '718f6a50-268d-3e33-8bfa-657b78fe5075', 'Salbutamol Inhalador', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00171 (Juan Navarro Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('8d2e4721-8dca-33f0-b3e7-1145923d3e99', 'NIF-00170', 'Juan Navarro Iglesias', '1960-03-03', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('03b30e5d-1f01-3e4e-ada4-21fc78fa3784', '8d2e4721-8dca-33f0-b3e7-1145923d3e99', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('804d4174-e489-3194-8899-72607d4819dc', '8d2e4721-8dca-33f0-b3e7-1145923d3e99', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('5a4db1fb-b98c-3852-93e6-c45c3facb9a0', '03b30e5d-1f01-3e4e-ada4-21fc78fa3784', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('93a87bed-2356-32b4-86e7-8b021dc21219', '03b30e5d-1f01-3e4e-ada4-21fc78fa3784', 'Salbutamol Inhalador', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00172 (Carmen Torres Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('a8de89b8-4bd7-3b7a-89de-b43107db99df', 'NIF-00171', 'Carmen Torres Iglesias', '1961-04-04', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('d0a947da-0977-363a-a996-f56fd1b17cb1', 'a8de89b8-4bd7-3b7a-89de-b43107db99df', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('386e2e52-7820-34f8-8bd1-ef3ff343d757', 'a8de89b8-4bd7-3b7a-89de-b43107db99df', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('90f6ddda-3b30-37b9-b149-0fd6698d0986', 'd0a947da-0977-363a-a996-f56fd1b17cb1', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('286c8129-6f3c-3557-ab26-8ee3b813c4f7', 'd0a947da-0977-363a-a996-f56fd1b17cb1', 'Levotiroxina 50mcg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00173 (Miguel Ruiz Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('a61a81b3-6074-3ac6-9c8d-a8575ad912a3', 'NIF-00172', 'Miguel Ruiz Iglesias', '1962-05-05', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('ce85396c-cf16-39fe-8bd7-f0031942a5ed', 'a61a81b3-6074-3ac6-9c8d-a8575ad912a3', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('5bc90d0a-6c21-3e37-a2eb-beae79648497', 'a61a81b3-6074-3ac6-9c8d-a8575ad912a3', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('646f0f81-74b2-3c6d-9049-eb86abe017a4', 'ce85396c-cf16-39fe-8bd7-f0031942a5ed', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('7c0b56d2-87f7-3d23-84ad-ecbf748a947e', 'ce85396c-cf16-39fe-8bd7-f0031942a5ed', 'Levotiroxina 50mcg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00174 (Ana Vega Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('17638ebf-1836-3c0d-997e-39cd074c70aa', 'NIF-00173', 'Ana Vega Iglesias', '1963-06-06', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('ea384cc7-27dc-3d39-8f54-65e858a4b05e', '17638ebf-1836-3c0d-997e-39cd074c70aa', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('3be0ce06-14a3-38aa-baf8-eef193b2eb06', '17638ebf-1836-3c0d-997e-39cd074c70aa', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('0d13f4a7-9465-37ea-aa34-0f4997bb6ce1', 'ea384cc7-27dc-3d39-8f54-65e858a4b05e', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('8875b802-4d6f-36d3-af0f-a45ff5e38af1', 'ea384cc7-27dc-3d39-8f54-65e858a4b05e', 'Losartán 50mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00175 (Pablo Molina Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('5a96f429-cad6-3d77-abfb-e8c4569a80ea', 'NIF-00174', 'Pablo Molina Iglesias', '1964-07-07', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('672ca8f3-0c94-3a3a-bcaa-6277bea571c9', '5a96f429-cad6-3d77-abfb-e8c4569a80ea', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('3097e7cd-f6f6-3ae7-ae57-011d4833f716', '5a96f429-cad6-3d77-abfb-e8c4569a80ea', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('4d8e470e-c29d-3cb0-ab23-6bd076e6c611', '672ca8f3-0c94-3a3a-bcaa-6277bea571c9', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('ed77bf07-3920-3ba3-96b0-26bac986cc1e', '672ca8f3-0c94-3a3a-bcaa-6277bea571c9', 'Levotiroxina 50mcg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00176 (Laura Ortega Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('041a8b9f-e6b8-3ffe-b26e-2f7669b5c407', 'NIF-00175', 'Laura Ortega Iglesias', '1965-08-08', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('613ab764-b58a-32cb-bc62-aabc55bdc698', '041a8b9f-e6b8-3ffe-b26e-2f7669b5c407', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('83720e5a-087b-39be-aa7b-33601dd47818', '041a8b9f-e6b8-3ffe-b26e-2f7669b5c407', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('72d28954-4866-3589-be34-aaaff416152f', '613ab764-b58a-32cb-bc62-aabc55bdc698', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('8ae07e79-a324-3ce1-8b29-17cc96bb21cd', '613ab764-b58a-32cb-bc62-aabc55bdc698', 'Ibuprofeno 400mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00177 (Andrés Castro Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('457595e8-03a2-30b7-a467-1cdbfb5caaab', 'NIF-00176', 'Andrés Castro Iglesias', '1966-09-09', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('9cf82a64-03e6-3548-8fed-8983fec2c128', '457595e8-03a2-30b7-a467-1cdbfb5caaab', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('e5816807-d925-3d79-be19-b2c88c428922', '457595e8-03a2-30b7-a467-1cdbfb5caaab', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('3c20832e-b4ce-32ab-bfdb-d3f0a3c96d00', '9cf82a64-03e6-3548-8fed-8983fec2c128', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('d0ab99ce-9eca-3588-9ab5-2988a5351251', '9cf82a64-03e6-3548-8fed-8983fec2c128', 'Metformina 850mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00178 (Sofía Delgado Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('58cab24a-9df4-31b5-8f51-90b0af4dcab2', 'NIF-00177', 'Sofía Delgado Iglesias', '1967-10-10', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('cc93548b-57d8-32cc-b372-4ce1fbc17512', '58cab24a-9df4-31b5-8f51-90b0af4dcab2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('008ca207-c173-3568-a288-184d4444221e', '58cab24a-9df4-31b5-8f51-90b0af4dcab2', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('cd6554c3-035f-39a4-91b2-f149476427ac', 'cc93548b-57d8-32cc-b372-4ce1fbc17512', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('c3f678d5-4134-36c7-8738-4b3b2eba958b', 'cc93548b-57d8-32cc-b372-4ce1fbc17512', 'Ibuprofeno 400mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00179 (Álvaro Serrano Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('5dfbf930-4e4d-3c76-94dc-f7d9741935b0', 'NIF-00178', 'Álvaro Serrano Iglesias', '1968-11-11', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('e27f63be-f904-3a02-8749-5d944d526596', '5dfbf930-4e4d-3c76-94dc-f7d9741935b0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('197e49aa-cf9b-319f-b0fa-ab9ac7d52c8e', '5dfbf930-4e4d-3c76-94dc-f7d9741935b0', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('aa69566e-1f4c-3fbc-a324-e747df852c4e', 'e27f63be-f904-3a02-8749-5d944d526596', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('30aaf656-d0ea-3eb3-afb8-f37452d02d80', 'e27f63be-f904-3a02-8749-5d944d526596', 'Paracetamol 1g', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00180 (Nuria Cortés Iglesias)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('78a70cab-cb46-36c7-8f9f-8a218b9b1293', 'NIF-00179', 'Nuria Cortés Iglesias', '1969-12-12', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('02fae7cd-5615-31e5-9c41-0bd344f38ebf', '78a70cab-cb46-36c7-8f9f-8a218b9b1293', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('2520d40f-6ddd-398f-86b0-81cfc1946571', '78a70cab-cb46-36c7-8f9f-8a218b9b1293', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('b3fc6133-7d20-3cb0-8041-d31750573726', '02fae7cd-5615-31e5-9c41-0bd344f38ebf', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('1fe28270-7331-3b02-9753-a2dc01f6053f', '02fae7cd-5615-31e5-9c41-0bd344f38ebf', 'Ibuprofeno 400mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00181 (Juan García Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('cbfc6d06-f9a1-3a9e-af61-8cbc206f4c5b', 'NIF-00180', 'Juan García Cano', '1970-01-13', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('855770e1-1efb-3bbf-beb6-79119a7e1e12', 'cbfc6d06-f9a1-3a9e-af61-8cbc206f4c5b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('81765ffb-ac93-31e1-90fb-3a5687b6fc74', 'cbfc6d06-f9a1-3a9e-af61-8cbc206f4c5b', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('0c856fde-0743-3775-ae7e-3dadc8643ae5', '855770e1-1efb-3bbf-beb6-79119a7e1e12', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('7884127a-d8c0-3136-addf-a33837e43d6f', '855770e1-1efb-3bbf-beb6-79119a7e1e12', 'Losartán 50mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00182 (Carmen López Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('b7836c11-2ae6-351e-b7b9-bb8fa55b6b86', 'NIF-00181', 'Carmen López Cano', '1971-02-14', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('c5960b3e-e1ee-3abb-9b1b-244014a8208a', 'b7836c11-2ae6-351e-b7b9-bb8fa55b6b86', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('d35746d5-9fcf-3843-b171-ab65e37897ed', 'b7836c11-2ae6-351e-b7b9-bb8fa55b6b86', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('88e03c8f-e766-3c65-beab-216ba0710e31', 'c5960b3e-e1ee-3abb-9b1b-244014a8208a', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('f3b3969d-eb1c-3b0f-a04a-836160c65f2c', 'c5960b3e-e1ee-3abb-9b1b-244014a8208a', 'Metformina 850mg', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00183 (Miguel Martínez Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('db47444e-dd03-36c1-843a-de06eefb9cc4', 'NIF-00182', 'Miguel Martínez Cano', '1972-03-15', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('29904e95-927b-327e-80df-d68a3826c98c', 'db47444e-dd03-36c1-843a-de06eefb9cc4', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('e8f6320e-0bae-33ba-9519-01d1748b0289', 'db47444e-dd03-36c1-843a-de06eefb9cc4', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('28c9782f-61ce-3bfe-b0ef-a5d25abe37fa', '29904e95-927b-327e-80df-d68a3826c98c', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('b7b22f21-9bef-33c2-b18e-c6746f89babd', '29904e95-927b-327e-80df-d68a3826c98c', 'Ibuprofeno 400mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00184 (Ana Sánchez Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('c60b12fc-68aa-3868-b739-0d110956fb57', 'NIF-00183', 'Ana Sánchez Cano', '1973-04-16', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('42f28c16-4604-3dd9-8cd6-88e94059cdba', 'c60b12fc-68aa-3868-b739-0d110956fb57', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('a5d5f97b-69eb-3ba7-8864-69f7ab540b17', 'c60b12fc-68aa-3868-b739-0d110956fb57', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('57fc0e4b-68b0-3e9f-917e-358a02478e54', '42f28c16-4604-3dd9-8cd6-88e94059cdba', 'X00', 'Diabetes Mellitus Tipo 2', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('a80b9924-90dd-3138-a82c-bcdd4bd54e41', '42f28c16-4604-3dd9-8cd6-88e94059cdba', 'Atorvastatina 20mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Atorvastatina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00185 (Pablo Pérez Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('3f949c00-650a-3085-8c0b-1b404a6a9283', 'NIF-00184', 'Pablo Pérez Cano', '1974-05-17', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('94eb2715-c21e-32d5-9f00-b6da5d71c395', '3f949c00-650a-3085-8c0b-1b404a6a9283', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('e93f13ee-0478-333f-b1c1-5bd8c6c4f551', '3f949c00-650a-3085-8c0b-1b404a6a9283', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('9f6d1843-df04-3ab5-adcb-68a38be73252', '94eb2715-c21e-32d5-9f00-b6da5d71c395', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('40fc4569-f6de-3b06-bc0d-0ebe4c808dde', '94eb2715-c21e-32d5-9f00-b6da5d71c395', 'Metformina 850mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00186 (Laura Gómez Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('64eeaf16-ac9e-3fa9-8e0d-04ff08c95b5d', 'NIF-00185', 'Laura Gómez Cano', '1975-06-18', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('92878760-29dd-3c53-8765-f5c831f47bce', '64eeaf16-ac9e-3fa9-8e0d-04ff08c95b5d', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('3580b4bc-d9f3-307f-a596-a06b782ce22d', '64eeaf16-ac9e-3fa9-8e0d-04ff08c95b5d', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('7422d35e-23e7-3f6c-b277-e45474a2315a', '92878760-29dd-3c53-8765-f5c831f47bce', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('752e891d-4ec2-3251-b2e0-3cab8e294e0d', '92878760-29dd-3c53-8765-f5c831f47bce', 'Losartán 50mg', 'Paciente estable, continuar tratamiento actual.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00187 (Andrés Fernández Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('030d6319-d749-356d-952a-052fc3cae2c4', 'NIF-00186', 'Andrés Fernández Cano', '1976-07-19', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('5757a451-04e1-3e1e-b2e9-2c18e2a6dee6', '030d6319-d749-356d-952a-052fc3cae2c4', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('9f8f4423-97fe-338b-8446-6b1eaeaee319', '030d6319-d749-356d-952a-052fc3cae2c4', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('1df3185f-b302-3d0f-bbea-d99612a40281', '5757a451-04e1-3e1e-b2e9-2c18e2a6dee6', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('7c65e4bd-5153-336b-b970-67d372f30c0a', '5757a451-04e1-3e1e-b2e9-2c18e2a6dee6', 'Paracetamol 1g', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00188 (Sofía Díaz Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('ff1c457b-e6ec-3c55-86de-e3380457cf77', 'NIF-00187', 'Sofía Díaz Cano', '1977-08-20', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('025d3cbf-480b-3680-8e27-4f36c1b54b88', 'ff1c457b-e6ec-3c55-86de-e3380457cf77', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('59a44825-eb3f-3ec1-87b2-764e65c5946b', 'ff1c457b-e6ec-3c55-86de-e3380457cf77', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('2442cc38-28b7-3e19-9a13-7e4b2152f467', '025d3cbf-480b-3680-8e27-4f36c1b54b88', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('5e10e132-5de1-333b-8d7d-c35d93142b30', '025d3cbf-480b-3680-8e27-4f36c1b54b88', 'Losartán 50mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00189 (Álvaro Álvarez Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('8e919d57-6c59-3c41-af58-1f0c866d6b6d', 'NIF-00188', 'Álvaro Álvarez Cano', '1978-09-21', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('89ccf1bb-6bc1-3ef0-a4c3-0fc8abf39040', '8e919d57-6c59-3c41-af58-1f0c866d6b6d', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('aef1ffd4-97dd-3646-aa7d-b8e66cef3e66', '8e919d57-6c59-3c41-af58-1f0c866d6b6d', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('94458e3a-91a7-374e-b03e-330167ec3060', '89ccf1bb-6bc1-3ef0-a4c3-0fc8abf39040', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('d2db1ba8-0187-35f7-83bf-73eef1ddc670', '89ccf1bb-6bc1-3ef0-a4c3-0fc8abf39040', 'Salbutamol Inhalador', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00190 (Nuria Romero Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('7cadb0ff-ad33-3938-855a-16c2a4ad7ca5', 'NIF-00189', 'Nuria Romero Cano', '1979-10-22', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('6622c2ee-1d5d-30bb-8d51-e6f738d08fab', '7cadb0ff-ad33-3938-855a-16c2a4ad7ca5', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('482d9ff9-4950-3db3-a15c-d38f6033e2a2', '7cadb0ff-ad33-3938-855a-16c2a4ad7ca5', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('b59313cb-213c-3e9d-a542-c521f0129d1e', '6622c2ee-1d5d-30bb-8d51-e6f738d08fab', 'X00', 'Hipertensión', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('b913bd2e-d6e6-37cd-819e-4164d3b6bb34', '6622c2ee-1d5d-30bb-8d51-e6f738d08fab', 'Ibuprofeno 400mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00191 (Juan Navarro Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('75347fce-9dcc-38df-8d36-3adab9f968a2', 'NIF-00190', 'Juan Navarro Cano', '1980-11-23', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('73177d0f-4887-3a28-979e-f76b98d1f523', '75347fce-9dcc-38df-8d36-3adab9f968a2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('be7bf3dc-9d56-318e-8e1a-be2583fd91e4', '75347fce-9dcc-38df-8d36-3adab9f968a2', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('9db5011a-485f-32d8-a491-70037365aafb', '73177d0f-4887-3a28-979e-f76b98d1f523', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('2119bb99-d862-335e-a3a2-6df3a8a1b94e', '73177d0f-4887-3a28-979e-f76b98d1f523', 'Losartán 50mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00192 (Carmen Torres Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('ab58ce54-70b4-32b1-8992-b9ff202654b8', 'NIF-00191', 'Carmen Torres Cano', '1981-12-24', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('133d7513-5e7b-3b0b-969a-44172281a29e', 'ab58ce54-70b4-32b1-8992-b9ff202654b8', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('e15e0a52-a352-3a0f-9dad-aca65493ffbf', 'ab58ce54-70b4-32b1-8992-b9ff202654b8', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('642c9289-6a03-33a8-97b2-ab81e0ffe013', '133d7513-5e7b-3b0b-969a-44172281a29e', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('a63c215d-baf1-31f4-b3d3-7265e1ddf106', '133d7513-5e7b-3b0b-969a-44172281a29e', 'Metformina 850mg', 'Revisión en 6 meses.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00193 (Miguel Ruiz Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('2841b3bb-92e7-37d6-94a2-a3404fec1123', 'NIF-00192', 'Miguel Ruiz Cano', '1982-01-25', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('3c59e952-c686-3af3-b4d3-be4971bb711a', '2841b3bb-92e7-37d6-94a2-a3404fec1123', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('c85ec30c-50de-39a7-b68a-d7838c3c731c', '2841b3bb-92e7-37d6-94a2-a3404fec1123', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('8a157b53-7686-35ec-bfab-8b346ba8afd3', '3c59e952-c686-3af3-b4d3-be4971bb711a', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('6876ed41-b1bb-3100-b225-661126d3eb91', '3c59e952-c686-3af3-b4d3-be4971bb711a', 'Paracetamol 1g', 'Presenta mejoría significativa respecto a la última consulta.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00194 (Ana Vega Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('7e9e8bce-5074-37dd-bde6-9a9f8ea8bd36', 'NIF-00193', 'Ana Vega Cano', '1983-02-26', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('7f12893a-a1d4-303e-9c8d-5133e37ec5fc', '7e9e8bce-5074-37dd-bde6-9a9f8ea8bd36', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('c5b39507-3488-30ae-a7e6-bbb0a8581743', '7e9e8bce-5074-37dd-bde6-9a9f8ea8bd36', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('0dfd98af-9e0d-31ae-8d48-083be044dbc6', '7f12893a-a1d4-303e-9c8d-5133e37ec5fc', 'X00', 'Ansiedad Generalizada', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('daa1421e-3e54-337b-9396-0a7ddf00c2b0', '7f12893a-a1d4-303e-9c8d-5133e37ec5fc', 'Paracetamol 1g', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Paracetamol', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00195 (Pablo Molina Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('896d35ba-70e9-347a-91c8-67b7417d94fd', 'NIF-00194', 'Pablo Molina Cano', '1984-03-27', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('aec598fd-e0e2-3cee-aeb8-7983b202edd7', '896d35ba-70e9-347a-91c8-67b7417d94fd', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('b5a03edf-54e5-3c30-bead-97eedf559f09', '896d35ba-70e9-347a-91c8-67b7417d94fd', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('48550962-d975-3c8d-84a9-3556df97c8d5', 'aec598fd-e0e2-3cee-aeb8-7983b202edd7', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('fc153423-8c02-3219-8f9b-ab87c4208aee', 'aec598fd-e0e2-3cee-aeb8-7983b202edd7', 'Levotiroxina 50mcg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00196 (Laura Ortega Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('25fe5a99-663e-35c3-8ed4-458e14a35a01', 'NIF-00195', 'Laura Ortega Cano', '1985-04-28', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('8e633556-6b09-3e66-9ec9-69c1b1a9e4b1', '25fe5a99-663e-35c3-8ed4-458e14a35a01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('2257b4c3-f244-3fa9-868f-bae781a74ba8', '25fe5a99-663e-35c3-8ed4-458e14a35a01', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('6c4e66b1-9180-33bf-917c-2293a5b38c31', '8e633556-6b09-3e66-9ec9-69c1b1a9e4b1', 'X00', 'Hipotiroidismo', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('f4711787-0500-3f9e-88ad-eea0f1ffa1b1', '8e633556-6b09-3e66-9ec9-69c1b1a9e4b1', 'Ibuprofeno 400mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00197 (Andrés Castro Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('c6461d4c-06c7-37d1-b1ff-73d3ba6ae614', 'NIF-00196', 'Andrés Castro Cano', '1986-05-01', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('aab6f930-2e4e-3503-9032-e18a495c2477', 'c6461d4c-06c7-37d1-b1ff-73d3ba6ae614', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('a5a7e525-5c3a-3d59-b3df-fa20112a3be5', 'c6461d4c-06c7-37d1-b1ff-73d3ba6ae614', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('49bf653f-1c59-3277-84dc-76ed994d689c', 'aab6f930-2e4e-3503-9032-e18a495c2477', 'X00', 'Dislipidemia', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('f1fbc885-8282-3dde-9a46-336a35e8a3f6', 'aab6f930-2e4e-3503-9032-e18a495c2477', 'Losartán 50mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Losartán', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00198 (Sofía Delgado Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('5aca9ac0-af60-3d7d-a3fc-b6178f472d9a', 'NIF-00197', 'Sofía Delgado Cano', '1987-06-02', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('8dddf3dc-aded-3db2-b87f-e19c507e387f', '5aca9ac0-af60-3d7d-a3fc-b6178f472d9a', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('c54d13cf-19be-34c4-8a98-b34fd33cf424', '5aca9ac0-af60-3d7d-a3fc-b6178f472d9a', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('6210de63-2009-33c4-8b28-843ff54fdd32', '8dddf3dc-aded-3db2-b87f-e19c507e387f', 'X00', 'Asma Bronquial', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('b443a99e-70ec-364e-a5ba-d9e36a10cdd1', '8dddf3dc-aded-3db2-b87f-e19c507e387f', 'Levotiroxina 50mcg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Levotiroxina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00199 (Álvaro Serrano Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('c4ea4ffb-a879-379d-81be-aea6b901f228', 'NIF-00198', 'Álvaro Serrano Cano', '1988-07-03', 'male', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('36e78470-e37b-31c8-bd39-9c2166189918', 'c4ea4ffb-a879-379d-81be-aea6b901f228', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('00174aa6-d0f9-38f3-8033-b555913029fc', 'c4ea4ffb-a879-379d-81be-aea6b901f228', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('d1a26c87-1a47-327f-bd07-e15d28287a57', '36e78470-e37b-31c8-bd39-9c2166189918', 'X00', 'Migraña', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('4ad86a54-e4d0-31e9-8d41-f5d9ce9ffcb6', '36e78470-e37b-31c8-bd39-9c2166189918', 'Metformina 850mg', 'Requiere análisis de sangre en la próxima visita.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;

-- Paciente: patient-gx-00200 (Nuria Cortés Cano)
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, estado_activo) 
VALUES ('5b880201-e4da-34c5-95d3-e2f24c632b99', 'NIF-00199', 'Nuria Cortés Cano', '1989-08-04', 'female', true)
ON CONFLICT (id_paciente) DO NOTHING;
INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('d2d04266-4cbf-3cb1-af2f-d12c5663716b', '5b880201-e4da-34c5-95d3-e2f24c632b99', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'v4.0.1', true)
ON CONFLICT (id_historial) DO NOTHING;
INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('75109161-0c23-3d3f-93eb-993b2fe97df9', '5b880201-e4da-34c5-95d3-e2f24c632b99', '770e8400-e29b-41d4-a716-446655440000', 'Activo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 years')
ON CONFLICT (id_consentimiento) DO NOTHING;
INSERT INTO diagnostico (id_diagnostico, id_historial, cie_10, descripcion, fecha_diagnostico) 
VALUES ('f9985b5c-e965-317a-b01d-a33165493911', 'd2d04266-4cbf-3cb1-af2f-d12c5663716b', 'X00', 'Artritis Reumatoide', CURRENT_TIMESTAMP - INTERVAL '1 year')
ON CONFLICT (id_diagnostico) DO NOTHING;
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES ('218c62b5-e965-3cfb-9749-231ea2b27687', 'd2d04266-4cbf-3cb1-af2f-d12c5663716b', 'Metformina 850mg', 'Se ajusta dosis de medicación por efectos secundarios leves.', CURRENT_TIMESTAMP - INTERVAL '6 months') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Metformina', 'Dosis estándar', CURRENT_TIMESTAMP - INTERVAL '6 months', false FROM t1;
