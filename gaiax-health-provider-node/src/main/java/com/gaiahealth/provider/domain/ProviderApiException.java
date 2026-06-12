package com.gaiahealth.provider.domain;

import java.util.List;

public class ProviderApiException extends RuntimeException {
    private final ProviderErrorCode code;
    private final List<ValidationIssue> details;

    public ProviderApiException(ProviderErrorCode code, String message) {
        this(code, message, List.of());
    }

    public ProviderApiException(ProviderErrorCode code, String message, List<ValidationIssue> details) {
        super(message);
        this.code = code;
        this.details = details;
    }

    public ProviderErrorCode code() {
        return code;
    }

    public List<ValidationIssue> details() {
        return details;
    }
}
