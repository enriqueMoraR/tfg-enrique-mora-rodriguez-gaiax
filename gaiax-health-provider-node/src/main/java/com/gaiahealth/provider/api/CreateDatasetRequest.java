package com.gaiahealth.provider.api;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreateDatasetRequest {
    private String datasetId;
    private String datasetType;
    private String clinicalCase;
    private JsonNode payload;
    private DatasetMetadata metadata;
}
