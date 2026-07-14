package com.gaiahealth.provider.api;

import com.gaiahealth.provider.application.HistorialClinicoService;
import com.gaiahealth.provider.domain.Diagnostico;
import com.gaiahealth.provider.domain.Tratamiento;
import com.gaiahealth.provider.domain.dto.HistorialClinicoDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/historial")
@RequiredArgsConstructor
public class HistorialClinicoController {

    private final HistorialClinicoService historialClinicoService;

    @GetMapping("/paciente/{pacienteId}")
    public ResponseEntity<HistorialClinicoDTO> getHistorialPorPaciente(@PathVariable String pacienteId) {
        UUID id;
        try {
            id = UUID.fromString(pacienteId);
        } catch (IllegalArgumentException e) {
            id = UUID.nameUUIDFromBytes(pacienteId.getBytes());
        }
        HistorialClinicoDTO historial = historialClinicoService.findHistorialCompletoByPacienteId(id);
        return ResponseEntity.ok(historial);
    }

    @PostMapping("/{historialId}/diagnosticos")
    public ResponseEntity<Diagnostico> addDiagnostico(@PathVariable UUID historialId, @RequestBody Diagnostico diagnostico) {
        Diagnostico nuevoDiagnostico = historialClinicoService.addDiagnostico(historialId, diagnostico);
        return ResponseEntity.ok(nuevoDiagnostico);
    }

    @PostMapping("/{historialId}/tratamientos")
    public ResponseEntity<Tratamiento> addTratamiento(@PathVariable UUID historialId, @RequestBody Tratamiento tratamiento) {
        Tratamiento nuevoTratamiento = historialClinicoService.addTratamiento(historialId, tratamiento);
        return ResponseEntity.ok(nuevoTratamiento);
    }

    @PostMapping("/init")
    public ResponseEntity<Void> initPacienteHistorial(@RequestBody com.gaiahealth.provider.domain.dto.InitHistorialRequest request) {
        historialClinicoService.initializePacienteHistorial(request);
        return ResponseEntity.status(201).build();
    }
}
