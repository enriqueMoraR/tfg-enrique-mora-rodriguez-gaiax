package com.gaiahealth.consumer.api;

import com.gaiahealth.consumer.domain.ConsumerApiException;
import com.gaiahealth.consumer.domain.ConsumerErrorCode;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@RestControllerAdvice(basePackages = "com.gaiahealth.consumer.api")
public class ConsumerExceptionHandler {

    @ExceptionHandler(ConsumerApiException.class)
    public ResponseEntity<ConsumerErrorResponse> handleConsumerException(ConsumerApiException ex, HttpServletRequest request) {
        ConsumerErrorResponse body = new ConsumerErrorResponse(
                Instant.now().toString(),
                requestId(request),
                ex.code().name(),
                ex.getMessage(),
                ex.details().stream().map(d -> new ConsumerErrorDetailResponse(d.field(), d.issue())).toList()
        );
        return ResponseEntity.status(mapStatus(ex.code())).body(body);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ConsumerErrorResponse> handleUnreadable(HttpMessageNotReadableException ex, HttpServletRequest request) {
        ConsumerErrorResponse body = new ConsumerErrorResponse(
                Instant.now().toString(),
                requestId(request),
                ConsumerErrorCode.VALIDATION_ERROR.name(),
                "Malformed JSON request",
                List.of()
        );
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ConsumerErrorResponse> handleGeneric(Exception ex, HttpServletRequest request) {
        ConsumerErrorResponse body = new ConsumerErrorResponse(
                Instant.now().toString(),
                requestId(request),
                ConsumerErrorCode.INTERNAL_ERROR.name(),
                "Unexpected error",
                List.of()
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
    }

    private HttpStatus mapStatus(ConsumerErrorCode code) {
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