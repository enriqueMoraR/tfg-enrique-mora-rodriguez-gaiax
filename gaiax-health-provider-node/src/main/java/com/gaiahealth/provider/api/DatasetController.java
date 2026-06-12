package com.gaiahealth.provider.api;

import com.gaiahealth.provider.application.DatasetService;
import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/datasets")
public class DatasetController {
    private final DatasetService datasetService;

    public DatasetController(DatasetService datasetService) {
        this.datasetService = datasetService;
    }

    @PostMapping("/fhir")
    public ResponseEntity<DatasetResponse> createDataset(@RequestBody JsonNode body) {
        CreateDatasetRequest request = toCreateRequest(body);
        DatasetResponse response = datasetService.createDataset(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping
    public DatasetListResponse listDatasets(
            @RequestParam(required = false) String clinicalCase,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size
    ) {
        return datasetService.listDatasets(clinicalCase, status, page, size);
    }

    @GetMapping("/{id}/raw")
    public JsonNode getDatasetPayload(@PathVariable("id") String id) {
        return datasetService.getDatasetPayload(id);
    }

    private CreateDatasetRequest toCreateRequest(JsonNode body) {
        DatasetMetadata metadata = null;
        JsonNode metadataNode = body.path("metadata");
        if (!metadataNode.isMissingNode() && !metadataNode.isNull()) {
            metadata = new DatasetMetadata();
            metadata.setOwner(textOrNull(metadataNode.path("owner")));
            metadata.setPurpose(textOrNull(metadataNode.path("purpose")));
            metadata.setJurisdiction(textOrNull(metadataNode.path("jurisdiction")));
            metadata.setPolicyUri(textOrNull(metadataNode.path("policyUri")));
            metadata.setReceiverDid(textOrNull(metadataNode.path("receiverDid")));
            if (metadataNode.path("retentionDays").canConvertToInt()) {
                metadata.setRetentionDays(metadataNode.path("retentionDays").asInt());
            }
            metadata.setValidFrom(textOrNull(metadataNode.path("validFrom")));
            metadata.setValidTo(textOrNull(metadataNode.path("validTo")));
            if (metadataNode.path("tags").isArray()) {
                java.util.List<String> tags = new java.util.ArrayList<>();
                for (JsonNode tagNode : metadataNode.path("tags")) {
                    if (tagNode.isTextual()) {
                        tags.add(tagNode.asText());
                    }
                }
                metadata.setTags(tags);
            }
        }

        CreateDatasetRequest request = new CreateDatasetRequest();
        request.setDatasetId(textOrNull(body.path("datasetId")));
        request.setDatasetType(textOrNull(body.path("datasetType")));
        request.setClinicalCase(textOrNull(body.path("clinicalCase")));
        request.setPayload(body.path("payload"));
        request.setMetadata(metadata);
        return request;
    }

    private String textOrNull(JsonNode node) {
        if (node == null || node.isNull() || node.isMissingNode()) {
            return null;
        }
        return node.asText();
    }
}
