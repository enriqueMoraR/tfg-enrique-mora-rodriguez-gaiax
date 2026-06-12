package com.gaiahealth.provider.api.fhir;

import com.gaiahealth.provider.domain.fhir.FhirObservationService;
import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/fhir")
@CrossOrigin(origins = {
        "http://localhost:3000",
        "http://localhost:4173",
        "http://127.0.0.1:4173"
})
public class FhirObservationController {
    private static final MediaType FHIR_JSON = MediaType.parseMediaType("application/fhir+json");

    private final FhirObservationService fhirObservationService;

    public FhirObservationController(FhirObservationService fhirObservationService) {
        this.fhirObservationService = fhirObservationService;
    }

    @PostMapping(
            value = {"/Observation", "/Bundle"},
            consumes = {MediaType.APPLICATION_JSON_VALUE, "application/fhir+json"},
            produces = {"application/fhir+json", MediaType.APPLICATION_JSON_VALUE}
    )
    public ResponseEntity<JsonNode> ingest(
            @RequestBody JsonNode body,
            @RequestParam(value = "x-request-id", required = false) String xRequestId
    ) {
        JsonNode response = fhirObservationService.ingest(body, xRequestId);
        return ResponseEntity.status(HttpStatus.CREATED)
                .contentType(FHIR_JSON)
                .header(HttpHeaders.CACHE_CONTROL, "no-store")
                .body(response);
    }

    @GetMapping(value = "/Observation", produces = {"application/fhir+json", MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<JsonNode> listObservations(
            @RequestParam(value = "patient", required = false) String patient,
            @RequestParam(value = "_count", defaultValue = "50") int count
    ) {
        return ResponseEntity.ok()
                .contentType(FHIR_JSON)
                .header(HttpHeaders.CACHE_CONTROL, "no-store")
                .body(fhirObservationService.listObservations(patient, count));
    }

    @GetMapping(value = "/Patient", produces = {"application/fhir+json", MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<JsonNode> listPatients(
            @RequestParam(value = "_count", defaultValue = "50") int count
    ) {
        return ResponseEntity.ok()
                .contentType(FHIR_JSON)
                .header(HttpHeaders.CACHE_CONTROL, "no-store")
                .body(fhirObservationService.listPatients(count));
    }
}
