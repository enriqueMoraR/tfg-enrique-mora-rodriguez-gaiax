package com.gaiahealth.consumer.api;

public record ConsumptionJobStatusResponse(
        String jobId,
        String status,
        String datasetId,
        String consumerId,
        String consumerDid,
        String receiverDid,
        String purpose,
        String consentStatus,
        String decisionReason,
        String validFrom,
        String validTo,
        Integer recordsProcessed,
        String finishedAt
) {
}
