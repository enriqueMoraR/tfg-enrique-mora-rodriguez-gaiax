package com.gaiahealth.provider.api;

import com.gaiahealth.provider.support.FhirTestDataLoader;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import com.gaiahealth.provider.domain.FhirValidationService;
import com.gaiahealth.provider.domain.fhir.FhirObservationRepository;
import com.gaiahealth.provider.domain.fhir.FhirObservationService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(properties = {
        "spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration,org.springframework.boot.autoconfigure.sql.init.SqlInitializationAutoConfiguration",
        "spring.main.lazy-initialization=true",
        "spring.sql.init.mode=never"
})
@AutoConfigureMockMvc
class ProviderApiFunctionalTest {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    @Autowired
    private MockMvc mockMvc;

    @BeforeEach
    void setUp() {
        // MockMvc is injected by Spring Boot; no manual setup required.
    }

    @Test
    void shouldCreateDatasetAndListItByFilters() throws Exception {
        String datasetId = "ds-api-bp-" + UUID.randomUUID().toString().substring(0, 8);
        String requestBody = createDatasetBody(datasetId, "blood-pressure", "FHIR_BUNDLE", FhirTestDataLoader.bundleSample());

        int createStatus = mockMvc.perform(post("/api/v1/datasets/fhir")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isCreated())
                .andReturn()
                .getResponse()
                .getStatus();
        String createBody = mockMvc.perform(get("/api/v1/datasets")
                        .param("clinicalCase", "blood-pressure")
                        .param("status", "PUBLISHED")
                        .param("page", "0")
                        .param("size", "100"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse()
                .getContentAsString();
        JsonNode listJson = OBJECT_MAPPER.readTree(createBody);
        assertThat(createStatus).isEqualTo(201);
        assertThat(listJson.path("items").isArray()).isTrue();
        boolean datasetFound = false;
        for (JsonNode item : listJson.path("items")) {
            if (datasetId.equals(item.path("datasetId").asText())) {
                datasetFound = true;
                break;
            }
        }
        assertThat(datasetFound).isTrue();
    }

    @Test
    void shouldReturnFhirValidationErrorForInvalidBundle() throws Exception {
        String datasetId = "ds-api-invalid-" + UUID.randomUUID().toString().substring(0, 8);
        ObjectNode invalidBundle = (ObjectNode) FhirTestDataLoader.bundleSample();
        invalidBundle.put("resourceType", "Patient");

        String body = mockMvc.perform(post("/api/v1/datasets/fhir")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(createDatasetBody(datasetId, "blood-pressure", "FHIR_BUNDLE", invalidBundle)))
                .andExpect(status().isUnprocessableEntity())
                .andReturn()
                .getResponse()
                .getContentAsString();
        JsonNode json = OBJECT_MAPPER.readTree(body);
        assertThat(json.path("code").asText()).isEqualTo("FHIR_VALIDATION_ERROR");
    }

    @Test
    void shouldReturnConflictForDuplicatedDatasetId() throws Exception {
        String datasetId = "ds-api-dup-" + UUID.randomUUID().toString().substring(0, 8);
        String requestBody = createDatasetBody(datasetId, "blood-pressure", "FHIR_BUNDLE", FhirTestDataLoader.collectionSample());

        int firstStatus = mockMvc.perform(post("/api/v1/datasets/fhir")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andReturn()
                .getResponse()
                .getStatus();
        String secondBody = mockMvc.perform(post("/api/v1/datasets/fhir")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isConflict())
                .andReturn()
                .getResponse()
                .getContentAsString();

        JsonNode secondJson = OBJECT_MAPPER.readTree(secondBody);
        assertThat(firstStatus).isEqualTo(201);
        assertThat(secondJson.path("code").asText()).isEqualTo("CONFLICT");
    }

    @Test
    void shouldCreateDatasetFromStandaloneObservationPayload() throws Exception {
        String datasetId = "ds-api-obs-" + UUID.randomUUID().toString().substring(0, 8);
        String requestBody = createDatasetBody(datasetId, "blood-pressure", "FHIR_OBSERVATION", FhirTestDataLoader.observationReal2026());

        mockMvc.perform(post("/api/v1/datasets/fhir")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isCreated());

        String listBody = mockMvc.perform(get("/api/v1/datasets")
                        .param("clinicalCase", "blood-pressure")
                        .param("status", "PUBLISHED")
                        .param("page", "0")
                        .param("size", "100"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse()
                .getContentAsString();
        JsonNode listJson = OBJECT_MAPPER.readTree(listBody);
        assertThat(listJson.path("items").isArray()).isTrue();
        assertThat(listJson.path("items").toString()).contains(datasetId);
    }

    private String createDatasetBody(String datasetId, String clinicalCase, String datasetType, JsonNode payload) throws Exception {
        ObjectNode root = OBJECT_MAPPER.createObjectNode();
        root.put("datasetId", datasetId);
        root.put("datasetType", datasetType);
        root.put("clinicalCase", clinicalCase);
        root.set("payload", payload);

        ObjectNode metadata = OBJECT_MAPPER.createObjectNode();
        metadata.put("owner", "provider-a");
        metadata.put("purpose", "research");
        metadata.put("jurisdiction", "ES");
        metadata.put("policyUri", "https://gaiax-health.example/policies/default");
        metadata.put("receiverDid", "did:web:consumer.gaiax-health.local");
        metadata.put("retentionDays", 30);
        metadata.put("validFrom", "2026-01-01T00:00:00Z");
        metadata.put("validTo", "2026-12-31T23:59:59Z");
        metadata.putPOJO("tags", List.of("fhir", "functional"));
        root.set("metadata", metadata);
        return OBJECT_MAPPER.writeValueAsString(root);
    }

    @TestConfiguration
    static class FunctionalTestConfig {

        @Bean
        @Primary
        FhirObservationService fhirObservationService() {
            return new NoOpFhirObservationService();
        }
    }

    private static final class NoOpFhirObservationService extends FhirObservationService {

        private NoOpFhirObservationService() {
            super(new NoOpFhirObservationRepository(), new FhirValidationService(), new ObjectMapper());
        }

        @Override
        public JsonNode ingest(JsonNode body, String xRequestId) {
            return new ObjectMapper().createObjectNode().put("resourceType", "Bundle").put("type", "collection");
        }

        @Override
        public JsonNode listObservations(String patientRef, int count) {
            return new ObjectMapper().createObjectNode().put("resourceType", "Bundle").put("type", "searchset");
        }

        @Override
        public JsonNode listPatients(int count) {
            return new ObjectMapper().createObjectNode().put("resourceType", "Bundle").put("type", "searchset");
        }
    }

    private static final class NoOpFhirObservationRepository extends FhirObservationRepository {

        private NoOpFhirObservationRepository() {
            super(null, new ObjectMapper());
        }
    }
}
