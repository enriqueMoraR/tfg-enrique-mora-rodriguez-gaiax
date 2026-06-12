package com.gaiahealth.provider.domain.fhir;

import com.gaiahealth.provider.domain.FhirValidationService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Service
public class FhirObservationService {
    private final FhirObservationRepository repository;
    private final FhirValidationService validationService;
    private final ObjectMapper objectMapper;

    public FhirObservationService(
            FhirObservationRepository repository,
            FhirValidationService validationService,
            ObjectMapper objectMapper
    ) {
        this.repository = repository;
        this.validationService = validationService;
        this.objectMapper = objectMapper;
    }

    public JsonNode ingest(JsonNode body, String xRequestId) {
        if (body == null || body.isNull()) {
            throw new IllegalArgumentException("FHIR payload is required");
        }

        String resourceType = body.path("resourceType").asText("");
        List<JsonNode> stored = new ArrayList<>();

        if ("Bundle".equals(resourceType)) {
            validationService.validateBundle(null, body);
            for (JsonNode entry : body.path("entry")) {
                JsonNode resource = entry.path("resource");
                if (resource.isMissingNode() || resource.isNull()) {
                    continue;
                }
                stored.addAll(storeSingleResource(resource, xRequestId));
            }
            return buildBundle(stored, "collection");
        }

        if (!"Observation".equals(resourceType)) {
            throw new IllegalArgumentException("Only Observation or Bundle payloads are supported");
        }

        validationService.validateBundle(null, body);
        stored.addAll(storeSingleResource(body, xRequestId));
        return buildBundle(stored, "collection");
    }

    public JsonNode listObservations(String patientRef, int count) {
        List<JsonNode> observations = repository.listObservations(patientRef, count);
        return buildBundle(observations, "searchset");
    }

    public JsonNode listPatients(int count) {
        List<JsonNode> patients = repository.listPatients(count);
        return buildBundle(patients, "searchset");
    }

    private List<JsonNode> storeSingleResource(JsonNode resource, String xRequestId) {
        return repository.storeResource(resource, xRequestId);
    }

    private JsonNode buildBundle(List<JsonNode> resources, String bundleType) {
        ObjectNode bundle = objectMapper.createObjectNode();
        bundle.put("resourceType", "Bundle");
        bundle.put("type", bundleType);
        bundle.put("timestamp", Instant.now().toString());
        bundle.put("total", resources.size());
        ArrayNode entries = bundle.putArray("entry");
        for (JsonNode resource : resources) {
            ObjectNode entry = entries.addObject();
            if (resource.hasNonNull("id")) {
                entry.put("fullUrl", resource.path("resourceType").asText("") + "/" + resource.path("id").asText());
            }
            entry.set("resource", resource);
            ObjectNode search = entry.putObject("search");
            search.put("mode", "match");
        }
        return bundle;
    }
}
