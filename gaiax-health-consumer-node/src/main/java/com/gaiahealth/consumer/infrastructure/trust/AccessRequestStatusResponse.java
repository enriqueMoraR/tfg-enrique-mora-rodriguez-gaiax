package com.gaiahealth.consumer.infrastructure.trust;

public record AccessRequestStatusResponse(
        String requestId,
        String datasetId,
        String consumerId,
        String consumerDid,
        String receiverDid,
        String purpose,
        String validFrom,
        String validTo,
        String status,
        String decisionReason,
        String decidedAt
) {
}
