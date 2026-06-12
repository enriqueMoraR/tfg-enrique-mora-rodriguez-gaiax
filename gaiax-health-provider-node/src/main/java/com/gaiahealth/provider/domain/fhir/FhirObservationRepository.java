package com.gaiahealth.provider.domain.fhir;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class FhirObservationRepository {
    private final JdbcTemplate jdbcTemplate;
    private final ObjectMapper objectMapper;

    public FhirObservationRepository(JdbcTemplate jdbcTemplate, ObjectMapper objectMapper) {
        this.jdbcTemplate = jdbcTemplate;
        this.objectMapper = objectMapper;
    }

    public List<JsonNode> storeResource(JsonNode resource, String xRequestId) {
        String resourceType = resource.path("resourceType").asText("");
        if ("Patient".equals(resourceType)) {
            storePatient(resource);
            return List.of(resource);
        }
        if ("Device".equals(resourceType)) {
            storeDevice(resource);
            return List.of(resource);
        }
        if (!"Observation".equals(resourceType)) {
            throw new IllegalArgumentException("Unsupported resourceType: " + resourceType);
        }

        storeObservation(resource, xRequestId);
        return List.of(resource);
    }

    public List<JsonNode> listPatients(int count) {
        int effectiveCount = Math.max(1, Math.min(count, 500));
        return jdbcTemplate.query(
                "SELECT resource::text AS resource_json FROM patients ORDER BY updated_at DESC, fhir_id ASC LIMIT ?",
                ps -> ps.setInt(1, effectiveCount),
                (rs, rowNum) -> parseJson(rs.getString("resource_json"))
        );
    }

    public List<JsonNode> listObservations(String patientRef, int count) {
        int effectiveCount = Math.max(1, Math.min(count, 500));
        if (patientRef == null || patientRef.isBlank()) {
            return jdbcTemplate.query(
                    """
                    SELECT resource::text AS resource_json
                    FROM observations
                    ORDER BY effective_at DESC NULLS LAST, issued_at DESC NULLS LAST, created_at DESC
                    LIMIT ?
                    """,
                    ps -> ps.setInt(1, effectiveCount),
                    (rs, rowNum) -> parseJson(rs.getString("resource_json"))
            );
        }

        String patientId = normalizeReferenceId(patientRef);
        return jdbcTemplate.query(
                """
                SELECT resource::text AS resource_json
                FROM observations
                WHERE patient_fhir_id = ?
                ORDER BY effective_at DESC NULLS LAST, issued_at DESC NULLS LAST, created_at DESC
                LIMIT ?
                """,
                ps -> {
                    ps.setString(1, patientId);
                    ps.setInt(2, effectiveCount);
                },
                (rs, rowNum) -> parseJson(rs.getString("resource_json"))
        );
    }

    public void storeBundle(JsonNode bundle, String xRequestId) {
        for (JsonNode entry : bundle.path("entry")) {
            JsonNode resource = entry.path("resource");
            if (!resource.isMissingNode() && !resource.isNull()) {
                storeResource(resource, xRequestId);
            }
        }
    }

    private void storeObservation(JsonNode observation, String xRequestId) {
        String observationId = requiredText(observation.path("id"), "Observation.id");
        String patientRef = requiredText(observation.path("subject").path("reference"), "Observation.subject.reference");
        String patientId = normalizeReferenceId(patientRef);
        String deviceRef = textOrNull(observation.path("device").path("reference"));
        String deviceId = deviceRef == null ? null : normalizeReferenceId(deviceRef);

        JsonNode patientResource = buildPatientResource(observation, patientId, patientRef);
        storePatient(patientResource);

        if (deviceId != null) {
            storeDevice(buildDeviceResource(observation, deviceId));
        }

        String resourceJson = toJson(observation);
        String observationCode = textOrNull(observation.path("code").path("coding").path(0).path("code"));
        String observationText = textOrNull(observation.path("code").path("text"));
        String status = textOrNull(observation.path("status"));
        String effectiveAt = parseInstantText(observation.path("effectiveDateTime"));
        String issuedAt = parseInstantText(observation.path("issued"));

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(
                    """
                    INSERT INTO observations (
                        fhir_id,
                        patient_fhir_id,
                        device_fhir_id,
                        resource_type,
                        observation_code,
                        observation_text,
                        status,
                        effective_at,
                        issued_at,
                        x_request_id,
                        resource,
                        updated_at
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?::timestamptz, ?::timestamptz, ?, ?::jsonb, NOW())
                    ON CONFLICT (fhir_id) DO UPDATE SET
                        patient_fhir_id = EXCLUDED.patient_fhir_id,
                        device_fhir_id = EXCLUDED.device_fhir_id,
                        resource_type = EXCLUDED.resource_type,
                        observation_code = EXCLUDED.observation_code,
                        observation_text = EXCLUDED.observation_text,
                        status = EXCLUDED.status,
                        effective_at = EXCLUDED.effective_at,
                        issued_at = EXCLUDED.issued_at,
                        x_request_id = EXCLUDED.x_request_id,
                        resource = EXCLUDED.resource,
                        updated_at = NOW()
                    """);
            setString(ps, 1, observationId);
            setString(ps, 2, patientId);
            setString(ps, 3, deviceId);
            setString(ps, 4, "Observation");
            setString(ps, 5, observationCode);
            setString(ps, 6, observationText);
            setString(ps, 7, status);
            setString(ps, 8, effectiveAt);
            setString(ps, 9, issuedAt);
            setString(ps, 10, xRequestId);
            setString(ps, 11, resourceJson);
            return ps;
        });
    }

    private void storePatient(JsonNode patientResource) {
        String patientId = requiredText(patientResource.path("id"), "Patient.id");
        String displayName = patientDisplayName(patientResource);
        String gender = textOrNull(patientResource.path("gender"));
        String birthDate = textOrNull(patientResource.path("birthDate"));
        String resourceJson = toJson(patientResource);
        String versionId = textOrNull(patientResource.path("meta").path("versionId"));
        String lastUpdated = parseInstantText(patientResource.path("meta").path("lastUpdated"));

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(
                    """
                    INSERT INTO patients (
                        fhir_id,
                        display_name,
                        gender,
                        birth_date,
                        resource,
                        version_id,
                        last_updated,
                        updated_at
                    ) VALUES (?, ?, ?, ?::date, ?::jsonb, ?, ?::timestamptz, NOW())
                    ON CONFLICT (fhir_id) DO UPDATE SET
                        display_name = EXCLUDED.display_name,
                        gender = EXCLUDED.gender,
                        birth_date = EXCLUDED.birth_date,
                        resource = EXCLUDED.resource,
                        version_id = EXCLUDED.version_id,
                        last_updated = EXCLUDED.last_updated,
                        updated_at = NOW()
                    """);
            setString(ps, 1, patientId);
            setString(ps, 2, displayName);
            setString(ps, 3, gender);
            setString(ps, 4, birthDate);
            setString(ps, 5, resourceJson);
            setString(ps, 6, versionId);
            setString(ps, 7, lastUpdated);
            return ps;
        });
    }

    private void storeDevice(JsonNode deviceResource) {
        String deviceId = requiredText(deviceResource.path("id"), "Device.id");
        String displayName = deviceDisplayName(deviceResource);
        String resourceJson = toJson(deviceResource);
        String versionId = textOrNull(deviceResource.path("meta").path("versionId"));
        String lastUpdated = parseInstantText(deviceResource.path("meta").path("lastUpdated"));

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(
                    """
                    INSERT INTO devices (
                        fhir_id,
                        display_name,
                        resource,
                        version_id,
                        last_updated,
                        updated_at
                    ) VALUES (?, ?, ?::jsonb, ?, ?::timestamptz, NOW())
                    ON CONFLICT (fhir_id) DO UPDATE SET
                        display_name = EXCLUDED.display_name,
                        resource = EXCLUDED.resource,
                        version_id = EXCLUDED.version_id,
                        last_updated = EXCLUDED.last_updated,
                        updated_at = NOW()
                    """);
            setString(ps, 1, deviceId);
            setString(ps, 2, displayName);
            setString(ps, 3, resourceJson);
            setString(ps, 4, versionId);
            setString(ps, 5, lastUpdated);
            return ps;
        });
    }

    private JsonNode buildPatientResource(JsonNode observation, String patientId, String patientRef) {
        JsonNode existingPatient = loadPatientResourceById(patientId);
        if (existingPatient != null) {
            return existingPatient;
        }

        String displayName = textOrNull(observation.path("subject").path("display"));

        ObjectNode patient = objectMapper.createObjectNode();
        patient.put("resourceType", "Patient");
        patient.put("id", patientId);
        if (displayName != null && !displayName.isBlank()) {
            ArrayNode name = patient.putArray("name");
            ObjectNode nameNode = name.addObject();
            nameNode.put("text", displayName);
        }
        ObjectNode meta = patient.putObject("meta");
        meta.put("versionId", "1");
        meta.put("lastUpdated", Instant.now().toString());
        patient.put("identifierSource", patientRef);
        return patient;
    }

    private JsonNode buildDeviceResource(JsonNode observation, String deviceId) {
        JsonNode existingDevice = loadDeviceResourceById(deviceId);
        if (existingDevice != null) {
            return existingDevice;
        }

        ObjectNode device = objectMapper.createObjectNode();
        device.put("resourceType", "Device");
        device.put("id", deviceId);
        String display = textOrNull(observation.path("device").path("type").path("coding").path(0).path("display"));
        if (display != null) {
            ObjectNode type = device.putObject("type");
            ArrayNode coding = type.putArray("coding");
            ObjectNode codingNode = coding.addObject();
            codingNode.put("display", display);
        }
        return device;
    }

    private JsonNode loadPatientResourceById(String patientId) {
        List<String> resources = jdbcTemplate.query(
                "SELECT resource::text AS resource_json FROM patients WHERE fhir_id = ? LIMIT 1",
                ps -> ps.setString(1, patientId),
                (rs, rowNum) -> rs.getString("resource_json")
        );
        if (resources.isEmpty()) {
            return null;
        }
        return parseJson(resources.get(0));
    }

    private JsonNode loadDeviceResourceById(String deviceId) {
        List<String> resources = jdbcTemplate.query(
                "SELECT resource::text AS resource_json FROM devices WHERE fhir_id = ? LIMIT 1",
                ps -> ps.setString(1, deviceId),
                (rs, rowNum) -> rs.getString("resource_json")
        );
        if (resources.isEmpty()) {
            return null;
        }
        return parseJson(resources.get(0));
    }

    private String patientDisplayName(JsonNode patientResource) {
        String display = textOrNull(patientResource.path("name").path(0).path("text"));
        if (display != null) {
            return display;
        }
        if (patientResource.path("name").isArray() && patientResource.path("name").size() > 0) {
            JsonNode name = patientResource.path("name").get(0);
            String given = name.path("given").isArray() && name.path("given").size() > 0
                    ? name.path("given").get(0).asText("")
                    : "";
            String family = textOrNull(name.path("family"));
            String combined = (given + " " + family).trim();
            if (!combined.isBlank()) {
                return combined;
            }
        }
        return patientResource.path("id").asText("");
    }

    private String deviceDisplayName(JsonNode deviceResource) {
        String display = textOrNull(deviceResource.path("type").path("coding").path(0).path("display"));
        if (display != null) {
            return display;
        }
        return deviceResource.path("id").asText("");
    }

    private String requiredText(JsonNode node, String field) {
        String value = textOrNull(node);
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(field + " is required");
        }
        return value.trim();
    }

    private String textOrNull(JsonNode node) {
        if (node == null || node.isNull() || node.isMissingNode()) {
            return null;
        }
        String value = node.asText();
        return value == null || value.isBlank() ? null : value;
    }

    private String normalizeReferenceId(String reference) {
        if (reference == null || reference.isBlank()) {
            throw new IllegalArgumentException("reference is required");
        }
        int slash = reference.lastIndexOf('/');
        return slash >= 0 ? reference.substring(slash + 1).trim() : reference.trim();
    }

    private String parseInstantText(JsonNode node) {
        String value = textOrNull(node);
        if (value == null) {
            return null;
        }
        try {
            return OffsetDateTime.parse(value).toString();
        } catch (DateTimeParseException ex) {
            return value;
        }
    }

    private String toJson(JsonNode node) {
        try {
            return objectMapper.writeValueAsString(node);
        } catch (Exception ex) {
            throw new IllegalStateException("Unable to serialize FHIR resource", ex);
        }
    }

    private JsonNode parseJson(String value) {
        try {
            return objectMapper.readTree(value);
        } catch (Exception ex) {
            throw new IllegalStateException("Unable to parse stored FHIR resource", ex);
        }
    }

    private void setString(PreparedStatement ps, int index, String value) throws java.sql.SQLException {
        if (value == null) {
            ps.setNull(index, java.sql.Types.VARCHAR);
        } else {
            ps.setString(index, value);
        }
    }
}
