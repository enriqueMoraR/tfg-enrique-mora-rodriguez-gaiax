-- seed.sql: Extensive fake data for patient clinical history
-- Paciente UUID: 550e8400-e29b-41d4-a716-446655440000
-- Purpose UUID (for Consentimiento): 770e8400-e29b-41d4-a716-446655440000

-- Insert Paciente if not exists
INSERT INTO paciente (id_paciente, nif_dni, nombre_completo, fecha_nacimiento, genero, grupo_sanguineo, nacionalidad, telefono, email, direccion_fisica, id_seguro_social, estado_activo) 
VALUES ('550e8400-e29b-41d4-a716-446655440000', '12345678Z', 'Enrique Mora Rodriguez', '1990-05-15', 'Hombre', 'O+', 'Española', '+34600123456', 'enrique.mora@example.com', 'Calle Gran Vía 1, Madrid', 'SS-28-12345678', true)
ON CONFLICT DO NOTHING;

INSERT INTO historial_clinico (id_historial, id_paciente, fecha_creacion, fecha_ultima_actualizacion, version_fhir, estado) 
VALUES ('660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', '2023-01-10 10:00:00', '2026-07-13 10:00:00', 'v4.0.1', true)
ON CONFLICT DO NOTHING;

INSERT INTO consentimiento (id_consentimiento, id_paciente, id_proposito, estado, fecha_inicio, fecha_expiracion) 
VALUES ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', '770e8400-e29b-41d4-a716-446655440000', 'Activo', '2023-01-10 10:00:00', '2028-12-31 23:59:59')
ON CONFLICT DO NOTHING;

-- Diagnosticos (cie_10 instead of cie10)
INSERT INTO diagnostico (id_diagnostico, id_historial, descripcion, cie_10, fecha_diagnostico) 
VALUES 
(gen_random_uuid(), '660e8400-e29b-41d4-a716-446655440000', 'Hipertensión esencial primaria, con lecturas constantes por encima de 140/90 mmHg.', 'I10', '2023-01-15 11:30:00'),
(gen_random_uuid(), '660e8400-e29b-41d4-a716-446655440000', 'Asma alérgica moderada, agravada durante primavera. Presencia de sibilancias.', 'J45.909', '2023-04-20 09:15:00'),
(gen_random_uuid(), '660e8400-e29b-41d4-a716-446655440000', 'Gastritis crónica erosiva. Se recomienda endoscopia en 6 meses.', 'K29.7', '2024-02-10 16:45:00'),
(gen_random_uuid(), '660e8400-e29b-41d4-a716-446655440000', 'Migraña sin aura, episodios recurrentes quincenales asociados al estrés laboral.', 'G43.0', '2025-08-05 10:00:00'),
(gen_random_uuid(), '660e8400-e29b-41d4-a716-446655440000', 'Tendinitis bicipital en brazo derecho por sobreesfuerzo deportivo.', 'M65.3', '2026-06-12 18:20:00');

-- Tratamientos y Medicaciones (added fecha_inicio and es_alergia for medicacion)
WITH t1 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES (gen_random_uuid(), '660e8400-e29b-41d4-a716-446655440000', 'Control de Presión Arterial a largo plazo', 'Tomar la pastilla todos los días por la mañana en ayunas. Control de tensión bisemanal.', '2023-01-16 08:00:00') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Enalapril', '10mg', '2023-01-16 08:00:00'::timestamp, false FROM t1 UNION ALL
SELECT gen_random_uuid(), id_tratamiento, 'Amlodipino', '5mg', '2023-01-16 08:00:00'::timestamp, false FROM t1;

WITH t2 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES (gen_random_uuid(), '660e8400-e29b-41d4-a716-446655440000', 'Terapia broncodilatadora de rescate y mantenimiento', 'Uso del inhalador de mantenimiento diario, rescate solo si hay ahogo.', '2023-04-20 09:30:00') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Salbutamol', '100mcg/inhalación', '2023-04-20 09:30:00'::timestamp, false FROM t2 UNION ALL
SELECT gen_random_uuid(), id_tratamiento, 'Budesonida', '200mcg/día', '2023-04-20 09:30:00'::timestamp, false FROM t2;

WITH t3 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES (gen_random_uuid(), '660e8400-e29b-41d4-a716-446655440000', 'Recuperación de la mucosa gástrica', 'Evitar comidas picantes o copiosas. Tomar el protector gástrico 30 mins antes de comer.', '2024-02-11 08:00:00') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Omeprazol', '20mg/día', '2024-02-11 08:00:00'::timestamp, false FROM t3 UNION ALL
SELECT gen_random_uuid(), id_tratamiento, 'Sucralfato', '1g/8h', '2024-02-11 08:00:00'::timestamp, false FROM t3;

WITH t4 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES (gen_random_uuid(), '660e8400-e29b-41d4-a716-446655440000', 'Profilaxis y tratamiento agudo de migrañas', 'Triptán solo en fase temprana del ataque. Topiramato como prevención.', '2025-08-06 12:00:00') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Sumatriptán', '50mg', '2025-08-06 12:00:00'::timestamp, false FROM t4 UNION ALL
SELECT gen_random_uuid(), id_tratamiento, 'Topiramato', '25mg/noche', '2025-08-06 12:00:00'::timestamp, false FROM t4;

WITH t5 AS (
    INSERT INTO tratamiento (id_tratamiento, id_historial, nombre_tratamiento, indicaciones, fecha_inicio) 
    VALUES (gen_random_uuid(), '660e8400-e29b-41d4-a716-446655440000', 'Rehabilitación y antiinflamatorios para tendinopatía', 'Reposo articular. Hielo 15 mins/día. Sesiones de fisioterapia (10 sesiones).', '2026-06-13 19:00:00') RETURNING id_tratamiento
)
INSERT INTO medicacion (id_medicacion, id_tratamiento, principio_activo, dosis, fecha_inicio, es_alergia) 
SELECT gen_random_uuid(), id_tratamiento, 'Ibuprofeno', '600mg/8h', '2026-06-13 19:00:00'::timestamp, false FROM t5 UNION ALL
SELECT gen_random_uuid(), id_tratamiento, 'Crema de Diclofenaco', '2 aplicaciones diarias', '2026-06-13 19:00:00'::timestamp, false FROM t5;
