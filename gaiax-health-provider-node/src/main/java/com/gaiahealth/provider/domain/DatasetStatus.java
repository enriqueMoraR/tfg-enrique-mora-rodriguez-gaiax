package com.gaiahealth.provider.domain;

public enum DatasetStatus {
    PUBLISHED,
    REVOKED;

    public static DatasetStatus fromValue(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        try {
            return DatasetStatus.valueOf(raw.trim().toUpperCase());
        } catch (IllegalArgumentException ex) {
            throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "status must be PUBLISHED or REVOKED");
        }
    }
}
