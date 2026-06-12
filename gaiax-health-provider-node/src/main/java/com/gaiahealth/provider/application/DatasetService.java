package com.gaiahealth.provider.application;

import com.gaiahealth.provider.api.CreateDatasetRequest;
import com.gaiahealth.provider.api.DatasetItemResponse;
import com.gaiahealth.provider.api.DatasetListResponse;
import com.gaiahealth.provider.api.DatasetResponse;
import com.gaiahealth.provider.domain.ClinicalCase;
import com.gaiahealth.provider.domain.DatasetRecord;
import com.gaiahealth.provider.domain.DatasetStatus;
import com.gaiahealth.provider.domain.DatasetType;
import com.gaiahealth.provider.domain.FhirValidationService;
import com.gaiahealth.provider.domain.ProviderApiException;
import com.gaiahealth.provider.domain.ProviderErrorCode;
import com.gaiahealth.provider.domain.ValidationIssue;
import org.springframework.stereotype.Service;
import com.fasterxml.jackson.databind.JsonNode;

import java.time.Instant;
import java.time.format.DateTimeParseException;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class DatasetService {
    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(DatasetService.class);
    private final Map<String, DatasetRecord> store = new ConcurrentHashMap<>();
    private final FhirValidationService fhirValidationService;

    public DatasetService(FhirValidationService fhirValidationService) {
        this.fhirValidationService = fhirValidationService;
    }

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

        DatasetRecord existing = store.putIfAbsent(datasetId, record);
        if (existing != null) {
            throw new ProviderApiException(ProviderErrorCode.CONFLICT, "datasetId already exists");
        }

        return new DatasetResponse(datasetId, record.status().name(), publishedAt.toString());
    }

    public DatasetListResponse listDatasets(String clinicalCaseRaw, String statusRaw, int page, int size) {
        if (page < 0) {
            throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "page must be >= 0");
        }
        if (size <= 0 || size > 200) {
            throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "size must be between 1 and 200");
        }

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
        if (metadata == null) {
            throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "metadata is required");
        }

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

        if (!issues.isEmpty()) {
            throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "metadata is invalid", issues);
        }

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
}
