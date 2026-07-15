package com.gaiahealth.consumer.application;

import com.gaiahealth.consumer.api.CreateConsumptionJobRequest;
import com.gaiahealth.consumer.domain.ConsumptionJobRecord;
import com.gaiahealth.consumer.domain.ConsumerApiException;
import com.gaiahealth.consumer.domain.ConsumerErrorCode;
import com.gaiahealth.consumer.domain.TrustAccessClient;
import com.gaiahealth.consumer.infrastructure.trust.AccessRequestStatusResponse;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;
import org.awaitility.Awaitility;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;

import static org.junit.jupiter.api.Assertions.*;
class ConsumerServiceTest {

    private TrustAccessClient trustAccessClient;

    private ConsumerService service;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @BeforeEach
    void setUp() {
        trustAccessClient = requestId -> {
            throw new IllegalStateException("trust client not configured for " + requestId);
        };
        service = new ConsumerService(trustAccessClient, "http://localhost:8081");
    }

    @Test
    void createConsumptionJobRejectsNullRequest() {
        ConsumerApiException ex = assertThrows(ConsumerApiException.class, () -> service.createConsumptionJob(null));

        assertEquals(ConsumerErrorCode.VALIDATION_ERROR, ex.code());
        assertEquals("request body is required", ex.getMessage());
        assertTrue(ex.details().isEmpty());
    }

    @Test
    void createConsumptionJobRejectsInvalidFields() {
        CreateConsumptionJobRequest request = new CreateConsumptionJobRequest(" ", "", "poll");

        ConsumerApiException ex = assertThrows(ConsumerApiException.class, () -> service.createConsumptionJob(request));

        assertEquals(ConsumerErrorCode.VALIDATION_ERROR, ex.code());
        assertEquals("Invalid consumption job request", ex.getMessage());
        assertEquals(3, ex.details().size());
        assertEquals("datasetId", ex.details().get(0).field());
        assertEquals("required", ex.details().get(0).issue());
        assertEquals("accessRequestId", ex.details().get(1).field());
        assertEquals("required", ex.details().get(1).issue());
        assertEquals("mode", ex.details().get(2).field());
        assertEquals("must be DOWNLOAD", ex.details().get(2).issue());
    }

    @Test
    void createConsumptionJobMarksJobFailedWhenTrustRejects() {
        trustAccessClient = requestId -> new AccessRequestStatusResponse(
                requestId,
                "dataset-alpha",
                "consumer-1",
                "did:web:consumer.gaiax-health.local",
                "did:web:provider.gaiax-health.local",
                "research",
                "2026-06-10T00:00:00Z",
                "2026-12-31T23:59:59Z",
                "REJECTED",
                "Denied",
                "2026-06-10T00:00:00Z"
        );
        service = new ConsumerService(trustAccessClient, "http://localhost:8081");

        CreateConsumptionJobRequest request = new CreateConsumptionJobRequest("dataset-alpha", "ar-001", "download");
        var created = service.createConsumptionJob(request);
        Awaitility.await().atMost(Duration.ofSeconds(5))
            .until(() -> "FAILED".equals(service.getConsumptionJob(created.jobId()).status()));
        var status = service.getConsumptionJob(created.jobId());
        List<Map<String, Object>> jobs = service.listConsumptionJobs("alpha", false);

        assertEquals("RUNNING", created.status());
        assertNotNull(created.startedAt());
        assertEquals(created.jobId(), status.jobId());
        assertEquals("FAILED", status.status());
        assertEquals("dataset-alpha", status.datasetId());
        assertNull(status.recordsProcessed());
        assertNotNull(status.finishedAt());
        assertEquals(1, jobs.size());
        assertEquals(created.jobId(), jobs.get(0).get("id"));
        assertEquals("dataset-alpha", jobs.get(0).get("patientId"));
        assertEquals("FAILED", jobs.get(0).get("status"));
        assertTrue(((List<?>) jobs.get(0).get("measurements")).isEmpty());
    }

    @Test
    void createConsumptionJobMarksJobFailedWhenTrustThrows() {
        trustAccessClient = requestId -> {
            throw new ConsumerApiException(ConsumerErrorCode.INTERNAL_ERROR, "trust down");
        };
        service = new ConsumerService(trustAccessClient, "http://localhost:8081");

        CreateConsumptionJobRequest request = new CreateConsumptionJobRequest("dataset-beta", "ar-002", "download");
        var created = service.createConsumptionJob(request);
        Awaitility.await().atMost(Duration.ofSeconds(5))
            .until(() -> "FAILED".equals(service.getConsumptionJob(created.jobId()).status()));
        var status = service.getConsumptionJob(created.jobId());

        assertEquals("RUNNING", created.status());
        assertEquals("FAILED", status.status());
        assertEquals("dataset-beta", status.datasetId());
        assertNull(status.recordsProcessed());
        assertNotNull(status.finishedAt());
    }

    @Test
    void createConsumptionJobMarksJobSucceededAndPreservesConsentContext() throws Exception {
        JsonNode bundle = readJsonResource("/fhir/payloads/bundle-sample.json");
        trustAccessClient = requestId -> new AccessRequestStatusResponse(
                requestId,
                "dataset-approval",
                "consumer-approval",
                "did:web:consumer.gaiax-health.local",
                "did:web:provider.gaiax-health.local",
                "research",
                "2026-06-10T00:00:00Z",
                "2026-12-31T23:59:59Z",
                "APPROVED",
                "consent-role-scope-purpose-match",
                "2026-06-10T00:00:00Z"
        );
        service = new TestableConsumerService(trustAccessClient, bundle);

        CreateConsumptionJobRequest request = new CreateConsumptionJobRequest("dataset-approval", "ar-003", "download");
        var created = service.createConsumptionJob(request);
        Awaitility.await().atMost(Duration.ofSeconds(5))
            .until(() -> "SUCCEEDED".equals(service.getConsumptionJob(created.jobId()).status()));
        var status = service.getConsumptionJob(created.jobId());
        List<Map<String, Object>> summary = service.listConsumptionJobs("dataset-approval", true);
        List<Map<String, Object>> detailed = service.listConsumptionJobs("dataset-approval", false);

        assertEquals("RUNNING", created.status());
        assertEquals("SUCCEEDED", status.status());
        assertEquals("dataset-approval", status.datasetId());
        assertEquals("consumer-approval", status.consumerId());
        assertEquals("did:web:consumer.gaiax-health.local", status.consumerDid());
        assertEquals("did:web:provider.gaiax-health.local", status.receiverDid());
        assertEquals("research", status.purpose());
        assertEquals("APPROVED", status.consentStatus());
        assertEquals("consent-role-scope-purpose-match", status.decisionReason());
        assertNotNull(status.recordsProcessed());
        assertEquals(1, summary.size());
        assertFalse(summary.get(0).containsKey("measurements"));
        assertEquals("APPROVED", summary.get(0).get("consentStatus"));
        assertEquals(1, detailed.size());
        assertTrue(((List<?>) detailed.get(0).get("measurements")).size() > 0);
    }

    @Test
    void getConsumptionJobThrowsNotFoundForMissingJob() {
        ConsumerApiException ex = assertThrows(ConsumerApiException.class, () -> service.getConsumptionJob("missing"));

        assertEquals(ConsumerErrorCode.NOT_FOUND, ex.code());
        assertEquals("consumption job not found", ex.getMessage());
    }

    @Test
    void listConsumptionJobsFiltersByPatientIdCaseInsensitive() {
        AtomicReference<String> lastRequestId = new AtomicReference<>();
        trustAccessClient = requestId -> {
            lastRequestId.set(requestId);
            return new AccessRequestStatusResponse(
                    requestId,
                    "dataset-placeholder",
                    "consumer-1",
                    "did:web:consumer.gaiax-health.local",
                    "did:web:provider.gaiax-health.local",
                    "research",
                    "2026-06-10T00:00:00Z",
                    "2026-12-31T23:59:59Z",
                    "REJECTED",
                    "Denied",
                    "2026-06-10T00:00:00Z"
            );
        };
        service = new ConsumerService(trustAccessClient, "http://localhost:8081");

        service.createConsumptionJob(new CreateConsumptionJobRequest("patient-alpha-dataset", "ar-101", "download"));
        service.createConsumptionJob(new CreateConsumptionJobRequest("patient-beta-dataset", "ar-102", "download"));
        Awaitility.await().atMost(Duration.ofSeconds(5))
            .until(() -> service.listConsumptionJobs("", false).stream()
                 .allMatch(j -> !"RUNNING".equals(j.get("status"))));

        List<Map<String, Object>> filtered = service.listConsumptionJobs("ALPHA", false);

        assertEquals(1, filtered.size());
        assertEquals("patient-alpha-dataset", filtered.get(0).get("patientId"));
        assertTrue(lastRequestId.get().startsWith("ar-"));
    }

    @Test
    void extractMeasurementsFromBundleParsesBloodPressureFixture() throws Exception {
        JsonNode bundle = readJsonResource("/fhir/payloads/bundle-sample.json");

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> measurements = (List<Map<String, Object>>) ReflectionTestUtils.invokeMethod(
                service,
                "extractMeasurementsFromPayload",
                bundle
        );

        assertNotNull(measurements);
        assertEquals(1, measurements.size());
        Map<String, Object> measurement = measurements.get(0);
        assertEquals("2026-01-01T00:00:00Z", measurement.get("timestamp"));
        assertEquals("blood-pressure", measurement.get("type"));
        assertEquals("120/80 mm[Hg]", measurement.get("value"));
        assertEquals("mm[Hg]", measurement.get("unit"));
    }

    @Test
    void extractMeasurementsFromPayloadParsesStandaloneObservationFixture() throws Exception {
        JsonNode observation = readJsonResource("/fhir/payloads/observation-real-2026.json");

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> measurements = (List<Map<String, Object>>) ReflectionTestUtils.invokeMethod(
                service,
                "extractMeasurementsFromPayload",
                observation
        );

        assertNotNull(measurements);
        assertEquals(1, measurements.size());
        Map<String, Object> measurement = measurements.get(0);
        assertEquals("2026-06-10T10:25:00+02:00", measurement.get("timestamp"));
        assertEquals("blood-pressure", measurement.get("type"));
        assertEquals("128/82 mmHg", measurement.get("value"));
        assertEquals("mmHg", measurement.get("unit"));
        @SuppressWarnings("unchecked")
        Map<String, Object> device = (Map<String, Object>) measurement.get("device");
        assertNotNull(device);
        assertEquals("Device/tensiometer-omron-x200", device.get("reference"));
    }

    @Test
    void extractMeasurementsFromBundleParsesHeartRateAndFallbackObservation() throws Exception {
        JsonNode bundle = objectMapper.readTree("""
                {
                  "resourceType": "Bundle",
                  "entry": [
                    {
                      "resource": {
                        "resourceType": "Patient",
                        "id": "patient-0001"
                      }
                    },
                    {
                      "resource": {
                        "resourceType": "Observation",
                        "id": "heart-rate-0001",
                        "status": "final",
                        "code": {
                          "coding": [
                            { "code": "8867-4" }
                          ]
                        },
                        "subject": { "reference": "Patient/patient-0001" },
                        "issued": "2026-02-01T00:00:00Z",
                        "valueQuantity": {
                          "value": 72,
                          "unit": "bpm"
                        }
                      }
                    },
                    {
                      "resource": {
                        "resourceType": "Observation",
                        "id": "other-0001",
                        "status": "final",
                        "code": {
                          "coding": [
                            { "code": "9999-9" }
                          ]
                        },
                        "subject": { "reference": "Patient/patient-0001" },
                        "issued": "2026-02-02T00:00:00Z",
                        "valueQuantity": {
                          "value": 98,
                          "unit": "%"
                        }
                      }
                    }
                  ]
                }
                """);

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> measurements = (List<Map<String, Object>>) ReflectionTestUtils.invokeMethod(
                service,
                "extractMeasurementsFromPayload",
                bundle
        );

        assertNotNull(measurements);
        assertEquals(2, measurements.size());

        Map<String, Object> heartRate = measurements.stream()
                .filter(m -> "heart-rate".equals(m.get("type")))
                .findFirst()
                .orElseThrow();
        assertEquals("2026-02-01T00:00:00Z", heartRate.get("timestamp"));
        assertEquals("72 bpm", heartRate.get("value"));
        assertEquals("bpm", heartRate.get("unit"));

        Map<String, Object> fallback = measurements.stream()
                .filter(m -> "observation".equals(m.get("type")))
                .findFirst()
                .orElseThrow();
        assertEquals("2026-02-02T00:00:00Z", fallback.get("timestamp"));
        assertEquals("98 %", fallback.get("value"));
        assertEquals("%", fallback.get("unit"));
    }

    private JsonNode readJsonResource(String resourcePath) throws Exception {
        try (InputStream inputStream = getClass().getResourceAsStream(resourcePath)) {
            assertNotNull(inputStream, "Missing test resource: " + resourcePath);
            return objectMapper.readTree(new String(inputStream.readAllBytes(), StandardCharsets.UTF_8));
        }
    }

    private static final class TestableConsumerService extends ConsumerService {
        private final JsonNode payload;

        private TestableConsumerService(TrustAccessClient trustAccessClient, JsonNode payload) {
            super(trustAccessClient, "http://localhost:8081");
            this.payload = payload;
        }

        @Override
        protected JsonNode fetchProviderPayload(ConsumptionJobRecord record) {
            return payload;
        }
    }
}
