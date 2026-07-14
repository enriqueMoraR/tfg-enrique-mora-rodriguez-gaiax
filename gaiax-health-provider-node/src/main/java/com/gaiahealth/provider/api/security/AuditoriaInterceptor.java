package com.gaiahealth.provider.api.security;

import com.gaiahealth.provider.domain.AuditoriaAcceso;
import com.gaiahealth.provider.domain.AuditoriaAccesoRepository;
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
public class AuditoriaInterceptor implements HandlerInterceptor {

    private final AuditoriaAccesoRepository auditoriaAccesoRepository;
    private final HistorialClinicoRepository historialClinicoRepository;

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        
        final String historialPath = "/api/v1/historial/";
        String path = request.getRequestURI();

        if (!path.startsWith(historialPath)) {
            return; // No auditar esta ruta
        }

        String[] parts = path.substring(historialPath.length()).split("/");
        
        if (parts.length > 0 && parts[0].equals("init")) {
            return; // No auditar init
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
                return;
            }
            paciente = historialClinicoRepository.findByIdWithPaciente(historialId)
                    .map(h -> h.getPaciente())
                    .orElse(null);
        }

        if (paciente == null) {
            return; // No se puede auditar si no se encuentra el paciente
        }

        // Simplificado: el ID de usuario debería venir de un token de seguridad (ej. JWT)
        String userIdHeader = request.getHeader("X-User-ID");
        UUID usuarioId = userIdHeader != null ? UUID.fromString(userIdHeader) : UUID.fromString("00000000-0000-0000-0000-000000000000");

        AuditoriaAcceso log = new AuditoriaAcceso();
        log.setIdAudit(UUID.randomUUID());
        log.setPaciente(paciente);
        log.setIdUsuarioAcceso(usuarioId);
        log.setAccion(request.getMethod());
        log.setTimestamp(new Date());
        log.setMotivoAcceso(request.getHeader("X-Proposito-ID"));
        log.setIpOrigen(request.getRemoteAddr());
        log.setResultado(response.getStatus() >= 200 && response.getStatus() < 300 ? "Exitoso" : "Fallido");

        auditoriaAccesoRepository.save(log);
    }
}
