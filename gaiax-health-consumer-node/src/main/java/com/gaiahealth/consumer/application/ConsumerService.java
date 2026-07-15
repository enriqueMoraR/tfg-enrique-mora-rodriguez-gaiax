package com.gaiahealth.consumer.application;

import com.gaiahealth.consumer.api.ConsumptionJobCreatedResponse;
import com.gaiahealth.consumer.api.ConsumptionJobStatusResponse;
import com.gaiahealth.consumer.api.CreateConsumptionJobRequest;
import com.gaiahealth.consumer.domain.ConsumptionJobRecord;
import com.gaiahealth.consumer.domain.ConsumptionJobStatus;
import com.gaiahealth.consumer.domain.ConsumerApiException;
import com.gaiahealth.consumer.domain.ConsumerErrorCode;
import com.gaiahealth.consumer.domain.ConsumerValidationIssue;
import com.gaiahealth.consumer.domain.TrustAccessClient;
import com.gaiahealth.consumer.infrastructure.trust.AccessRequestStatusResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.concurrent.CompletableFuture;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class ConsumerService {
    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(ConsumerService.class);
    private final Map<String, ConsumptionJobRecord> jobs = new ConcurrentHashMap<>();
    private final Map<String, List<Map<String, Object>>> jobMeasurements = new ConcurrentHashMap<>();
    private final TrustAccessClient trustAccessClient;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final RestClient restClient;
    private final String providerBaseUrl;

    public ConsumerService(
            TrustAccessClient trustAccessClient,
            @Value("${gaiax.provider.base-url:http://localhost:8081}") String providerBaseUrl
    ) {
        this.trustAccessClient = trustAccessClient;
        this.providerBaseUrl = providerBaseUrl;
        this.restClient = RestClient.create();
    }

    public ConsumptionJobCreatedResponse createConsumptionJob(CreateConsumptionJobRequest request) {
        validateCreateRequest(request);
        String jobId = "cj-" + UUID.randomUUID().toString().substring(0, 8);
        Instant startedAt = Instant.now();

        ConsumptionJobRecord record = new ConsumptionJobRecord(
                jobId,
                request.getDatasetId().trim(),
                request.getAccessRequestId().trim(),
                request.getMode().trim().toUpperCase(),
                startedAt
        );
        jobs.put(jobId, record);

        // Resolve asynchronously to decouple API response from fetching process
        CompletableFuture.runAsync(() -> resolveJob(record));

        return new ConsumptionJobCreatedResponse(jobId, ConsumptionJobStatus.RUNNING.name(), startedAt.toString());
    }

    public ConsumptionJobStatusResponse getConsumptionJob(String jobId) {
        ConsumptionJobRecord record = jobs.get(jobId);
        if (record == null) {
            throw new ConsumerApiException(ConsumerErrorCode.NOT_FOUND, "consumption job not found");
        }
        return new ConsumptionJobStatusResponse(
                record.getJobId(),
                record.getStatus().name(),
                record.getDatasetId(),
                record.getConsumerId(),
                record.getConsumerDid(),
                record.getReceiverDid(),
                record.getPurpose(),
                record.getConsentStatus(),
                record.getDecisionReason(),
                record.getValidFrom(),
                record.getValidTo(),
                record.getRecordsProcessed(),
                record.getFinishedAt() == null ? null : record.getFinishedAt().toString()
        );
    }

    public List<Map<String, Object>> listConsumptionJobs(String patientIdFilter, boolean summaryOnly) {
        List<Map<String, Object>> out = new ArrayList<>();
        for (ConsumptionJobRecord record : jobs.values()) {
            String datasetId = record.getDatasetId();
            // Derive a patientId fallback from datasetId when not explicitly available
            String patientId = datasetId;
            if (patientIdFilter != null && !patientId.toLowerCase().contains(patientIdFilter.toLowerCase())) {
                continue;
            }
            java.util.Map<String, Object> m = new java.util.HashMap<>();
            m.put("id", record.getJobId());
            m.put("patientId", patientId);
            m.put("datasetId", datasetId);
            m.put("status", record.getStatus().name());
            m.put("consumerId", record.getConsumerId());
            m.put("consumerDid", record.getConsumerDid());
            m.put("receiverDid", record.getReceiverDid());
            m.put("purpose", record.getPurpose());
            m.put("consentStatus", record.getConsentStatus());
            m.put("decisionReason", record.getDecisionReason());
            m.put("validFrom", record.getValidFrom());
            m.put("validTo", record.getValidTo());
            m.put("consumedAt", record.getFinishedAt() != null ? record.getFinishedAt().toString() : record.getStartedAt().toString());
            if (!summaryOnly) {
                m.put("measurements", jobMeasurements.getOrDefault(record.getJobId(), new java.util.ArrayList<>()));
            }
            m.put("metadata", java.util.Collections.singletonMap("xRequestId", ""));
            out.add(m);
        }
        return out;
    }

    private void resolveJob(ConsumptionJobRecord record) {
        try {
            log.info("Resolving job {} for dataset {} (accessRequest={})", record.getJobId(), record.getDatasetId(), record.getAccessRequestId());
            AccessRequestStatusResponse access = trustAccessClient.getAccessRequestStatus(record.getAccessRequestId());
            log.info("Access response for {}: status={}, datasetId={}", record.getAccessRequestId(), access.status(), access.datasetId());
            boolean approved = "APPROVED".equals(access.status());
            boolean datasetMatches = record.getDatasetId().equals(access.datasetId());
            Instant finishedAt = Instant.now();
            if (approved && datasetMatches) {
                record.applyConsentContext(access);
                // Try to fetch dataset payload from provider and extract simple measurements for demo
                try {
                JsonNode payload = fetchProviderPayload(record);
                    List<Map<String, Object>> measurements = extractMeasurementsFromPayload(payload);
                    log.info("Job {} extracted {} measurements", record.getJobId(), measurements.size());
                    jobMeasurements.put(record.getJobId(), measurements);
                    record.completeSuccess(measurements.size(), finishedAt);
                } catch (Exception e) {
                    log.warn("Job {}: fetch/extract failed: {}", record.getJobId(), e.toString());
                    // If dataset fetch/extract fails, still mark success but zero measurements
                    record.completeSuccess(0, finishedAt);
                }
            } else {
                log.warn("Job {} not approved or dataset mismatch (approved={},datasetMatches={})", record.getJobId(), approved, datasetMatches);
                record.completeFailure(finishedAt);
            }
        } catch (Exception ex) {
            log.error("resolveJob exception for {}: {}", record.getJobId(), ex.toString());
            // If trust service is unavailable or the request is not found, mark job as failed but do not propagate exception
            record.completeFailure(Instant.now());
        }
    }

    protected JsonNode fetchProviderPayload(ConsumptionJobRecord record) throws Exception {
        String urlStr = providerBaseUrl + "/api/v1/datasets/" + record.getDatasetId() + "/raw";
        log.info("Attempting fetch from {}", urlStr);

        return restClient.get()
                .uri(urlStr)
                .headers(headers -> {
                    if (record.getConsumerDid() != null) headers.set("X-Consumer-Did", record.getConsumerDid());
                    if (record.getReceiverDid() != null) headers.set("X-Receiver-Did", record.getReceiverDid());
                    if (record.getPurpose() != null) headers.set("X-Purpose", record.getPurpose());
                    if (record.getValidFrom() != null) headers.set("X-Consent-From", record.getValidFrom());
                    if (record.getValidTo() != null) headers.set("X-Consent-To", record.getValidTo());
                    if (record.getAccessRequestId() != null) headers.set("X-Access-Request-Id", record.getAccessRequestId());
                })
                .retrieve()
                .body(JsonNode.class);
    }

    private List<Map<String, Object>> extractMeasurementsFromPayload(JsonNode payload) {
        List<Map<String, Object>> out = new ArrayList<>();
        if (payload == null || !payload.has("resourceType")) return out;

        List<JsonNode> observations = new ArrayList<>();
        if ("Observation".equals(payload.path("resourceType").asText())) {
            observations.add(payload);
        } else if (payload.has("entry")) {
            for (JsonNode entry : payload.path("entry")) {
                JsonNode res = entry.path("resource");
                if ("Observation".equals(res.path("resourceType").asText())) {
                    observations.add(res);
                }
            }
        }

        int obsFound = 0;
        for (JsonNode res : observations) {
            obsFound++;
            String timestamp = res.has("effectiveDateTime") ? res.path("effectiveDateTime").asText() : res.path("issued").asText("");
            String code = "";
            JsonNode coding = res.path("code").path("coding");
            if (coding.isArray() && coding.size() > 0) {
                code = coding.get(0).path("code").asText();
            }
            String type = code.equals("85354-9") ? "blood-pressure" : code.equals("8867-4") ? "heart-rate" : "observation";
            String valueStr = "";
            String unit = "";
            if ("85354-9".equals(code)) {
                Integer sys = null, dia = null;
                for (JsonNode comp : res.path("component")) {
                    String ccode = comp.path("code").path("coding").get(0).path("code").asText("");
                    if ("8480-6".equals(ccode) && comp.path("valueQuantity").has("value")) sys = comp.path("valueQuantity").path("value").asInt();
                    if ("8462-4".equals(ccode) && comp.path("valueQuantity").has("value")) dia = comp.path("valueQuantity").path("value").asInt();
                    if (unit.isEmpty()) unit = comp.path("valueQuantity").path("unit").asText("");
                }
                if (sys != null && dia != null) valueStr = String.format("%d/%d %s", sys, dia, unit != null ? unit : "mmHg");
            } else if (res.has("valueQuantity")) {
                double v = res.path("valueQuantity").path("value").asDouble();
                unit = res.path("valueQuantity").path("unit").asText("");
                if (v % 1 == 0) valueStr = String.format("%d %s", (int) v, unit);
                else valueStr = String.format("%s %s", v, unit);
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> m = objectMapper.convertValue(res, Map.class);
            m.put("timestamp", timestamp);
            m.put("type", type);
            m.put("value", valueStr);
            m.put("unit", unit);
            m.put("xRequestId", "");
            out.add(m);
        }
        log.info("extractMeasurementsFromPayload: obsFound={}, measurements={}", obsFound, out.size());
        return out;
    }

    private void validateCreateRequest(CreateConsumptionJobRequest request) {
        if (request == null) {
            throw new ConsumerApiException(ConsumerErrorCode.VALIDATION_ERROR, "request body is required");
        }
        List<ConsumerValidationIssue> issues = new ArrayList<>();
        if (request.getDatasetId() == null || request.getDatasetId().isBlank()) {
            issues.add(new ConsumerValidationIssue("datasetId", "required"));
        }
        if (request.getAccessRequestId() == null || request.getAccessRequestId().isBlank()) {
            issues.add(new ConsumerValidationIssue("accessRequestId", "required"));
        }
        if (request.getMode() == null || request.getMode().isBlank()) {
            issues.add(new ConsumerValidationIssue("mode", "required"));
        } else if (!"DOWNLOAD".equalsIgnoreCase(request.getMode())) {
            issues.add(new ConsumerValidationIssue("mode", "must be DOWNLOAD"));
        }
        if (!issues.isEmpty()) {
            throw new ConsumerApiException(ConsumerErrorCode.VALIDATION_ERROR, "Invalid consumption job request", issues);
        }
    }
}
