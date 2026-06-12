package com.gaiahealth.trust.api;

import com.gaiahealth.trust.domain.TrustApiException;
import com.gaiahealth.trust.domain.TrustErrorCode;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@RestControllerAdvice(basePackages = "com.gaiahealth.trust.api")
public class TrustExceptionHandler {

    @ExceptionHandler(TrustApiException.class)
    public ResponseEntity<TrustErrorResponse> handleTrustException(TrustApiException ex, HttpServletRequest request) {
        TrustErrorResponse body = new TrustErrorResponse(
                Instant.now().toString(),
                requestId(request),
                ex.code().name(),
                ex.getMessage(),
                ex.details().stream().map(d -> new TrustErrorDetailResponse(d.field(), d.issue())).toList()
        );
        return ResponseEntity.status(mapStatus(ex.code())).body(body);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<TrustErrorResponse> handleUnreadable(HttpMessageNotReadableException ex, HttpServletRequest request) {
        TrustErrorResponse body = new TrustErrorResponse(
                Instant.now().toString(),
                requestId(request),
                TrustErrorCode.VALIDATION_ERROR.name(),
                "Malformed JSON request",
                List.of()
        );
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<TrustErrorResponse> handleGeneric(Exception ex, HttpServletRequest request) {
        TrustErrorResponse body = new TrustErrorResponse(
                Instant.now().toString(),
                requestId(request),
                TrustErrorCode.INTERNAL_ERROR.name(),
                "Unexpected error",
                List.of()
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
    }

    private HttpStatus mapStatus(TrustErrorCode code) {
        return switch (code) {
            case VALIDATION_ERROR -> HttpStatus.BAD_REQUEST;
            case NOT_FOUND -> HttpStatus.NOT_FOUND;
            case INTERNAL_ERROR -> HttpStatus.INTERNAL_SERVER_ERROR;
        };
    }

    private String requestId(HttpServletRequest request) {
        String fromHeader = request == null ? null : request.getHeader("X-Request-Id");
        return (fromHeader == null || fromHeader.isBlank()) ? UUID.randomUUID().toString() : fromHeader;
    }
}