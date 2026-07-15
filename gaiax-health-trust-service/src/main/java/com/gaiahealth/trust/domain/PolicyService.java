package com.gaiahealth.trust.domain;

import com.gaiahealth.trust.api.PolicyValidationRequest;
import com.gaiahealth.trust.api.PolicyValidationResponse;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.format.DateTimeParseException;
import java.util.List;

@Service
public class PolicyService {
    private static final String POLICY_ID = "policy-001";

    public PolicyValidationResponse validate(PolicyValidationRequest request) {
        validateRequest(request);

        boolean roleOk = !request.getConsumerId().isBlank();
        boolean identityOk = !request.getConsumerDid().isBlank() && !request.getReceiverDid().isBlank();
        boolean scopeOk = request.getScopes() != null && request.getScopes().contains("dataset.read");
        boolean purposeOk = "research".equalsIgnoreCase(request.getPurpose());
        boolean datasetOk = !request.getDatasetId().isBlank();
        boolean consentWindowOk = consentWindowActive(request.getValidFrom(), request.getValidTo());

        boolean allowed = roleOk && identityOk && scopeOk && purposeOk && datasetOk && consentWindowOk;
        String reason = allowed ? "consent-role-scope-purpose-match" : "policy-mismatch";
        return new PolicyValidationResponse(allowed, POLICY_ID, reason);
    }

    private void validateRequest(PolicyValidationRequest request) {
        if (request == null) {
            throw new TrustApiException(TrustErrorCode.VALIDATION_ERROR, "request body is required");
        }
        List<TrustValidationIssue> issues = new java.util.ArrayList<>();
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
        if (request.getScopes() == null || request.getScopes().isEmpty()) {
            issues.add(new TrustValidationIssue("scopes", "required"));
        }
        if (request.getValidFrom() == null || request.getValidFrom().isBlank()) {
            issues.add(new TrustValidationIssue("validFrom", "required"));
        }
        if (request.getValidTo() == null || request.getValidTo().isBlank()) {
            issues.add(new TrustValidationIssue("validTo", "required"));
        }
        if (!issues.isEmpty()) {
            throw new TrustApiException(TrustErrorCode.VALIDATION_ERROR, "Invalid policy request", issues);
        }

    }

    private boolean consentWindowActive(String validFrom, String validTo) {
        try {
            Instant from = Instant.parse(validFrom);
            Instant to = Instant.parse(validTo);
            Instant now = Instant.now();
            return !now.isBefore(from) && !now.isAfter(to) && to.isAfter(from);
        } catch (DateTimeParseException | NullPointerException ex) {
            return false;
        }
    }
}
