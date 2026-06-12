package com.gaiahealth.consumer.domain;

public record ConsumerValidationIssue(
        String field,
        String issue
) {
}