package com.gaiahealth.trust.domain;

import java.time.Instant;

public record AuditEvent(
        String eventType,
        String requestId,
        String details,
        Instant timestamp
) {
}