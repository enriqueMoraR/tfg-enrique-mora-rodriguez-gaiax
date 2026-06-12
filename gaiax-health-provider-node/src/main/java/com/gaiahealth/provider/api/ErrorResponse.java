package com.gaiahealth.provider.api;

import java.util.List;

public record ErrorResponse(
        String timestamp,
        String requestId,
        String code,
        String message,
        List<ErrorDetailResponse> details
) {
}
