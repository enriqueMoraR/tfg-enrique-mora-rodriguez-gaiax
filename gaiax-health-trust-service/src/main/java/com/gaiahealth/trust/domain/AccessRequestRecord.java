package com.gaiahealth.trust.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.List;

@Getter
@Setter
public class AccessRequestRecord {
    private final String requestId;
    private final String datasetId;
    private final String consumerId;
    private final String consumerDid;
    private final String receiverDid;
    private final String purpose;
    private final List<String> requestedScopes;
    private final String validFrom;
    private final String validTo;
    private final Instant createdAt;
    private AccessRequestStatus status;
    private String decisionReason;
    private Instant decidedAt;

    public AccessRequestRecord(
            String requestId,
            String datasetId,
            String consumerId,
            String consumerDid,
            String receiverDid,
            String purpose,
            List<String> requestedScopes,
            String validFrom,
            String validTo,
            Instant createdAt
    ) {
        this.requestId = requestId;
        this.datasetId = datasetId;
        this.consumerId = consumerId;
        this.consumerDid = consumerDid;
        this.receiverDid = receiverDid;
        this.purpose = purpose;
        this.requestedScopes = requestedScopes;
        this.validFrom = validFrom;
        this.validTo = validTo;
        this.createdAt = createdAt;
        this.status = AccessRequestStatus.PENDING;
    }

    public void decide(AccessRequestStatus status, String decisionReason, Instant decidedAt) {
        this.status = status;
        this.decisionReason = decisionReason;
        this.decidedAt = decidedAt;
    }
}
