package com.gaiahealth.consumer.domain;

import com.gaiahealth.consumer.infrastructure.trust.AccessRequestStatusResponse;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
public class ConsumptionJobRecord {
    private final String jobId;
    private final String datasetId;
    private final String accessRequestId;
    private final String mode;
    private final Instant startedAt;
    private String consumerId;
    private String consumerDid;
    private String receiverDid;
    private String purpose;
    private String consentStatus;
    private String decisionReason;
    private String validFrom;
    private String validTo;
    private ConsumptionJobStatus status;
    private Integer recordsProcessed;
    private Instant finishedAt;

    public ConsumptionJobRecord(String jobId, String datasetId, String accessRequestId, String mode, Instant startedAt) {
        this.jobId = jobId;
        this.datasetId = datasetId;
        this.accessRequestId = accessRequestId;
        this.mode = mode;
        this.startedAt = startedAt;
        this.status = ConsumptionJobStatus.RUNNING;
    }

    public void completeSuccess(int recordsProcessed, Instant finishedAt) {
        this.status = ConsumptionJobStatus.SUCCEEDED;
        this.recordsProcessed = recordsProcessed;
        this.finishedAt = finishedAt;
    }

    public void completeFailure(Instant finishedAt) {
        this.status = ConsumptionJobStatus.FAILED;
        this.recordsProcessed = null;
        this.finishedAt = finishedAt;
    }

    public void applyConsentContext(AccessRequestStatusResponse access) {
        this.consumerId = access.consumerId();
        this.consumerDid = access.consumerDid();
        this.receiverDid = access.receiverDid();
        this.purpose = access.purpose();
        this.consentStatus = access.status();
        this.decisionReason = access.decisionReason();
        this.validFrom = access.validFrom();
        this.validTo = access.validTo();
    }
}
