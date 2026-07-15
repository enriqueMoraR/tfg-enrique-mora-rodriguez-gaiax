package com.gaiahealth.trust.application;

import com.gaiahealth.trust.api.CreateAccessRequestRequest;
import com.gaiahealth.trust.api.PolicyValidationRequest;
import com.gaiahealth.trust.domain.PolicyService;
import com.gaiahealth.trust.domain.TrustApiException;
import com.gaiahealth.trust.domain.TrustErrorCode;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class TrustServiceTest {

    private final PolicyService policyService = new PolicyService();

    @Test
    void createAccessRequestRejectsNullRequest() {
        TrustService service = new TrustService(policyService);

        TrustApiException ex = assertThrows(TrustApiException.class, () -> service.createAccessRequest(null));

        assertEquals(TrustErrorCode.VALIDATION_ERROR, ex.code());
        assertEquals("request body is required", ex.getMessage());
    }

    @Test
    void createAccessRequestRejectsInvalidFields() {
        TrustService service = new TrustService(policyService);

        CreateAccessRequestRequest request = new CreateAccessRequestRequest(" ", "", "", List.of());

        TrustApiException ex = assertThrows(TrustApiException.class, () -> service.createAccessRequest(request));

        assertEquals(TrustErrorCode.VALIDATION_ERROR, ex.code());
        assertEquals("Invalid access request", ex.getMessage());
        assertEquals(8, ex.details().size());
    }

    @Test
    void createAndApproveAccessRequestUpdatesAuditTrail() {
        TrustService service = new TrustService(policyService);
        CreateAccessRequestRequest request = new CreateAccessRequestRequest(
                "dataset-1",
                "consumer-1",
                "did:web:consumer.gaiax-health.local",
                "did:web:provider.gaiax-health.local",
                "research",
                List.of("dataset.read"),
                "2026-01-01T00:00:00Z",
                "2026-12-31T23:59:59Z"
        );

        var created = service.createAccessRequest(request);

        assertTrue(created.requestId().startsWith("ar-"));
        assertEquals("PENDING", created.status());
        assertNotNull(created.createdAt());
        assertEquals(1, service.auditEvents().size());
        assertEquals("ACCESS_REQUEST_CREATED", service.auditEvents().get(0).eventType());

        var status = service.getAccessRequestStatus(created.requestId());

        assertEquals(created.requestId(), status.requestId());
        assertEquals("dataset-1", status.datasetId());
        assertEquals("consumer-1", status.consumerId());
        assertEquals("did:web:consumer.gaiax-health.local", status.consumerDid());
        assertEquals("did:web:provider.gaiax-health.local", status.receiverDid());
        assertEquals("research", status.purpose());
        assertEquals("APPROVED", status.status());
        assertEquals("consent-role-scope-purpose-match", status.decisionReason());
        assertNotNull(status.decidedAt());
        assertEquals(2, service.auditEvents().size());
        assertEquals("ACCESS_REQUEST_DECIDED", service.auditEvents().get(1).eventType());
    }

    @Test
    void createAndRejectAccessRequestMarksDecisionReason() {
        TrustService service = new TrustService(policyService);
        CreateAccessRequestRequest request = new CreateAccessRequestRequest(
                "dataset-2",
                "consumer-2",
                "did:web:consumer.gaiax-health.local",
                "did:web:provider.gaiax-health.local",
                "operations",
                List.of("dataset.write"),
                "2026-01-01T00:00:00Z",
                "2026-12-31T23:59:59Z"
        );

        var created = service.createAccessRequest(request);
        var status = service.getAccessRequestStatus(created.requestId());

        assertEquals("REJECTED", status.status());
        assertEquals("policy-mismatch", status.decisionReason());
        assertNotNull(status.decidedAt());
    }

    @Test
    void getAccessRequestStatusThrowsNotFoundForMissingId() {
        TrustService service = new TrustService(policyService);

        TrustApiException ex = assertThrows(TrustApiException.class, () -> service.getAccessRequestStatus("missing"));

        assertEquals(TrustErrorCode.NOT_FOUND, ex.code());
        assertEquals("access request not found", ex.getMessage());
    }

    @Test
    void validatePolicyAddsAuditEvent() {
        TrustService service = new TrustService(policyService);
        PolicyValidationRequest request = new PolicyValidationRequest(
                "dataset-1",
                "consumer-1",
                "did:web:consumer.gaiax-health.local",
                "did:web:provider.gaiax-health.local",
                "research",
                List.of("dataset.read"),
                "2026-01-01T00:00:00Z",
                "2026-12-31T23:59:59Z"
        );

        var response = service.validatePolicy(request);

        assertTrue(response.allowed());
        assertEquals("policy-001", response.policyId());
        assertEquals(1, service.auditEvents().size());
        assertEquals("POLICY_VALIDATED", service.auditEvents().get(0).eventType());
    }

    @Test
    void testConcurrentAuditEvents() throws InterruptedException {
        TrustService service = new TrustService(policyService);
        int threadCount = 100;
        java.util.concurrent.ExecutorService executor = java.util.concurrent.Executors.newFixedThreadPool(10);
        java.util.concurrent.CountDownLatch latch = new java.util.concurrent.CountDownLatch(threadCount);

        for (int i = 0; i < threadCount; i++) {
            final int index = i;
            executor.submit(() -> {
                try {
                    PolicyValidationRequest request = new PolicyValidationRequest(
                            "dataset-" + index,
                            "consumer-1",
                            "did:web:consumer.gaiax-health.local",
                            "did:web:provider.gaiax-health.local",
                            "research",
                            List.of("dataset.read"),
                            "2026-01-01T00:00:00Z",
                            "2026-12-31T23:59:59Z"
                    );
                    service.validatePolicy(request);
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await();
        executor.shutdown();

        assertEquals(threadCount, service.auditEvents().size(), "Todos los eventos deben estar registrados sin perder ninguno");
    }
}
