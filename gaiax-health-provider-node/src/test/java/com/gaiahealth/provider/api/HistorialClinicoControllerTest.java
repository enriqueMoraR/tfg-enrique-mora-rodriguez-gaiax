package com.gaiahealth.provider.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.gaiahealth.provider.application.HistorialClinicoService;
import com.gaiahealth.provider.domain.Diagnostico;
import com.gaiahealth.provider.domain.Tratamiento;
import com.gaiahealth.provider.domain.dto.HistorialClinicoDTO;
import com.gaiahealth.provider.domain.dto.InitHistorialRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import com.gaiahealth.provider.api.security.AuditoriaInterceptor;
import com.gaiahealth.provider.api.security.ConsentimientoInterceptor;

import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(controllers = HistorialClinicoController.class)
@AutoConfigureMockMvc(addFilters = false) // Deshabilitar seguridad/filtros para tests de controlador puros
class HistorialClinicoControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private HistorialClinicoService historialClinicoService;

    @MockBean
    private AuditoriaInterceptor auditoriaInterceptor;

    @MockBean
    private ConsentimientoInterceptor consentimientoInterceptor;

    private UUID pacienteId;
    private HistorialClinicoDTO historialDTO;

    @BeforeEach
    void setUp() throws Exception {
        pacienteId = UUID.randomUUID();
        historialDTO = new HistorialClinicoDTO();
        historialDTO.setIdHistorial(UUID.randomUUID());
        HistorialClinicoDTO.PacienteDTO p = new HistorialClinicoDTO.PacienteDTO();
        p.setNombreCompleto("Test Patient");
        historialDTO.setPaciente(p);
        
        Mockito.when(consentimientoInterceptor.preHandle(any(), any(), any())).thenReturn(true);
        Mockito.when(auditoriaInterceptor.preHandle(any(), any(), any())).thenReturn(true);
    }

    @Test
    void getHistorialPorPaciente_Returns200() throws Exception {
        Mockito.when(historialClinicoService.findHistorialCompletoByPacienteId(any(UUID.class))).thenReturn(historialDTO);

        mockMvc.perform(get("/api/v1/historial/paciente/" + pacienteId.toString())
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.idHistorial").value(historialDTO.getIdHistorial().toString()))
                .andExpect(jsonPath("$.paciente.nombreCompleto").value("Test Patient"));
    }

    @Test
    void addDiagnostico_Returns200() throws Exception {
        UUID historialId = UUID.randomUUID();
        Diagnostico d = new Diagnostico();
        d.setDescripcion("Dolor de cabeza");
        d.setCie10("R51");

        Diagnostico saved = new Diagnostico();
        saved.setIdDiagnostico(UUID.randomUUID());
        saved.setDescripcion("Dolor de cabeza");

        Mockito.when(historialClinicoService.addDiagnostico(eq(historialId), any(Diagnostico.class))).thenReturn(saved);

        mockMvc.perform(post("/api/v1/historial/" + historialId + "/diagnosticos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(d)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.idDiagnostico").value(saved.getIdDiagnostico().toString()))
                .andExpect(jsonPath("$.descripcion").value("Dolor de cabeza"));
    }

    @Test
    void addTratamiento_Returns200() throws Exception {
        UUID historialId = UUID.randomUUID();
        Tratamiento t = new Tratamiento();
        t.setNombreTratamiento("Ibuprofeno");

        Tratamiento saved = new Tratamiento();
        saved.setIdTratamiento(UUID.randomUUID());
        saved.setNombreTratamiento("Ibuprofeno");

        Mockito.when(historialClinicoService.addTratamiento(eq(historialId), any(Tratamiento.class))).thenReturn(saved);

        mockMvc.perform(post("/api/v1/historial/" + historialId + "/tratamientos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(t)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.idTratamiento").value(saved.getIdTratamiento().toString()))
                .andExpect(jsonPath("$.nombreTratamiento").value("Ibuprofeno"));
    }

    @Test
    void initPacienteHistorial_Returns201() throws Exception {
        InitHistorialRequest req = new InitHistorialRequest();
        req.setFhirId("fhir-123");
        req.setNombreCompleto("Test");

        Mockito.doNothing().when(historialClinicoService).initializePacienteHistorial(any(InitHistorialRequest.class));

        mockMvc.perform(post("/api/v1/historial/init")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated());
    }
}
