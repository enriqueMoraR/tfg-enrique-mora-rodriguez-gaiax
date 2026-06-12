package com.gaiahealth.trust.api;

import com.gaiahealth.trust.domain.PolicyService;
import com.gaiahealth.trust.application.TrustService;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;

class TrustControllerTest {

    @Test
    void createAccessRequestReturnsCreatedResponse() {
        RecordingTrustService trustService = new RecordingTrustService();
        TrustController controller = new TrustController(trustService);
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
        AccessRequestCreatedResponse expected = new AccessRequestCreatedResponse("ar-1", "PENDING", "2026-06-10T00:00:00Z");
        trustService.createResponse = expected;

        ResponseEntity<AccessRequestCreatedResponse> response = controller.createAccessRequest(request);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertSame(expected, response.getBody());
        assertSame(request, trustService.lastCreateRequest);
    }

    @Test
    void getAccessRequestReturnsServiceResponse() {
        RecordingTrustService trustService = new RecordingTrustService();
        TrustController controller = new TrustController(trustService);
        AccessRequestStatusResponse expected = new AccessRequestStatusResponse(
                "ar-1",
                "dataset-1",
                "consumer-1",
                "did:web:consumer.gaiax-health.local",
                "did:web:provider.gaiax-health.local",
                "research",
                "2026-01-01T00:00:00Z",
                "2026-12-31T23:59:59Z",
                "APPROVED",
                "consent-role-scope-purpose-match",
                "2026-06-10T00:00:00Z"
        );
        trustService.statusResponse = expected;

        AccessRequestStatusResponse response = controller.getAccessRequest("ar-1");

        assertSame(expected, response);
        assertEquals("ar-1", trustService.lastRequestId);
    }

    @Test
    void validatePolicyReturnsServiceResponse() {
        RecordingTrustService trustService = new RecordingTrustService();
        TrustController controller = new TrustController(trustService);
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
        PolicyValidationResponse expected = new PolicyValidationResponse(true, "policy-001", "consent-role-scope-purpose-match");
        trustService.validationResponse = expected;

        PolicyValidationResponse response = controller.validatePolicy(request);

        assertSame(expected, response);
        assertSame(request, trustService.lastValidationRequest);
    }

    private static final class RecordingTrustService extends TrustService {
        private CreateAccessRequestRequest lastCreateRequest;
        private String lastRequestId;
        private PolicyValidationRequest lastValidationRequest;
        private AccessRequestCreatedResponse createResponse;
        private AccessRequestStatusResponse statusResponse;
        private PolicyValidationResponse validationResponse;

        private RecordingTrustService() {
            super(new PolicyService());
        }

        @Override
        public AccessRequestCreatedResponse createAccessRequest(CreateAccessRequestRequest request) {
            lastCreateRequest = request;
            return createResponse;
        }

        @Override
        public AccessRequestStatusResponse getAccessRequestStatus(String requestId) {
            lastRequestId = requestId;
            return statusResponse;
        }

        @Override
        public PolicyValidationResponse validatePolicy(PolicyValidationRequest request) {
            lastValidationRequest = request;
            return validationResponse;
        }
    }
}
