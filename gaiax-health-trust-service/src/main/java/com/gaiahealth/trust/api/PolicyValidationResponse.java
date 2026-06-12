package com.gaiahealth.trust.api;

public record PolicyValidationResponse(
        boolean allowed,
        String policyId,
        String reason
) {
}