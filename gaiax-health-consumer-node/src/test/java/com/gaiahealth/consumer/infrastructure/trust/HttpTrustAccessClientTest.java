package com.gaiahealth.consumer.infrastructure.trust;

import com.gaiahealth.consumer.domain.ConsumerApiException;
import com.gaiahealth.consumer.domain.ConsumerErrorCode;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withStatus;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

class HttpTrustAccessClientTest {

    private MockRestServiceServer server;
    private RestClient.Builder restClientBuilder;

    @AfterEach
    void tearDown() {
        if (server != null) {
            server.verify();
        }
    }

    @Test
    void getAccessRequestStatusParsesSuccessfulResponse() throws Exception {
        prepareServer("ar-1", """
                {
                  "requestId": "ar-1",
                  "datasetId": "dataset-1",
                  "consumerId": "consumer-1",
                  "status": "APPROVED",
                  "decisionReason": "policy ok",
                  "decidedAt": "2026-06-10T00:00:00Z"
                }
                """, 200);

        HttpTrustAccessClient client = new HttpTrustAccessClient(restClientBuilder.build());

        AccessRequestStatusResponse response = client.getAccessRequestStatus("ar-1");

        assertEquals("ar-1", response.requestId());
        assertEquals("dataset-1", response.datasetId());
        assertEquals("APPROVED", response.status());
    }

    @Test
    void getAccessRequestStatusMaps404ToNotFound() throws Exception {
        prepareServer("missing", "", 404);

        HttpTrustAccessClient client = new HttpTrustAccessClient(restClientBuilder.build());

        ConsumerApiException ex = assertThrows(ConsumerApiException.class, () -> client.getAccessRequestStatus("missing"));

        assertEquals(ConsumerErrorCode.NOT_FOUND, ex.code());
        assertEquals("access request not found", ex.getMessage());
    }

    @Test
    void getAccessRequestStatusMaps500ToInternalError() throws Exception {
        prepareServer("ar-1", "{\"error\":\"boom\"}", 500);

        HttpTrustAccessClient client = new HttpTrustAccessClient(restClientBuilder.build());

        ConsumerApiException ex = assertThrows(ConsumerApiException.class, () -> client.getAccessRequestStatus("ar-1"));

        assertEquals(ConsumerErrorCode.INTERNAL_ERROR, ex.code());
        assertEquals("trust service error: HTTP 500", ex.getMessage());
    }

    @Test
    void getAccessRequestStatusMapsConnectionFailureToUnavailable() {
        HttpTrustAccessClient client = new HttpTrustAccessClient("http://127.0.0.1:65534");

        ConsumerApiException ex = assertThrows(ConsumerApiException.class, () -> client.getAccessRequestStatus("ar-1"));

        assertEquals(ConsumerErrorCode.INTERNAL_ERROR, ex.code());
        assertEquals("trust service unavailable", ex.getMessage());
    }

    private void prepareServer(String requestId, String body, int status) {
        restClientBuilder = RestClient.builder().baseUrl("http://mock-trust.local");
        server = MockRestServiceServer.bindTo(restClientBuilder).build();
        if (status >= 200 && status < 300) {
            server.expect(requestTo("http://mock-trust.local/api/v1/access-requests/" + requestId))
                    .andRespond(withSuccess(body, MediaType.APPLICATION_JSON));
        } else {
            server.expect(requestTo("http://mock-trust.local/api/v1/access-requests/" + requestId))
                    .andRespond(withStatus(org.springframework.http.HttpStatus.valueOf(status))
                            .contentType(MediaType.APPLICATION_JSON)
                            .body(body));
        }
    }
}
