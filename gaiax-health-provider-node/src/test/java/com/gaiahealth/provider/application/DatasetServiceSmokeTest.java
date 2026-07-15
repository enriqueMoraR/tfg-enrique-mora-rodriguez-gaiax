package com.gaiahealth.provider.application;

import com.gaiahealth.provider.application.DatasetService;
import com.gaiahealth.provider.domain.DatasetRecord;
import com.gaiahealth.provider.domain.FhirValidationService;
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
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.lenient;

import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class DatasetServiceSmokeTest {

    @Mock
    private com.gaiahealth.provider.domain.PacienteRepository pacienteRepository;
    @Mock
    private com.gaiahealth.provider.domain.HistorialClinicoRepository historialClinicoRepository;
    @Mock
    private com.gaiahealth.provider.domain.DiagnosticoRepository diagnosticoRepository;
    @Mock
    private com.gaiahealth.provider.domain.TratamientoRepository tratamientoRepository;
    @Mock
    private com.gaiahealth.provider.domain.MedicacionRepository medicacionRepository;
    @Mock
    private com.gaiahealth.provider.domain.MedicoRepository medicoRepository;

    @Spy
    private FhirValidationService fhirValidationService = new FhirValidationService();

    @InjectMocks
    @Spy
    private DatasetService datasetService;
    
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        lenient().doNothing().when(datasetService).transformAndPersist(any());
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
