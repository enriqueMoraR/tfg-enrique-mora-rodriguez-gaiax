package com.gaiahealth.consumer.api;

import com.gaiahealth.consumer.application.ConsumerService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/consumption-jobs")
public class ConsumerController {
    private final ConsumerService consumerService;

    public ConsumerController(ConsumerService consumerService) {
        this.consumerService = consumerService;
    }

    @PostMapping
    public ResponseEntity<ConsumptionJobCreatedResponse> createJob(@RequestBody CreateConsumptionJobRequest request) {
        ConsumptionJobCreatedResponse response = consumerService.createConsumptionJob(request);
        return ResponseEntity.status(HttpStatus.ACCEPTED).body(response);
    }

    @GetMapping
    public List<Map<String, Object>> listJobs(
            @RequestParam(value = "patientId", required = false) String patientId,
            @RequestParam(value = "summary", defaultValue = "false") boolean summary
    ) {
        return consumerService.listConsumptionJobs(patientId, summary);
    }

    @GetMapping("/{id}")
    public ConsumptionJobStatusResponse getJob(@PathVariable("id") String id) {
        return consumerService.getConsumptionJob(id);
    }
}
