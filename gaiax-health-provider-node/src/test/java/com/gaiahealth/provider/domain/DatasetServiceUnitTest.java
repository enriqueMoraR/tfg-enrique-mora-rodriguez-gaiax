package com.gaiahealth.provider.domain;

import com.gaiahealth.provider.application.DatasetService;
import com.gaiahealth.provider.api.CreateDatasetRequest;
import com.gaiahealth.provider.api.DatasetListResponse;
import com.gaiahealth.provider.api.DatasetMetadata;
import com.gaiahealth.provider.api.DatasetResponse;
import com.gaiahealth.provider.support.FhirTestDataLoader;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.catchThrowableOfType;

class DatasetServiceUnitTest {

    private DatasetService datasetService;

    @BeforeEach
    void setUp() {
        this.datasetService = new DatasetService(new FhirValidationService());
    }

    @Test
    void shouldCreateDatasetFromLargeCollectionFixture() {
        assertThat(FhirTestDataLoader.collection10000ObservationCount()).isEqualTo(10000);

        DatasetResponse response = datasetService.createDataset(createRequest(
                "ds-bp-large",
                "blood-pressure",
                "FHIR_BUNDLE",
                FhirTestDataLoader.collection10000()
        ));

        assertThat(response.datasetId()).isEqualTo("ds-bp-large");
        assertThat(response.status()).isEqualTo("PUBLISHED");
    }

    @Test
    void shouldRejectDuplicateDatasetId() {
        CreateDatasetRequest request = createRequest("ds-bp-dup", "blood-pressure", "FHIR_BUNDLE", FhirTestDataLoader.bundleSample());
        datasetService.createDataset(request);

        ProviderApiException exception = catchThrowableOfType(ProviderApiException.class,
                () -> datasetService.createDataset(createRequest("ds-bp-dup", "blood-pressure", "FHIR_BUNDLE", FhirTestDataLoader.bundleSample()))
        );

        assertThat(exception).isNotNull();
        assertThat(exception.code()).isEqualTo(ProviderErrorCode.CONFLICT);
    }

    @Test
    void shouldRejectDatasetWithoutSovereigntyMetadata() {
        CreateDatasetRequest request = new CreateDatasetRequest(
                "ds-bp-invalid-metadata",
                "FHIR_BUNDLE",
                "blood-pressure",
                FhirTestDataLoader.bundleSample(),
                new DatasetMetadata(
                        "provider-a",
                        "research",
                        "",
                        "",
                        "",
                        0,
                        "2026-12-31T23:59:59Z",
                        "2026-01-01T00:00:00Z",
                        List.of("fhir")
                )
        );

        ProviderApiException exception = catchThrowableOfType(ProviderApiException.class,
                () -> datasetService.createDataset(request)
        );

        assertThat(exception).isNotNull();
        assertThat(exception.code()).isEqualTo(ProviderErrorCode.VALIDATION_ERROR);
        assertThat(exception.getMessage()).isEqualTo("metadata is invalid");
        assertThat(exception.details()).extracting("field").contains(
                "metadata.jurisdiction",
                "metadata.policyUri",
                "metadata.receiverDid",
                "metadata.retentionDays"
        );
    }

    @Test
    void shouldListDatasetsWithFiltersAndPagination() {
        datasetService.createDataset(createRequest("ds-bp-1", "blood-pressure", "FHIR_BUNDLE", FhirTestDataLoader.bundleSample()));
        datasetService.createDataset(createRequest("ds-bp-2", "blood-pressure", "FHIR_BUNDLE", FhirTestDataLoader.collectionSample()));
        datasetService.createDataset(createRequest("ds-hr-1", "heart-rate", "FHIR_BUNDLE", heartRateBundle()));
        datasetService.createDataset(createRequest("ds-obs-1", "blood-pressure", "FHIR_OBSERVATION", FhirTestDataLoader.observationReal2026()));

        DatasetListResponse bloodPressure = datasetService.listDatasets("blood-pressure", "PUBLISHED", 0, 10);
        assertThat(bloodPressure.total()).isEqualTo(3);
        assertThat(bloodPressure.items()).hasSize(3);
        assertThat(bloodPressure.items()).allSatisfy(item ->
                assertThat(item.clinicalCase()).isEqualTo("blood-pressure")
        );

        DatasetListResponse paged = datasetService.listDatasets(null, null, 1, 2);
        assertThat(paged.total()).isEqualTo(4);
        assertThat(paged.items()).hasSize(2);
    }

    @Test
    void shouldCreateDatasetFromDirectObservationPayload() {
        DatasetResponse response = datasetService.createDataset(createRequest(
                "ds-obs-direct",
                "blood-pressure",
                "FHIR_OBSERVATION",
                FhirTestDataLoader.observationReal2026()
        ));

        assertThat(response.datasetId()).isEqualTo("ds-obs-direct");
        assertThat(response.status()).isEqualTo("PUBLISHED");
    }

    @Test
    void shouldValidatePagingParameters() {
        ProviderApiException negativePage = catchThrowableOfType(ProviderApiException.class,
                () -> datasetService.listDatasets(null, null, -1, 20)
        );
        ProviderApiException invalidSize = catchThrowableOfType(ProviderApiException.class,
                () -> datasetService.listDatasets(null, null, 0, 0)
        );

        assertThat(negativePage).isNotNull();
        assertThat(negativePage.code()).isEqualTo(ProviderErrorCode.VALIDATION_ERROR);
        assertThat(invalidSize).isNotNull();
        assertThat(invalidSize.code()).isEqualTo(ProviderErrorCode.VALIDATION_ERROR);
    }

    private CreateDatasetRequest createRequest(String datasetId, String clinicalCase, String datasetType, JsonNode payload) {
        return new CreateDatasetRequest(
                datasetId,
                datasetType,
                clinicalCase,
                payload,
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
    }

    private JsonNode heartRateBundle() {
        ObjectNode bundle = (ObjectNode) FhirTestDataLoader.bundleSample();
        ObjectNode observation = (ObjectNode) bundle.path("entry").path(2).path("resource");
        ObjectNode coding0 = (ObjectNode) observation.path("code").path("coding").path(0);

        coding0.put("code", "8867-4");
        coding0.put("display", "Heart rate");
        observation.remove("component");

        ObjectNode valueQuantity = observation.putObject("valueQuantity");
        valueQuantity.put("value", 72);
        valueQuantity.put("unit", "beats/minute");
        valueQuantity.put("system", "http://unitsofmeasure.org");
        valueQuantity.put("code", "/min");
        return bundle;
    }
}
