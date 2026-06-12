package com.gaiahealth.trust.api;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class PolicyValidationRequest {
    private String datasetId;
    private String consumerId;
    private String consumerDid;
    private String receiverDid;
    private String purpose;
    private List<String> scopes;
    private String validFrom;
    private String validTo;

    public PolicyValidationRequest(String datasetId, String consumerId, String purpose, List<String> scopes) {
        this.datasetId = datasetId;
        this.consumerId = consumerId;
        this.purpose = purpose;
        this.scopes = scopes;
    }

    public PolicyValidationRequest(
            String datasetId,
            String consumerId,
            String consumerDid,
            String receiverDid,
            String purpose,
            List<String> scopes,
            String validFrom,
            String validTo
    ) {
        this.datasetId = datasetId;
        this.consumerId = consumerId;
        this.consumerDid = consumerDid;
        this.receiverDid = receiverDid;
        this.purpose = purpose;
        this.scopes = scopes;
        this.validFrom = validFrom;
        this.validTo = validTo;
    }
}
