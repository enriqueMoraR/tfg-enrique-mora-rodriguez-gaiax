package com.gaiahealth.trust.api;

public record TrustErrorDetailResponse(
        String field,
        String issue
) {
}