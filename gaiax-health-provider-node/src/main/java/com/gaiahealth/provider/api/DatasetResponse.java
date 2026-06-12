package com.gaiahealth.provider.api;

public record DatasetResponse(
        String datasetId,
        String status,
        String publishedAt
) {
}
