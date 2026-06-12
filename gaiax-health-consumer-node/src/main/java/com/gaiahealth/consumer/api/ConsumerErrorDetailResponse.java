package com.gaiahealth.consumer.api;

public record ConsumerErrorDetailResponse(
        String field,
        String issue
) {
}