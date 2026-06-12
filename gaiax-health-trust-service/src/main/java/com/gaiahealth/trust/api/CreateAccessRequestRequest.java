package com.gaiahealth.trust.api;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class CreateAccessRequestRequest {
    private String datasetId;
    private String consumerId;
    private String consumerDid;
    private String receiverDid;
    private String purpose;
    private List<String> requestedScopes;
    private String validFrom;
    private String validTo;

    public CreateAccessRequestRequest(String datasetId, String consumerId, String purpose, List<String> requestedScopes) {
        this.datasetId = datasetId;
        this.consumerId = consumerId;
        this.purpose = purpose;
        this.requestedScopes = requestedScopes;
    }

    public CreateAccessRequestRequest(
            String datasetId,
            String consumerId,
            String consumerDid,
            String receiverDid,
            String purpose,
            List<String> requestedScopes,
            String validFrom,
            String validTo
    ) {
        this.datasetId = datasetId;
        this.consumerId = consumerId;
        this.consumerDid = consumerDid;
        this.receiverDid = receiverDid;
        this.purpose = purpose;
        this.requestedScopes = requestedScopes;
        this.validFrom = validFrom;
        this.validTo = validTo;
    }
}
