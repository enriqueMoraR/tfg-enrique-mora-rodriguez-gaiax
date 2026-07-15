package com.gaiahealth.provider.application;

import com.fasterxml.jackson.databind.JsonNode;
import com.gaiahealth.provider.api.*;
import com.gaiahealth.provider.domain.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
public class DatasetService {
    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(DatasetService.class);
    private final Map<String, DatasetRecord> store = new ConcurrentHashMap<>();
    private final FhirValidationService fhirValidationService;

    private final PacienteRepository pacienteRepository;
    private final HistorialClinicoRepository historialClinicoRepository;
    private final DiagnosticoRepository diagnosticoRepository;
    private final TratamientoRepository tratamientoRepository;
    private final MedicacionRepository medicacionRepository;
    private final MedicoRepository medicoRepository;


    @Transactional
    public DatasetResponse createDataset(CreateDatasetRequest request) {
        if (request == null) {
            throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "request body is required");
        }
        String datasetId = normalizeRequired(request.getDatasetId(), "datasetId");
        DatasetType datasetType = DatasetType.fromValue(request.getDatasetType());
        ClinicalCase clinicalCase = ClinicalCase.fromValue(request.getClinicalCase());

        if (datasetType != DatasetType.FHIR_BUNDLE && datasetType != DatasetType.FHIR_OBSERVATION) {
            throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "datasetType must be FHIR_BUNDLE or FHIR_OBSERVATION");
        }

        validateMetadata(request.getMetadata());
        fhirValidationService.validateBundle(clinicalCase, request.getPayload());

        Instant publishedAt = Instant.now();
        DatasetRecord record = new DatasetRecord(
                datasetId,
                datasetType,
                clinicalCase,
                request.getPayload(),
                request.getMetadata(),
                DatasetStatus.PUBLISHED,
                publishedAt
        );

        if (store.containsKey(datasetId)) {
            throw new ProviderApiException(ProviderErrorCode.CONFLICT, "datasetId already exists");
        }

        // --- NUEVO PASO: Transformar y persistir en el nuevo esquema ---
        try {
            transformAndPersist(record);
        } catch (Exception e) {
            log.error("Error al persistir en el nuevo esquema. La operación en memoria fallará al rollback de BD.", e);
            throw new ProviderApiException(ProviderErrorCode.INTERNAL_ERROR, "Fallo en la persistencia de datos relacionales: " + e.getMessage());
        }

        DatasetRecord existing = store.putIfAbsent(datasetId, record);
        if (existing != null) {
            throw new ProviderApiException(ProviderErrorCode.CONFLICT, "datasetId already exists");
        }

        return new DatasetResponse(datasetId, record.status().name(), publishedAt.toString());
    }

    /**
     * Transforma un DatasetRecord (basado en FHIR) y lo persiste en el nuevo modelo de datos relacional.
     * Este método es llamado desde un contexto ya transaccional.
     */
    protected void transformAndPersist(DatasetRecord record) {
        JsonNode payload = record.payload();
        if (!payload.has("entry")) {
            log.warn("El payload del dataset {} no es un FHIR Bundle válido, no se puede persistir.", record.datasetId());
            return;
        }

        // 1. Buscar o crear el Paciente
        // Asumimos que el bundle contiene un recurso Paciente del cual podemos extraer el DNI.
        Paciente paciente = findOrCreatePacienteFromBundle(payload);

        // 2. Buscar o crear el Historial Clínico
        HistorialClinico historial = historialClinicoRepository.findByPacienteIdPaciente(paciente.getIdPaciente())
                .orElseGet(() -> {
                    HistorialClinico nuevoHistorial = new HistorialClinico();
                    nuevoHistorial.setIdHistorial(UUID.randomUUID());
                    nuevoHistorial.setPaciente(paciente);
                    nuevoHistorial.setFechaCreacion(new Date());
                    nuevoHistorial.setEstado(true);
                    nuevoHistorial.setVersionFhir("R4");
                    return historialClinicoRepository.save(nuevoHistorial);
                });
        historial.setFechaUltimaActualizacion(new Date());

        // 3. Iterar sobre las entradas del bundle y persistir los recursos clínicos
        for (JsonNode entry : payload.get("entry")) {
            JsonNode resource = entry.get("resource");
            String resourceType = resource.get("resourceType").asText();

            switch (resourceType) {
                case "Condition": // Mapea a Diagnostico
                    Diagnostico diagnostico = new Diagnostico();
                    diagnostico.setIdDiagnostico(UUID.randomUUID());
                    diagnostico.setHistorialClinico(historial);
                    diagnostico.setDescripcion(resource.at("/code/text").asText("Sin descripción"));
                    diagnostico.setCie10(resource.at("/code/coding/0/code").asText());
                    try {
                        diagnostico.setFechaDiagnostico(Date.from(Instant.parse(resource.get("recordedDate").asText())));
                    } catch (Exception e) {
                        diagnostico.setFechaDiagnostico(new Date());
                    }
                    diagnosticoRepository.save(diagnostico);
                    break;

                case "MedicationRequest": // Mapea a Tratamiento y Medicacion
                    Tratamiento tratamiento = new Tratamiento();
                    tratamiento.setIdTratamiento(UUID.randomUUID());
                    tratamiento.setHistorialClinico(historial);
                    tratamiento.setNombreTratamiento(resource.at("/medicationCodeableConcept/text").asText("Tratamiento farmacológico"));
                    tratamiento.setIndicaciones(resource.at("/dosageInstruction/0/text").asText());
                    tratamiento.setFechaInicio(new Date());
                    tratamiento.setEsActivado(true);
                    tratamientoRepository.save(tratamiento);

                    Medicacion medicacion = new Medicacion();
                    medicacion.setIdMedicacion(UUID.randomUUID());
                    medicacion.setTratamiento(tratamiento);
                    medicacion.setPrincipioActivo(resource.at("/medicationCodeableConcept/coding/0/display").asText());
                    medicacion.setDosis(resource.at("/dosageInstruction/0/doseAndRate/0/doseQuantity/value").asText() + " " + resource.at("/dosageInstruction/0/doseAndRate/0/doseQuantity/unit").asText());
                    medicacion.setFechaInicio(new Date());
                    medicacionRepository.save(medicacion);
                    break;
                // Se podrían añadir más casos para "Observation", "Procedure", etc.
            }
        }
        historialClinicoRepository.save(historial);
    }

    private Paciente findOrCreatePacienteFromBundle(JsonNode payload) {
        for (JsonNode entry : payload.get("entry")) {
            JsonNode resource = entry.get("resource");
            if ("Patient".equals(resource.get("resourceType").asText())) {
                // Asumimos que el DNI está en el primer identificador
                String nifDni = resource.at("/identifier/0/value").asText();
                if (nifDni.isEmpty()) {
                    continue; // Buscar en otro recurso de paciente si lo hubiera
                }

                return pacienteRepository.findByNifDni(nifDni)
                        .orElseGet(() -> {
                            Paciente nuevoPaciente = new Paciente();
                            nuevoPaciente.setIdPaciente(UUID.randomUUID());
                            nuevoPaciente.setNifDni(nifDni);
                            nuevoPaciente.setNombreCompleto(resource.at("/name/0/text").asText("Nombre no encontrado"));
                            nuevoPaciente.setGenero(resource.get("gender").asText());
                            try {
                                nuevoPaciente.setFechaNacimiento(Date.from(Instant.parse(resource.get("birthDate").asText())));
                            } catch (Exception e) {
                                // No hacer nada si la fecha no es válida
                            }
                            nuevoPaciente.setEstadoActivo(true);
                            return pacienteRepository.save(nuevoPaciente);
                        });
            }
        }
        throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "No se encontró un recurso de Paciente con identificador válido en el FHIR Bundle.");
    }


    // --- MÉTODOS ANTIGUOS (sin cambios por ahora) ---

    public DatasetListResponse listDatasets(String clinicalCaseRaw, String statusRaw, int page, int size) {
        if (page < 0) { throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "page must be >= 0"); }
        if (size <= 0 || size > 200) { throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "size must be between 1 and 200"); }
        ClinicalCase clinicalCase = clinicalCaseRaw == null ? null : ClinicalCase.fromValue(clinicalCaseRaw);
        DatasetStatus status = DatasetStatus.fromValue(statusRaw);
        List<DatasetRecord> filtered = store.values().stream()
                .filter(record -> clinicalCase == null || record.clinicalCase() == clinicalCase)
                .filter(record -> status == null || record.status() == status)
                .sorted(Comparator.comparing(DatasetRecord::publishedAt).reversed())
                .toList();
        int from = Math.min(page * size, filtered.size());
        int to = Math.min(from + size, filtered.size());
        List<DatasetItemResponse> items = filtered.subList(from, to).stream()
                .map(record -> new DatasetItemResponse(
                        record.datasetId(),
                        record.clinicalCase().value(),
                        record.status().name(),
                        record.publishedAt().toString()
                ))
                .toList();
        return new DatasetListResponse(items, page, size, filtered.size());
    }

    public JsonNode getDatasetPayload(String datasetId) {
        log.info("getDatasetPayload requested id='{}', store-size={}", datasetId, store.size());
        DatasetRecord record = store.get(datasetId);
        if (record == null) {
            log.warn("dataset not found for id='{}'. available: {}", datasetId, store.keySet());
            throw new ProviderApiException(ProviderErrorCode.NOT_FOUND, "dataset not found");
        }
        log.info("returning payload for id='{}'", datasetId);
        return record.payload();
    }

    private String normalizeRequired(String value, String fieldName) {
        if (value == null || value.isBlank()) {
            throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, fieldName + " is required");
        }
        return value.trim();
    }

    private void validateMetadata(com.gaiahealth.provider.api.DatasetMetadata metadata) {
        if (metadata == null) { throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "metadata is required"); }
        List<ValidationIssue> issues = new java.util.ArrayList<>();
        requireText(metadata.getOwner(), "metadata.owner", issues);
        requireText(metadata.getPurpose(), "metadata.purpose", issues);
        requireText(metadata.getJurisdiction(), "metadata.jurisdiction", issues);
        requireText(metadata.getPolicyUri(), "metadata.policyUri", issues);
        requireText(metadata.getReceiverDid(), "metadata.receiverDid", issues);
        if (metadata.getRetentionDays() == null || metadata.getRetentionDays() <= 0) {
            issues.add(new ValidationIssue("metadata.retentionDays", "must be greater than 0"));
        }
        requireText(metadata.getValidFrom(), "metadata.validFrom", issues);
        requireText(metadata.getValidTo(), "metadata.validTo", issues);
        if (!issues.isEmpty()) { throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "metadata is invalid", issues); }
        try {
            Instant from = Instant.parse(metadata.getValidFrom());
            Instant to = Instant.parse(metadata.getValidTo());
            if (!to.isAfter(from)) {
                throw new ProviderApiException(
                        ProviderErrorCode.VALIDATION_ERROR,
                        "metadata.validTo must be after metadata.validFrom",
                        List.of(new ValidationIssue("metadata.validTo", "must be after metadata.validFrom"))
                );
            }
        } catch (DateTimeParseException ex) {
            throw new ProviderApiException(
                    ProviderErrorCode.VALIDATION_ERROR,
                    "metadata.validFrom and metadata.validTo must be valid ISO-8601 instants",
                    List.of(
                            new ValidationIssue("metadata.validFrom", "must be ISO-8601 instant"),
                            new ValidationIssue("metadata.validTo", "must be ISO-8601 instant")
                    )
            );
        }
    }

    private void requireText(String value, String field, List<ValidationIssue> issues) {
        if (value == null || value.isBlank()) {
            issues.add(new ValidationIssue(field, "required"));
        }
    }

    // --- Método añadido para el nuevo repositorio de Paciente ---
    public Optional<Paciente> findPacienteByNifDni(String nifDni) {
        return pacienteRepository.findByNifDni(nifDni);
    }
}
