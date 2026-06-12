package com.gaiahealth.provider.domain;

public enum DatasetType {
    FHIR_BUNDLE,
    FHIR_OBSERVATION;

    public static DatasetType fromValue(String raw) {
        if (raw == null || raw.isBlank()) {
            throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "datasetType is required");
        }
        try {
            return DatasetType.valueOf(raw.trim().toUpperCase());
        } catch (IllegalArgumentException ex) {
            throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "datasetType must be FHIR_BUNDLE or FHIR_OBSERVATION");
        }
    }
}
