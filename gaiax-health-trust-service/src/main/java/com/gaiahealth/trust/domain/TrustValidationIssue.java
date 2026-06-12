package com.gaiahealth.trust.domain;

public record TrustValidationIssue(
        String field,
        String issue
) {
}