package com.gaiahealth.provider.api;

import com.gaiahealth.provider.domain.ProviderApiException;
import com.gaiahealth.provider.domain.ProviderErrorCode;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@RestControllerAdvice(basePackages = "com.gaiahealth.provider.api")
public class ProviderExceptionHandler {

    @ExceptionHandler(ProviderApiException.class)
    public ResponseEntity<ErrorResponse> handleProviderException(ProviderApiException ex, HttpServletRequest request) {
        HttpStatus status = mapStatus(ex.code());
        ErrorResponse response = new ErrorResponse(
                Instant.now().toString(),
                requestId(request),
                ex.code().name(),
                ex.getMessage(),
                ex.details().stream().map(d -> new ErrorDetailResponse(d.field(), d.issue())).toList()
        );
        return ResponseEntity.status(status).body(response);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleUnreadable(HttpMessageNotReadableException ex, HttpServletRequest request) {
        ErrorResponse response = new ErrorResponse(
                Instant.now().toString(),
                requestId(request),
                ProviderErrorCode.VALIDATION_ERROR.name(),
                "Malformed JSON request",
                List.of()
        );
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneric(Exception ex, HttpServletRequest request) {
        ErrorResponse response = new ErrorResponse(
                Instant.now().toString(),
                requestId(request),
                ProviderErrorCode.INTERNAL_ERROR.name(),
                "Unexpected error",
                List.of()
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }

    private HttpStatus mapStatus(ProviderErrorCode code) {
        return switch (code) {
            case VALIDATION_ERROR -> HttpStatus.BAD_REQUEST;
            case FHIR_VALIDATION_ERROR -> HttpStatus.UNPROCESSABLE_ENTITY;
            case CONFLICT -> HttpStatus.CONFLICT;
            case NOT_FOUND -> HttpStatus.NOT_FOUND;
            case INTERNAL_ERROR -> HttpStatus.INTERNAL_SERVER_ERROR;
        };
    }

    private String requestId(HttpServletRequest request) {
        String fromHeader = request == null ? null : request.getHeader("X-Request-Id");
        return (fromHeader == null || fromHeader.isBlank()) ? UUID.randomUUID().toString() : fromHeader;
    }
}