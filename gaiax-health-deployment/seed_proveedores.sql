-- Hospital General Central
INSERT INTO proveedor_salud (id_proveedor, nombre_institucion, nif_cif, tipo_proveedor, id_gaia_x, certificacion_soap, direccion)
VALUES ('11111111-1111-1111-1111-111111111111', 'Hospital General Central', 'A12345678', 'Hospital', 'did:web:hospital-central.gaiax.eu', 'ISO 27001, ENS Nivel Alto', 'Av. Principal 123, Madrid')
ON CONFLICT DO NOTHING;

-- Clínica de Especialidades Norte
INSERT INTO proveedor_salud (id_proveedor, nombre_institucion, nif_cif, tipo_proveedor, id_gaia_x, certificacion_soap, direccion)
VALUES ('22222222-2222-2222-2222-222222222222', 'Clínica de Especialidades Norte', 'B87654321', 'Clínica', 'did:web:clinica-norte.gaiax.eu', 'ENS Nivel Medio', 'C/ Norte 45, Barcelona')
ON CONFLICT DO NOTHING;

-- Centro Médico del Sur
INSERT INTO proveedor_salud (id_proveedor, nombre_institucion, nif_cif, tipo_proveedor, id_gaia_x, certificacion_soap, direccion)
VALUES ('33333333-3333-3333-3333-333333333333', 'Centro Médico del Sur', 'B11223344', 'Ambulatorio', 'did:web:centro-sur.gaiax.eu', 'ISO 9001', 'Plaza Sur s/n, Sevilla')
ON CONFLICT DO NOTHING;


-- Médicos Hospital General Central
INSERT INTO medico (id_medico, nombre, nro_colegiado, especialidad, id_proveedor, estado_activo)
VALUES ('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', 'Dra. María González', '282812345', 'Cardiología', '11111111-1111-1111-1111-111111111111', true) ON CONFLICT DO NOTHING;
INSERT INTO medico (id_medico, nombre, nro_colegiado, especialidad, id_proveedor, estado_activo)
VALUES ('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', 'Dr. Juan Pérez', '282854321', 'Neurología', '11111111-1111-1111-1111-111111111111', true) ON CONFLICT DO NOTHING;
INSERT INTO medico (id_medico, nombre, nro_colegiado, especialidad, id_proveedor, estado_activo)
VALUES ('a3a3a3a3-a3a3-a3a3-a3a3-a3a3a3a3a3a3', 'Dra. Elena Ruiz', '282898765', 'Pediatría', '11111111-1111-1111-1111-111111111111', true) ON CONFLICT DO NOTHING;
INSERT INTO medico (id_medico, nombre, nro_colegiado, especialidad, id_proveedor, estado_activo)
VALUES ('a4a4a4a4-a4a4-a4a4-a4a4-a4a4a4a4a4a4', 'Dr. Carlos Sánchez', '282845678', 'Cirugía General', '11111111-1111-1111-1111-111111111111', false) ON CONFLICT DO NOTHING;

-- Médicos Clínica Norte
INSERT INTO medico (id_medico, nombre, nro_colegiado, especialidad, id_proveedor, estado_activo)
VALUES ('b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', 'Dr. Luis Fernández', '080811111', 'Traumatología', '22222222-2222-2222-2222-222222222222', true) ON CONFLICT DO NOTHING;
INSERT INTO medico (id_medico, nombre, nro_colegiado, especialidad, id_proveedor, estado_activo)
VALUES ('b2b2b2b2-b2b2-b2b2-b2b2-b2b2b2b2b2b2', 'Dra. Ana López', '080822222', 'Dermatología', '22222222-2222-2222-2222-222222222222', true) ON CONFLICT DO NOTHING;
INSERT INTO medico (id_medico, nombre, nro_colegiado, especialidad, id_proveedor, estado_activo)
VALUES ('b3b3b3b3-b3b3-b3b3-b3b3-b3b3b3b3b3b3', 'Dr. Pedro Martínez', '080833333', 'Oftalmología', '22222222-2222-2222-2222-222222222222', true) ON CONFLICT DO NOTHING;

-- Médicos Centro Sur
INSERT INTO medico (id_medico, nombre, nro_colegiado, especialidad, id_proveedor, estado_activo)
VALUES ('c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', 'Dra. Sofía Díaz', '414112345', 'Medicina General', '33333333-3333-3333-3333-333333333333', true) ON CONFLICT DO NOTHING;
INSERT INTO medico (id_medico, nombre, nro_colegiado, especialidad, id_proveedor, estado_activo)
VALUES ('c2c2c2c2-c2c2-c2c2-c2c2-c2c2c2c2c2c2', 'Dr. Javier Gómez', '414154321', 'Psiquiatría', '33333333-3333-3333-3333-333333333333', true) ON CONFLICT DO NOTHING;
INSERT INTO medico (id_medico, nombre, nro_colegiado, especialidad, id_proveedor, estado_activo)
VALUES ('c3c3c3c3-c3c3-c3c3-c3c3-c3c3c3c3c3c3', 'Dra. Laura Moreno', '414198765', 'Ginecología', '33333333-3333-3333-3333-333333333333', true) ON CONFLICT DO NOTHING;
