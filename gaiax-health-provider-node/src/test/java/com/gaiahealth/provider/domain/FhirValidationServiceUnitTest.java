package com.gaiahealth.provider.domain;

import com.gaiahealth.provider.support.FhirTestDataLoader;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.catchThrowableOfType;

class FhirValidationServiceUnitTest {

    private FhirValidationService fhirValidationService;

    @BeforeEach
    void setUp() {
        this.fhirValidationService = new FhirValidationService();
    }

    @Test
    void shouldValidateBloodPressureBundleSample() {
        assertThatCode(() -> fhirValidationService.validateBundle(
                ClinicalCase.BLOOD_PRESSURE,
                FhirTestDataLoader.bundleSample()
        )).doesNotThrowAnyException();
    }

    @Test
    void shouldValidateFirstBundleFromLargeDataset() {
        assertThat(FhirTestDataLoader.bundles10000Count()).isEqualTo(10000);
        assertThatCode(() -> fhirValidationService.validateBundle(
                ClinicalCase.BLOOD_PRESSURE,
                FhirTestDataLoader.firstBundleFromBundles10000()
        )).doesNotThrowAnyException();
    }

    @Test
    void shouldValidateStandaloneObservationWithSovereigntyMetadata() {
        assertThatCode(() -> fhirValidationService.validateBundle(
                ClinicalCase.BLOOD_PRESSURE,
                FhirTestDataLoader.observationReal2026()
        )).doesNotThrowAnyException();
    }

    @Test
    void shouldValidateBundleWithoutClinicalCaseAndWithoutThrowing() {
        assertThatCode(() -> fhirValidationService.validateBundle(
                null,
                FhirTestDataLoader.bundleSample()
        )).doesNotThrowAnyException();
    }

    @Test
    void shouldRejectPayloadWhenResourceTypeIsUnsupported() {
        ObjectNode notBundle = (ObjectNode) FhirTestDataLoader.bundleSample();
        notBundle.put("resourceType", "Patient");

        ProviderApiException exception = catchThrowableOfType(ProviderApiException.class,
                () -> fhirValidationService.validateBundle(ClinicalCase.BLOOD_PRESSURE, notBundle)
        );

        assertThat(exception).isNotNull();
        assertThat(exception.code()).isEqualTo(ProviderErrorCode.FHIR_VALIDATION_ERROR);
        assertThat(exception.details()).anySatisfy(issue ->
                assertThat(issue.field()).isEqualTo("payload.resourceType")
        );
    }

    @Test
    void shouldRejectObservationWithoutSovereigntyMetadata() {
        ObjectNode observation = (ObjectNode) FhirTestDataLoader.observationReal2026();
        observation.remove("meta");

        ProviderApiException exception = catchThrowableOfType(ProviderApiException.class,
                () -> fhirValidationService.validateBundle(ClinicalCase.BLOOD_PRESSURE, observation)
        );

        assertThat(exception).isNotNull();
        assertThat(exception.code()).isEqualTo(ProviderErrorCode.FHIR_VALIDATION_ERROR);
        assertThat(exception.details()).anySatisfy(issue ->
                assertThat(issue.field()).isEqualTo("payload.meta.profile")
        );
    }

    @Test
    void shouldRejectBundleWithoutDiastolicComponent() {
        ObjectNode bundle = (ObjectNode) FhirTestDataLoader.bundleSample();
        ObjectNode observation = (ObjectNode) bundle.path("entry").path(2).path("resource");
        ArrayNode components = (ArrayNode) observation.path("component");

        for (int i = components.size() - 1; i >= 0; i--) {
            JsonNode component = components.path(i);
            String code = component.path("code").path("coding").path(0).path("code").asText();
            if ("8462-4".equals(code)) {
                components.remove(i);
            }
        }

        ProviderApiException exception = catchThrowableOfType(ProviderApiException.class,
                () -> fhirValidationService.validateBundle(ClinicalCase.BLOOD_PRESSURE, bundle)
        );

        assertThat(exception).isNotNull();
        assertThat(exception.code()).isEqualTo(ProviderErrorCode.FHIR_VALIDATION_ERROR);
        assertThat(exception.details()).anySatisfy(issue ->
                assertThat(issue.issue()).contains("diastolic")
        );
    }
}
