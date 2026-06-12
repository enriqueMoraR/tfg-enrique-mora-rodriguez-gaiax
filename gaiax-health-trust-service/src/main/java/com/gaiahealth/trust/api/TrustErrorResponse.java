package com.gaiahealth.trust.api;

import java.util.List;

public record TrustErrorResponse(
        String timestamp,
        String requestId,
        String code,
        String message,
        List<TrustErrorDetailResponse> details
) {
}