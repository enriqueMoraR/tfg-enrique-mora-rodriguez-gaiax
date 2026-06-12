package com.gaiahealth.trust.api;

public record AccessRequestCreatedResponse(
        String requestId,
        String status,
        String createdAt
) {
}