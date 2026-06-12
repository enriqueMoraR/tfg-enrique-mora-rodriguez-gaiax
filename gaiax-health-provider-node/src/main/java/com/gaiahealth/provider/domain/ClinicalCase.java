package com.gaiahealth.provider.domain;

public enum ClinicalCase {
    BLOOD_PRESSURE("blood-pressure"),
    HEART_RATE("heart-rate");

    private final String value;

    ClinicalCase(String value) {
        this.value = value;
    }

    public String value() {
        return value;
    }

    public static ClinicalCase fromValue(String raw) {
        if (raw == null || raw.isBlank()) {
            throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "clinicalCase is required");
        }
        for (ClinicalCase clinicalCase : values()) {
            if (clinicalCase.value.equals(raw.trim())) {
                return clinicalCase;
            }
        }
        throw new ProviderApiException(
                ProviderErrorCode.VALIDATION_ERROR,
                "clinicalCase must be blood-pressure or heart-rate"
        );
    }
}
