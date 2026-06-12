package com.gaiahealth.consumer.api;

import com.gaiahealth.consumer.application.ConsumerService;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
class ConsumerControllerTest {

    @Test
    void createJobReturnsAcceptedResponse() {
        RecordingConsumerService consumerService = new RecordingConsumerService();
        ConsumerController controller = new ConsumerController(consumerService);
        CreateConsumptionJobRequest request = new CreateConsumptionJobRequest("dataset-1", "ar-1", "download");
        ConsumptionJobCreatedResponse serviceResponse = new ConsumptionJobCreatedResponse("cj-123", "RUNNING", "2026-06-10T00:00:00Z");
        consumerService.createJobResponse = serviceResponse;

        ResponseEntity<ConsumptionJobCreatedResponse> response = controller.createJob(request);

        assertEquals(HttpStatus.ACCEPTED, response.getStatusCode());
        assertSame(serviceResponse, response.getBody());
        assertSame(request, consumerService.lastCreateRequest);
    }

    @Test
    void listJobsDelegatesFilterParameter() {
        RecordingConsumerService consumerService = new RecordingConsumerService();
        ConsumerController controller = new ConsumerController(consumerService);
        List<Map<String, Object>> jobs = List.of(Map.of("id", "cj-1"));
        consumerService.listJobsResponse = jobs;

        List<Map<String, Object>> response = controller.listJobs("alpha", true);

        assertSame(jobs, response);
        assertEquals("alpha", consumerService.lastPatientFilter);
        assertEquals(true, consumerService.lastSummaryOnly);
    }

    @Test
    void getJobReturnsServiceResponse() {
        RecordingConsumerService consumerService = new RecordingConsumerService();
        ConsumerController controller = new ConsumerController(consumerService);
        ConsumptionJobStatusResponse serviceResponse = new ConsumptionJobStatusResponse(
                "cj-1",
                "FAILED",
                "dataset-1",
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                "2026-06-10T00:00:00Z"
        );
        consumerService.getJobResponse = serviceResponse;

        ConsumptionJobStatusResponse response = controller.getJob("cj-1");

        assertSame(serviceResponse, response);
        assertEquals("cj-1", consumerService.lastJobId);
    }

    private static final class RecordingConsumerService extends ConsumerService {
        private CreateConsumptionJobRequest lastCreateRequest;
        private String lastPatientFilter;
        private Boolean lastSummaryOnly;
        private String lastJobId;
        private ConsumptionJobCreatedResponse createJobResponse;
        private List<Map<String, Object>> listJobsResponse;
        private ConsumptionJobStatusResponse getJobResponse;

        private RecordingConsumerService() {
            super(requestId -> {
                throw new UnsupportedOperationException("not used in controller test");
            });
        }

        @Override
        public ConsumptionJobCreatedResponse createConsumptionJob(CreateConsumptionJobRequest request) {
            lastCreateRequest = request;
            return createJobResponse;
        }

        @Override
        public List<Map<String, Object>> listConsumptionJobs(String patientIdFilter, boolean summaryOnly) {
            lastPatientFilter = patientIdFilter;
            lastSummaryOnly = summaryOnly;
            return listJobsResponse;
        }

        @Override
        public ConsumptionJobStatusResponse getConsumptionJob(String jobId) {
            lastJobId = jobId;
            return getJobResponse;
        }
    }
}
