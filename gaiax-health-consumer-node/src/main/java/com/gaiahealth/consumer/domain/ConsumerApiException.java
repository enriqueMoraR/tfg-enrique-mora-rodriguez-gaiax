package com.gaiahealth.consumer.domain;

import java.util.List;

public class ConsumerApiException extends RuntimeException {
    private final ConsumerErrorCode code;
    private final List<ConsumerValidationIssue> details;

    public ConsumerApiException(ConsumerErrorCode code, String message) {
        this(code, message, List.of());
    }

    public ConsumerApiException(ConsumerErrorCode code, String message, List<ConsumerValidationIssue> details) {
        super(message);
        this.code = code;
        this.details = details;
    }

    public ConsumerErrorCode code() {
        return code;
    }

    public List<ConsumerValidationIssue> details() {
        return details;
    }
}