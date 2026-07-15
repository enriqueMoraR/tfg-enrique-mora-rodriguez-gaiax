package com.gaiahealth.provider.api.security;

import com.gaiahealth.provider.domain.AuditoriaAcceso;
import com.gaiahealth.provider.domain.AuditoriaAccesoRepository;
import com.gaiahealth.provider.domain.Consentimiento;
import com.gaiahealth.provider.domain.ConsentimientoRepository;
import com.gaiahealth.provider.domain.HistorialClinico;
import com.gaiahealth.provider.domain.HistorialClinicoRepository;
import com.gaiahealth.provider.domain.Paciente;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Date;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ConsentimientoInterceptorTest {

    @Mock
    private ConsentimientoRepository consentimientoRepository;
    @Mock
    private HistorialClinicoRepository historialClinicoRepository;
    @Mock
    private AuditoriaAccesoRepository auditoriaAccesoRepository;

    @Mock
    private HttpServletRequest request;
    @Mock
    private HttpServletResponse response;

    @InjectMocks
    private ConsentimientoInterceptor interceptor;

    private UUID pacienteId;
    private UUID historialId;
    private UUID propositoId;
    private Paciente paciente;
    private HistorialClinico historial;

    @BeforeEach
    void setUp() {
        pacienteId = UUID.randomUUID();
        historialId = UUID.randomUUID();
        propositoId = UUID.randomUUID();

        paciente = new Paciente();
        paciente.setIdPaciente(pacienteId);

        historial = new HistorialClinico();
        historial.setIdHistorial(historialId);
        historial.setPaciente(paciente);
    }

    @Test
    void preHandle_NotProtectedPath_ReturnsTrue() throws Exception {
        when(request.getRequestURI()).thenReturn("/api/v1/proveedores");
        
        boolean result = interceptor.preHandle(request, response, new Object());
        
        assertTrue(result);
        verifyNoInteractions(historialClinicoRepository);
    }

    @Test
    void preHandle_InitPath_ReturnsTrue() throws Exception {
        when(request.getRequestURI()).thenReturn("/api/v1/historial/init");
        
        boolean result = interceptor.preHandle(request, response, new Object());
        
        assertTrue(result);
        verifyNoInteractions(historialClinicoRepository);
    }

    @Test
    void preHandle_PacientePath_NoPaciente_ReturnsFalse() throws Exception {
        when(request.getRequestURI()).thenReturn("/api/v1/historial/paciente/" + pacienteId);
        when(historialClinicoRepository.findByPacienteIdPaciente(pacienteId)).thenReturn(Optional.empty());
        
        boolean result = interceptor.preHandle(request, response, new Object());
        
        assertFalse(result);
        verify(response).sendError(HttpServletResponse.SC_NOT_FOUND, "Historial o paciente no encontrado");
    }

    @Test
    void preHandle_HistorialPath_NoPropositoId_ReturnsFalse() throws Exception {
        when(request.getRequestURI()).thenReturn("/api/v1/historial/" + historialId + "/diagnosticos");
        when(historialClinicoRepository.findByIdWithPaciente(historialId)).thenReturn(Optional.of(historial));
        when(request.getHeader("X-Proposito-ID")).thenReturn(null);
        
        boolean result = interceptor.preHandle(request, response, new Object());
        
        assertFalse(result);
        verify(response).sendError(HttpServletResponse.SC_BAD_REQUEST, "El header 'X-Proposito-ID' es requerido");
    }

    @Test
    void preHandle_ValidConsent_ReturnsTrue() throws Exception {
        when(request.getRequestURI()).thenReturn("/api/v1/historial/paciente/" + pacienteId);
        when(historialClinicoRepository.findByPacienteIdPaciente(pacienteId)).thenReturn(Optional.of(historial));
        when(request.getHeader("X-Proposito-ID")).thenReturn(propositoId.toString());
        
        Consentimiento c = new Consentimiento();
        when(consentimientoRepository.findByPacienteAndIdPropositoAndEstadoAndFechaExpiracionAfter(
                eq(paciente), eq(propositoId), eq("Activo"), any(Date.class)
        )).thenReturn(Optional.of(c));

        boolean result = interceptor.preHandle(request, response, new Object());
        
        assertTrue(result);
        verifyNoInteractions(response);
    }

    @Test
    void preHandle_NoValidConsent_AuditsAndReturnsFalse() throws Exception {
        when(request.getRequestURI()).thenReturn("/api/v1/historial/paciente/" + pacienteId);
        when(historialClinicoRepository.findByPacienteIdPaciente(pacienteId)).thenReturn(Optional.of(historial));
        when(request.getHeader("X-Proposito-ID")).thenReturn(propositoId.toString());
        when(request.getHeader("X-User-ID")).thenReturn(UUID.randomUUID().toString());
        when(request.getMethod()).thenReturn("GET");
        when(request.getRemoteAddr()).thenReturn("127.0.0.1");
        
        when(consentimientoRepository.findByPacienteAndIdPropositoAndEstadoAndFechaExpiracionAfter(
                eq(paciente), eq(propositoId), eq("Activo"), any(Date.class)
        )).thenReturn(Optional.empty());

        boolean result = interceptor.preHandle(request, response, new Object());
        
        assertFalse(result);
        verify(auditoriaAccesoRepository).save(any(AuditoriaAcceso.class));
        verify(response).sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado por falta de consentimiento válido.");
    }
}
