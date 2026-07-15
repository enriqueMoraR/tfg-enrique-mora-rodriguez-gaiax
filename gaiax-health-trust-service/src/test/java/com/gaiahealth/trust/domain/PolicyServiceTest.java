package com.gaiahealth.trust.domain;

import com.gaiahealth.trust.api.PolicyValidationRequest;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PolicyServiceTest {

    private final PolicyService service = new PolicyService();

    @Test
    void validateRejectsNullRequest() {
        TrustApiException ex = assertThrows(TrustApiException.class, () -> service.validate(null));

        assertEquals(TrustErrorCode.VALIDATION_ERROR, ex.code());
        assertEquals("request body is required", ex.getMessage());
    }

    @Test
    void validateRejectsMissingFields() {
        PolicyValidationRequest request = new PolicyValidationRequest("", "", "", List.of());

        TrustApiException ex = assertThrows(TrustApiException.class, () -> service.validate(request));

        assertEquals(TrustErrorCode.VALIDATION_ERROR, ex.code());
        assertEquals("Invalid policy request", ex.getMessage());
        assertEquals(8, ex.details().size());
        assertEquals("datasetId", ex.details().get(0).field());
        assertEquals("required", ex.details().get(0).issue());
        assertEquals("consumerId", ex.details().get(1).field());
        assertEquals("required", ex.details().get(1).issue());
        assertEquals("consumerDid", ex.details().get(2).field());
        assertEquals("required", ex.details().get(2).issue());
        assertEquals("receiverDid", ex.details().get(3).field());
        assertEquals("required", ex.details().get(3).issue());
        assertEquals("purpose", ex.details().get(4).field());
        assertEquals("required", ex.details().get(4).issue());
        assertEquals("scopes", ex.details().get(5).field());
        assertEquals("required", ex.details().get(5).issue());
        assertEquals("validFrom", ex.details().get(6).field());
        assertEquals("required", ex.details().get(6).issue());
        assertEquals("validTo", ex.details().get(7).field());
        assertEquals("required", ex.details().get(7).issue());
    }

    @Test
    void validateAllowsMatchingPolicy() {
        PolicyValidationRequest request = new PolicyValidationRequest(
                "dataset-1",
                "consumer-1",
                "did:web:consumer.gaiax-health.local",
                "did:web:provider.gaiax-health.local",
                "research",
                List.of("dataset.read", "profile.read"),
                "2026-01-01T00:00:00Z",
                "2026-12-31T23:59:59Z"
        );

        var response = service.validate(request);

        assertTrue(response.allowed());
        assertEquals("policy-001", response.policyId());
        assertEquals("consent-role-scope-purpose-match", response.reason());
    }

    @Test
    void validateDeniesWhenScopeOrPurposeMismatch() {
        PolicyValidationRequest request = new PolicyValidationRequest(
                "dataset-1",
                "consumer-1",
                "did:web:consumer.gaiax-health.local",
                "did:web:provider.gaiax-health.local",
                "operations",
                List.of("dataset.write"),
                "2026-01-01T00:00:00Z",
                "2026-12-31T23:59:59Z"
        );

        var response = service.validate(request);

        assertFalse(response.allowed());
        assertEquals("policy-001", response.policyId());
        assertEquals("policy-mismatch", response.reason());
    }

    @Test
    void validateDeniesExpiredConsentWindow() {
        PolicyValidationRequest request = new PolicyValidationRequest(
                "dataset-1",
                "consumer-1",
                "did:web:consumer.gaiax-health.local",
                "did:web:provider.gaiax-health.local",
                "research",
                List.of("dataset.read"),
                "2020-01-01T00:00:00Z",
                "2020-12-31T23:59:59Z"
        );

        var response = service.validate(request);

        assertFalse(response.allowed());
        assertEquals("policy-001", response.policyId());
        assertEquals("policy-mismatch", response.reason());
    }
}
