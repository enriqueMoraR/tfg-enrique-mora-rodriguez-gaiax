package com.gaiahealth.trust.api;

import com.gaiahealth.trust.application.TrustService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
public class TrustController {
    private final TrustService trustService;

    public TrustController(TrustService trustService) {
        this.trustService = trustService;
    }

    @PostMapping("/access-requests")
    public ResponseEntity<AccessRequestCreatedResponse> createAccessRequest(@RequestBody CreateAccessRequestRequest request) {
        AccessRequestCreatedResponse response = trustService.createAccessRequest(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/access-requests/{id}")
    public AccessRequestStatusResponse getAccessRequest(@PathVariable("id") String id) {
        return trustService.getAccessRequestStatus(id);
    }

    @PostMapping("/policies/validate")
    public PolicyValidationResponse validatePolicy(@RequestBody PolicyValidationRequest request) {
        return trustService.validatePolicy(request);
    }
}