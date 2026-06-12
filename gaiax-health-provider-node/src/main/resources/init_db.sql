CREATE TABLE IF NOT EXISTS patients (
    fhir_id TEXT PRIMARY KEY,
    display_name TEXT,
    gender TEXT,
    birth_date DATE,
    resource JSONB NOT NULL,
    version_id TEXT,
    last_updated TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS devices (
    fhir_id TEXT PRIMARY KEY,
    display_name TEXT,
    resource JSONB NOT NULL,
    version_id TEXT,
    last_updated TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS observations (
    fhir_id TEXT PRIMARY KEY,
    patient_fhir_id TEXT NOT NULL REFERENCES patients(fhir_id) ON DELETE CASCADE,
    device_fhir_id TEXT REFERENCES devices(fhir_id) ON DELETE SET NULL,
    resource_type TEXT NOT NULL DEFAULT 'Observation',
    observation_code TEXT,
    observation_text TEXT,
    status TEXT,
    effective_at TIMESTAMPTZ,
    issued_at TIMESTAMPTZ,
    x_request_id TEXT,
    resource JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_observations_patient_effective_at
    ON observations (patient_fhir_id, effective_at DESC, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_observations_issued_at
    ON observations (issued_at DESC);

CREATE INDEX IF NOT EXISTS idx_patients_updated_at
    ON patients (updated_at DESC);

CREATE INDEX IF NOT EXISTS idx_devices_updated_at
    ON devices (updated_at DESC);
