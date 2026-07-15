package com.gaiahealth.provider.api;

import com.gaiahealth.provider.application.ProveedorSaludService;
import com.gaiahealth.provider.domain.dto.ProveedorSaludDTO;
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

import java.util.List;
import java.util.UUID;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(controllers = ProveedorSaludController.class)
@AutoConfigureMockMvc(addFilters = false)
class ProveedorSaludControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ProveedorSaludService proveedorSaludService;

    @MockBean
    private AuditoriaInterceptor auditoriaInterceptor;

    @MockBean
    private ConsentimientoInterceptor consentimientoInterceptor;

    @Test
    void getAllProveedoresSalud_Returns200AndList() throws Exception {
        Mockito.when(consentimientoInterceptor.preHandle(Mockito.any(), Mockito.any(), Mockito.any())).thenReturn(true);
        Mockito.when(auditoriaInterceptor.preHandle(Mockito.any(), Mockito.any(), Mockito.any())).thenReturn(true);
        
        ProveedorSaludDTO dto = new ProveedorSaludDTO();
        dto.setIdProveedor(UUID.randomUUID());
        dto.setNombreInstitucion("Hospital General");

        Mockito.when(proveedorSaludService.findAllProveedores()).thenReturn(List.of(dto));

        mockMvc.perform(get("/api/v1/proveedores")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].nombreInstitucion").value("Hospital General"));
    }
}
