package com.gaiahealth.provider.api;

import java.util.List;

public record DatasetListResponse(
        List<DatasetItemResponse> items,
        int page,
        int size,
        long total
) {
}
