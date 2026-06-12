package com.gaiahealth.provider.api;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DatasetMetadata {
    private String owner;
    private String purpose;
    private String jurisdiction;
    private String policyUri;
    private String receiverDid;
    private Integer retentionDays;
    private String validFrom;
    private String validTo;
    private List<String> tags;
}
