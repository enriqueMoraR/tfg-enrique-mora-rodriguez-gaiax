package com.gaiahealth.trust.domain;

import java.util.List;

public class TrustApiException extends RuntimeException {
    private final TrustErrorCode code;
    private final List<TrustValidationIssue> details;

    public TrustApiException(TrustErrorCode code, String message) {
        this(code, message, List.of());
    }

    public TrustApiException(TrustErrorCode code, String message, List<TrustValidationIssue> details) {
        super(message);
        this.code = code;
        this.details = details;
    }

    public TrustErrorCode code() {
        return code;
    }

    public List<TrustValidationIssue> details() {
        return details;
    }
}