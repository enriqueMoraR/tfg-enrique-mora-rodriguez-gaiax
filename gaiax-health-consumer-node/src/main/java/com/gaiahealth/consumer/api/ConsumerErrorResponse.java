package com.gaiahealth.consumer.api;

import java.util.List;

public record ConsumerErrorResponse(
        String timestamp,
        String requestId,
        String code,
        String message,
        List<ConsumerErrorDetailResponse> details
) {
}