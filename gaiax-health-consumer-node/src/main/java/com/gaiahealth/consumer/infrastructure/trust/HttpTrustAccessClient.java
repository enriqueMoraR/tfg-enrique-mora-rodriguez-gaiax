package com.gaiahealth.consumer.infrastructure.trust;

import com.gaiahealth.consumer.domain.ConsumerApiException;
import com.gaiahealth.consumer.domain.ConsumerErrorCode;
import com.gaiahealth.consumer.infrastructure.trust.AccessRequestStatusResponse;
import com.gaiahealth.consumer.domain.TrustAccessClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientResponseException;

@Component
public class HttpTrustAccessClient implements TrustAccessClient {
    private final RestClient restClient;

    @Autowired
    public HttpTrustAccessClient(@Value("${gaiax.trust.base-url:http://localhost:8082}") String trustBaseUrl) {
        this(RestClient.builder().baseUrl(trustBaseUrl).build());
    }

    HttpTrustAccessClient(RestClient restClient) {
        this.restClient = restClient;
    }

    @Override
    public AccessRequestStatusResponse getAccessRequestStatus(String requestId) {
        try {
            AccessRequestStatusResponse response = restClient.get()
                    .uri("/api/v1/access-requests/{id}", requestId)
                    .retrieve()
                    .body(AccessRequestStatusResponse.class);
            if (response == null) {
                throw new ConsumerApiException(ConsumerErrorCode.INTERNAL_ERROR, "trust service empty response");
            }
            return response;
        } catch (RestClientResponseException ex) {
            if (ex.getStatusCode().value() == 404) {
                throw new ConsumerApiException(ConsumerErrorCode.NOT_FOUND, "access request not found");
            }
            throw new ConsumerApiException(
                    ConsumerErrorCode.INTERNAL_ERROR,
                    "trust service error: HTTP " + ex.getStatusCode().value()
            );
        } catch (ConsumerApiException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ConsumerApiException(ConsumerErrorCode.INTERNAL_ERROR, "trust service unavailable");
        }
    }
}
