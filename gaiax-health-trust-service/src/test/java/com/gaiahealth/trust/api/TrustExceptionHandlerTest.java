package com.gaiahealth.trust.api;

import com.gaiahealth.trust.domain.TrustApiException;
import com.gaiahealth.trust.domain.TrustErrorCode;
import com.gaiahealth.trust.domain.TrustValidationIssue;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpInputMessage;
import org.springframework.http.HttpStatus;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.mock.web.MockHttpServletRequest;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class TrustExceptionHandlerTest {

    private final TrustExceptionHandler handler = new TrustExceptionHandler();

    @Test
    void handleTrustExceptionMapsValidationErrorsToBadRequest() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Request-Id", "req-123");
        TrustApiException exception = new TrustApiException(
                TrustErrorCode.VALIDATION_ERROR,
                "Invalid access request",
                List.of(new TrustValidationIssue("datasetId", "required"))
        );

        var response = handler.handleTrustException(exception, request);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertEquals("req-123", response.getBody().requestId());
        assertEquals("VALIDATION_ERROR", response.getBody().code());
        assertEquals("Invalid access request", response.getBody().message());
        assertEquals(1, response.getBody().details().size());
        assertEquals("datasetId", response.getBody().details().get(0).field());
    }

    @Test
    void handleTrustExceptionMapsNotFoundTo404() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Request-Id", "req-404");
        TrustApiException exception = new TrustApiException(TrustErrorCode.NOT_FOUND, "access request not found");

        var response = handler.handleTrustException(exception, request);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertEquals("req-404", response.getBody().requestId());
        assertEquals("NOT_FOUND", response.getBody().code());
    }

    @Test
    void handleUnreadableCreatesValidationErrorResponse() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        HttpMessageNotReadableException exception = new HttpMessageNotReadableException("bad json", (HttpInputMessage) null);

        var response = handler.handleUnreadable(exception, request);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertEquals("VALIDATION_ERROR", response.getBody().code());
        assertEquals("Malformed JSON request", response.getBody().message());
        assertFalse(response.getBody().requestId().isBlank());
        assertTrue(response.getBody().details().isEmpty());
    }

    @Test
    void handleGenericCreatesInternalErrorResponse() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Request-Id", "req-generic");

        var response = handler.handleGeneric(new RuntimeException("boom"), request);

        assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        assertEquals("req-generic", response.getBody().requestId());
        assertEquals("INTERNAL_ERROR", response.getBody().code());
        assertEquals("Unexpected error", response.getBody().message());
        assertNotNull(response.getBody().timestamp());
        assertTrue(response.getBody().details().isEmpty());
    }
}
