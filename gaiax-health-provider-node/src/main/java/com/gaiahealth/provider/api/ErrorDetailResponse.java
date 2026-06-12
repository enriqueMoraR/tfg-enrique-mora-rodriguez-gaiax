package com.gaiahealth.provider.api;

public record ErrorDetailResponse(
        String field,
        String issue
) {
}
