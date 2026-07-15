package com.gaiahealth.trust.application;

import com.gaiahealth.trust.api.AccessRequestCreatedResponse;
import com.gaiahealth.trust.api.AccessRequestStatusResponse;
import com.gaiahealth.trust.api.CreateAccessRequestRequest;
import com.gaiahealth.trust.api.PolicyValidationRequest;
import com.gaiahealth.trust.api.PolicyValidationResponse;
import com.gaiahealth.trust.domain.AccessRequestRecord;
import com.gaiahealth.trust.domain.AccessRequestStatus;
import com.gaiahealth.trust.domain.AuditEvent;
import com.gaiahealth.trust.domain.PolicyService;
import com.gaiahealth.trust.domain.TrustApiException;
import com.gaiahealth.trust.domain.TrustErrorCode;
import com.gaiahealth.trust.domain.TrustValidationIssue;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
public class TrustService {
    private final Map<String, AccessRequestRecord> accessRequests = new ConcurrentHashMap<>();
    private final List<AuditEvent> auditEvents = new CopyOnWriteArrayList<>();
    private final PolicyService policyService;

    public TrustService(PolicyService policyService) {
        this.policyService = policyService;
    }

    public AccessRequestCreatedResponse createAccessRequest(CreateAccessRequestRequest request) {
        validateCreateRequest(request);
        String requestId = "ar-" + UUID.randomUUID().toString().substring(0, 8);
        Instant createdAt = Instant.now();
        AccessRequestRecord record = new AccessRequestRecord(
                requestId,
                request.getDatasetId().trim(),
                request.getConsumerId().trim(),
                request.getConsumerDid().trim(),
                request.getReceiverDid().trim(),
                request.getPurpose().trim(),
                request.getRequestedScopes(),
                request.getValidFrom().trim(),
                request.getValidTo().trim(),
                createdAt
        );
        accessRequests.put(requestId, record);
        auditEvents.add(new AuditEvent("ACCESS_REQUEST_CREATED", requestId, "status=PENDING", createdAt));
        return new AccessRequestCreatedResponse(requestId, AccessRequestStatus.PENDING.name(), createdAt.toString());
    }

    public AccessRequestStatusResponse getAccessRequestStatus(String requestId) {
        AccessRequestRecord record = accessRequests.get(requestId);
        if (record == null) {
            throw new TrustApiException(TrustErrorCode.NOT_FOUND, "access request not found");
        }

        synchronized (record) {
            if (record.getStatus() == AccessRequestStatus.PENDING) {
                PolicyValidationRequest validationRequest = new PolicyValidationRequest(
                        record.getDatasetId(),
                        record.getConsumerId(),
                        record.getConsumerDid(),
                        record.getReceiverDid(),
                        record.getPurpose(),
                        record.getRequestedScopes(),
                        record.getValidFrom(),
                        record.getValidTo()
                );
                PolicyValidationResponse decision = policyService.validate(validationRequest);
                AccessRequestStatus decidedStatus = decision.allowed() ? AccessRequestStatus.APPROVED : AccessRequestStatus.REJECTED;
                Instant decidedAt = Instant.now();
                record.decide(decidedStatus, decision.reason(), decidedAt);
                auditEvents.add(new AuditEvent(
                        "ACCESS_REQUEST_DECIDED",
                        requestId,
                        "status=" + decidedStatus + ",reason=" + decision.reason(),
                        decidedAt
                ));
            }
        }

        return new AccessRequestStatusResponse(
                record.getRequestId(),
                record.getDatasetId(),
                record.getConsumerId(),
                record.getConsumerDid(),
                record.getReceiverDid(),
                record.getPurpose(),
                record.getValidFrom(),
                record.getValidTo(),
                record.getStatus().name(),
                record.getDecisionReason(),
                record.getDecidedAt() == null ? null : record.getDecidedAt().toString()
        );
    }

    public PolicyValidationResponse validatePolicy(PolicyValidationRequest request) {
        PolicyValidationResponse response = policyService.validate(request);
        auditEvents.add(new AuditEvent(
                "POLICY_VALIDATED",
                null,
                "allowed=" + response.allowed() + ",reason=" + response.reason(),
                Instant.now()
        ));
        return response;
    }

    public List<AuditEvent> auditEvents() {
        return List.copyOf(auditEvents);
    }

    private void validateCreateRequest(CreateAccessRequestRequest request) {
        if (request == null) {
            throw new TrustApiException(TrustErrorCode.VALIDATION_ERROR, "request body is required");
        }

        List<TrustValidationIssue> issues = new ArrayList<>();
        if (request.getDatasetId() == null || request.getDatasetId().isBlank()) {
            issues.add(new TrustValidationIssue("datasetId", "required"));
        }
        if (request.getConsumerId() == null || request.getConsumerId().isBlank()) {
            issues.add(new TrustValidationIssue("consumerId", "required"));
        }
        if (request.getConsumerDid() == null || request.getConsumerDid().isBlank()) {
            issues.add(new TrustValidationIssue("consumerDid", "required"));
        }
        if (request.getReceiverDid() == null || request.getReceiverDid().isBlank()) {
            issues.add(new TrustValidationIssue("receiverDid", "required"));
        }
        if (request.getPurpose() == null || request.getPurpose().isBlank()) {
            issues.add(new TrustValidationIssue("purpose", "required"));
        }
        if (request.getRequestedScopes() == null || request.getRequestedScopes().isEmpty()) {
            issues.add(new TrustValidationIssue("requestedScopes", "required"));
        }
        if (request.getValidFrom() == null || request.getValidFrom().isBlank()) {
            issues.add(new TrustValidationIssue("validFrom", "required"));
        }
        if (request.getValidTo() == null || request.getValidTo().isBlank()) {
            issues.add(new TrustValidationIssue("validTo", "required"));
        }
        if (!issues.isEmpty()) {
            throw new TrustApiException(TrustErrorCode.VALIDATION_ERROR, "Invalid access request", issues);
        }
    }
}
