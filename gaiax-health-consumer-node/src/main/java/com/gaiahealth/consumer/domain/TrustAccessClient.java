package com.gaiahealth.consumer.domain;

import com.gaiahealth.consumer.infrastructure.trust.AccessRequestStatusResponse;

public interface TrustAccessClient {
    AccessRequestStatusResponse getAccessRequestStatus(String requestId);
}