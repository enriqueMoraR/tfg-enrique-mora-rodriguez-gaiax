package com.gaiahealth.provider.domain;

import com.gaiahealth.provider.api.DatasetMetadata;
import com.fasterxml.jackson.databind.JsonNode;

import java.time.Instant;

public record DatasetRecord(
        String datasetId,
        DatasetType datasetType,
        ClinicalCase clinicalCase,
        JsonNode payload,
        DatasetMetadata metadata,
        DatasetStatus status,
        Instant publishedAt
) {
}