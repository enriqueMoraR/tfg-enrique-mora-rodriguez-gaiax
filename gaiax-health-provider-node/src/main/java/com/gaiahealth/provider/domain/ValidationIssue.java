package com.gaiahealth.provider.domain;

public record ValidationIssue(
        String field,
        String issue
) {
}
