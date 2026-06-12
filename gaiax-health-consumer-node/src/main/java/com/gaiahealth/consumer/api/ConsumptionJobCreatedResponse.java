package com.gaiahealth.consumer.api;

public record ConsumptionJobCreatedResponse(
        String jobId,
        String status,
        String startedAt
) {
}