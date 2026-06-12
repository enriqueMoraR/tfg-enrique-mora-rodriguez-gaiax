package com.gaiahealth.provider.domain;

import com.gaiahealth.provider.application.DatasetService;
import com.gaiahealth.provider.api.CreateDatasetRequest;
import com.gaiahealth.provider.api.DatasetListResponse;
import com.gaiahealth.provider.api.DatasetMetadata;
import com.gaiahealth.provider.api.DatasetResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class DatasetServiceSmokeTest {

    private DatasetService datasetService;
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        this.datasetService = new DatasetService(new FhirValidationService());
        this.objectMapper = new ObjectMapper();
    }

    @Test
    void shouldCreateAndListDataset() throws Exception {
        JsonNode bundle = objectMapper.readTree(
                DatasetServiceSmokeTest.class.getResourceAsStream("/fhir/payloads/bundle-sample.json")
        );

        CreateDatasetRequest request = new CreateDatasetRequest(
                "ds-bp-0001",
                "FHIR_BUNDLE",
                "blood-pressure",
                bundle,
                new DatasetMetadata(
                        "provider-a",
                        "research",
                        "ES",
                        "https://gaiax-health.example/policies/default",
                        "did:web:consumer.gaiax-health.local",
                        30,
                        "2026-01-01T00:00:00Z",
                        "2026-12-31T23:59:59Z",
                        List.of("fhir")
                )
        );

        DatasetResponse response = datasetService.createDataset(request);
        assertThat(response.datasetId()).isEqualTo("ds-bp-0001");
        assertThat(response.status()).isEqualTo("PUBLISHED");

        DatasetListResponse list = datasetService.listDatasets("blood-pressure", "PUBLISHED", 0, 20);
        assertThat(list.total()).isEqualTo(1);
        assertThat(list.items()).hasSize(1);
        assertThat(list.items().get(0).datasetId()).isEqualTo("ds-bp-0001");
    }
}
