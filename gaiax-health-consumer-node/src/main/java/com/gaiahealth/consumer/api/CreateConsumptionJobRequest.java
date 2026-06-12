package com.gaiahealth.consumer.api;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreateConsumptionJobRequest {
    private String datasetId;
    private String accessRequestId;
    private String mode;
}
