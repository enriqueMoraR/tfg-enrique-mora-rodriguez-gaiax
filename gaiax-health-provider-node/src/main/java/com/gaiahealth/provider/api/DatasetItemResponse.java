package com.gaiahealth.provider.api;

public record DatasetItemResponse(
        String datasetId,
        String clinicalCase,
        String status,
        String publishedAt
) {
}
