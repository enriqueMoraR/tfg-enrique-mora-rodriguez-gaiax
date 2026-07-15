package com.gaiahealth.provider.api.security;

import com.gaiahealth.provider.domain.AuditoriaAcceso;
import com.gaiahealth.provider.domain.AuditoriaAccesoRepository;
import com.gaiahealth.provider.domain.ConsentimientoRepository;
import com.gaiahealth.provider.domain.HistorialClinicoRepository;
import com.gaiahealth.provider.domain.Paciente;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import lombok.RequiredArgsConstructor;

import java.util.Date;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class ConsentimientoInterceptor implements HandlerInterceptor {

    private final ConsentimientoRepository consentimientoRepository;
    private final HistorialClinicoRepository historialClinicoRepository;
    private final AuditoriaAccesoRepository auditoriaAccesoRepository;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        
        final String historialPath = "/api/v1/historial/";
        String path = request.getRequestURI();

        if (!path.startsWith(historialPath)) {
            return true; // No es una ruta protegida
        }

        String[] parts = path.substring(historialPath.length()).split("/");
        
        if (parts.length > 0 && parts[0].equals("init")) {
            return true;
        }

        Paciente paciente = null;

        if (parts[0].equals("paciente")) {
            UUID pacienteId;
            try {
                pacienteId = UUID.fromString(parts[1]);
            } catch (IllegalArgumentException e) {
                pacienteId = UUID.nameUUIDFromBytes(parts[1].getBytes());
            }
            paciente = historialClinicoRepository.findByPacienteIdPaciente(pacienteId)
                    .map(h -> h.getPaciente())
                    .orElse(null);
        } else {
            UUID historialId;
            try {
                historialId = UUID.fromString(parts[0]);
            } catch (IllegalArgumentException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de historial inválido en la URL");
                return false;
            }
            paciente = historialClinicoRepository.findByIdWithPaciente(historialId)
                    .map(h -> h.getPaciente())
                    .orElse(null);
        }

        if (paciente == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Historial o paciente no encontrado");
            return false;
        }

        String propositoHeader = request.getHeader("X-Proposito-ID");
        if (propositoHeader == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El header 'X-Proposito-ID' es requerido");
            return false;
        }
        UUID propositoId;
        try {
            propositoId = UUID.fromString(propositoHeader);
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de propósito inválido en el header");
            return false;
        }

        var consentimientoValido = consentimientoRepository.findByPacienteAndIdPropositoAndEstadoAndFechaExpiracionAfter(
                paciente,
                propositoId,
                "Activo",
                new Date()
        );

        if (consentimientoValido.isEmpty()) {
            String userIdHeader = request.getHeader("X-User-ID");
            UUID usuarioId = userIdHeader != null ? UUID.fromString(userIdHeader) : UUID.fromString("00000000-0000-0000-0000-000000000000");
            
            AuditoriaAcceso auditLog = new AuditoriaAcceso();
            auditLog.setIdAudit(UUID.randomUUID());
            auditLog.setPaciente(paciente);
            auditLog.setIdUsuarioAcceso(usuarioId);
            auditLog.setAccion(request.getMethod());
            auditLog.setTimestamp(new Date());
            auditLog.setMotivoAcceso(propositoHeader);
            auditLog.setIpOrigen(request.getRemoteAddr());
            auditLog.setResultado("Denegado - Falta Consentimiento");
            auditoriaAccesoRepository.save(auditLog);
            
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado por falta de consentimiento válido.");
            return false;
        }

        return true;
    }
}
