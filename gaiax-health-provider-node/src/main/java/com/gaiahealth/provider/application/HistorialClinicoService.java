package com.gaiahealth.provider.application;

import com.gaiahealth.provider.domain.*;
import com.gaiahealth.provider.domain.dto.HistorialClinicoDTO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.Map;
import java.util.Collections;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true) // La mayoría de los métodos son de solo lectura
public class HistorialClinicoService {

    private final HistorialClinicoRepository historialClinicoRepository;
    private final DiagnosticoRepository diagnosticoRepository;
    private final TratamientoRepository tratamientoRepository;
    private final MedicacionRepository medicacionRepository;
    private final PacienteRepository pacienteRepository;
    private final ConsentimientoRepository consentimientoRepository;
    private final DatosFiliacionRepository datosFiliacionRepository;
    private final AntecedentesPacienteRepository antecedentesPacienteRepository;
    private final DispositivoIotRepository dispositivoIotRepository;
    private final LecturaSensorRepository lecturaSensorRepository;

    public HistorialClinicoDTO findHistorialCompletoByPacienteId(UUID pacienteId) {
        HistorialClinico historial = historialClinicoRepository.findByPacienteIdPaciente(pacienteId)
                .orElseThrow(() -> new ProviderApiException(ProviderErrorCode.NOT_FOUND, "Historial no encontrado para el paciente " + pacienteId));

        // Cargar las colecciones asociadas
        // Esto podría optimizarse con JOIN FETCH si se vuelve un cuello de botella
        var diagnosticos = diagnosticoRepository.findByHistorialClinico(historial);
        var tratamientos = tratamientoRepository.findByHistorialClinico(historial);
        var filiacion = datosFiliacionRepository.findByHistorialClinico(historial);
        var antecedentes = antecedentesPacienteRepository.findByHistorialClinico(historial);
        var dispositivos = dispositivoIotRepository.findByPaciente(historial.getPaciente());

        return mapToDTO(historial, diagnosticos, tratamientos, filiacion, antecedentes, dispositivos);
    }

    private HistorialClinicoDTO mapToDTO(HistorialClinico historial, List<Diagnostico> diagnosticos, List<Tratamiento> tratamientos, List<DatosFiliacion> filiacion, List<AntecedentesPaciente> antecedentes, List<DispositivoIot> dispositivos) {
        HistorialClinicoDTO dto = new HistorialClinicoDTO();
        dto.setIdHistorial(historial.getIdHistorial());
        dto.setFechaCreacion(historial.getFechaCreacion());
        dto.setFechaUltimaActualizacion(historial.getFechaUltimaActualizacion());

        HistorialClinicoDTO.PacienteDTO pacienteDTO = new HistorialClinicoDTO.PacienteDTO();
        pacienteDTO.setIdPaciente(historial.getPaciente().getIdPaciente());
        pacienteDTO.setNombreCompleto(historial.getPaciente().getNombreCompleto());
        pacienteDTO.setNifDni(historial.getPaciente().getNifDni());
        dto.setPaciente(pacienteDTO);

        dto.setDiagnosticos(diagnosticos.stream().map(d -> {
            HistorialClinicoDTO.DiagnosticoDTO dDto = new HistorialClinicoDTO.DiagnosticoDTO();
            dDto.setIdDiagnostico(d.getIdDiagnostico());
            dDto.setDescripcion(d.getDescripcion());
            dDto.setCie10(d.getCie10());
            dDto.setFechaDiagnostico(d.getFechaDiagnostico());
            return dDto;
        }).collect(Collectors.toList()));

        Map<UUID, List<Medicacion>> medicacionesPorTratamiento;
        if (tratamientos.isEmpty()) {
            medicacionesPorTratamiento = Collections.emptyMap();
        } else {
            medicacionesPorTratamiento = medicacionRepository.findByTratamientoIn(tratamientos)
                .stream().collect(Collectors.groupingBy(m -> m.getTratamiento().getIdTratamiento()));
        }

        dto.setTratamientos(tratamientos.stream().map(t -> {
            HistorialClinicoDTO.TratamientoDTO tDto = new HistorialClinicoDTO.TratamientoDTO();
            tDto.setIdTratamiento(t.getIdTratamiento());
            tDto.setNombreTratamiento(t.getNombreTratamiento());
            tDto.setIndicaciones(t.getIndicaciones());
            tDto.setFechaInicio(t.getFechaInicio());
            
            // Cargar medicaciones desde el mapa precargado (evita N+1 query)
            var medicaciones = medicacionesPorTratamiento.getOrDefault(t.getIdTratamiento(), Collections.emptyList());
            tDto.setMedicaciones(medicaciones.stream().map(m -> {
                HistorialClinicoDTO.MedicacionDTO mDto = new HistorialClinicoDTO.MedicacionDTO();
                mDto.setIdMedicacion(m.getIdMedicacion());
                mDto.setPrincipioActivo(m.getPrincipioActivo());
                mDto.setDosis(m.getDosis());
                return mDto;
            }).collect(Collectors.toList()));
            return tDto;
        }).collect(Collectors.toList()));

        dto.setFiliacion(filiacion.stream().map(f -> {
            HistorialClinicoDTO.DatosFiliacionDTO fDto = new HistorialClinicoDTO.DatosFiliacionDTO();
            fDto.setIdFiliacion(f.getIdFiliacion());
            fDto.setComunidadAutonoma(f.getComunidadAutonoma());
            fDto.setCentroAsignado(f.getCentroAsignado());
            fDto.setNivelSocieconomico(f.getNivelSocieconomico());
            fDto.setIdiomaPreferido(f.getIdiomaPreferido());
            return fDto;
        }).collect(Collectors.toList()));

        dto.setAntecedentes(antecedentes.stream().map(a -> {
            HistorialClinicoDTO.AntecedentesPacienteDTO aDto = new HistorialClinicoDTO.AntecedentesPacienteDTO();
            aDto.setIdAntecedente(a.getIdAntecedente());
            aDto.setTipo(a.getTipo());
            aDto.setDescripcion(a.getDescripcion());
            aDto.setFechaInicio(a.getFechaInicio());
            aDto.setEsActivo(a.getEsActivo());
            aDto.setCie10(a.getCie10());
            return aDto;
        }).collect(Collectors.toList()));

        dto.setDispositivos(dispositivos.stream().map(d -> {
            HistorialClinicoDTO.DispositivoIotDTO dDto = new HistorialClinicoDTO.DispositivoIotDTO();
            dDto.setIdDispositivo(d.getIdDispositivo());
            dDto.setTipo(d.getTipo());
            dDto.setModelo(d.getModelo());
            dDto.setFabricante(d.getFabricante());
            dDto.setFechaInstalacion(d.getFechaInstalacion());
            dDto.setConectado(d.getConectado());
            
            var lecturas = lecturaSensorRepository.findByDispositivoIot(d);
            dDto.setLecturas(lecturas.stream().map(l -> {
                HistorialClinicoDTO.LecturaSensorDTO lDto = new HistorialClinicoDTO.LecturaSensorDTO();
                lDto.setIdLectura(l.getIdLectura());
                lDto.setValor(l.getValor());
                lDto.setUnidad(l.getUnidad());
                lDto.setTimestamp(l.getTimestamp());
                lDto.setCalidadDato(l.getCalidadDato());
                return lDto;
            }).collect(Collectors.toList()));
            return dDto;
        }).collect(Collectors.toList()));

        return dto;
    }

    @Transactional // Sobrescribir a no solo lectura
    public Diagnostico addDiagnostico(UUID historialId, Diagnostico diagnostico) {
        HistorialClinico historial = historialClinicoRepository.findById(historialId)
                .orElseThrow(() -> new RuntimeException("Historial no encontrado"));
        diagnostico.setHistorialClinico(historial);
        return diagnosticoRepository.save(diagnostico);
    }

    @Transactional // Sobrescribir a no solo lectura
    public Tratamiento addTratamiento(UUID historialId, Tratamiento tratamiento) {
        HistorialClinico historial = historialClinicoRepository.findById(historialId)
                .orElseThrow(() -> new RuntimeException("Historial no encontrado"));
        tratamiento.setHistorialClinico(historial);
        return tratamientoRepository.save(tratamiento);
    }

    @Transactional
    public void initializePacienteHistorial(com.gaiahealth.provider.domain.dto.InitHistorialRequest request) {
        UUID pacienteId = UUID.nameUUIDFromBytes(request.getFhirId().getBytes());

        Paciente paciente = pacienteRepository.findById(pacienteId).orElseGet(() -> {
            Paciente p = new Paciente();
            p.setIdPaciente(pacienteId);
            p.setNifDni(request.getNifDni());
            p.setNombreCompleto(request.getNombreCompleto());
            p.setGenero(request.getGenero());
            p.setEstadoActivo(true);
            try {
                if (request.getFechaNacimiento() != null) {
                    p.setFechaNacimiento(new java.text.SimpleDateFormat("yyyy-MM-dd").parse(request.getFechaNacimiento()));
                }
            } catch (Exception e) {
                throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "Formato de fecha de nacimiento inválido: " + request.getFechaNacimiento());
            }
            return pacienteRepository.save(p);
        });

        UUID historialId = UUID.nameUUIDFromBytes(("historial-" + request.getFhirId()).getBytes());
        HistorialClinico historial = historialClinicoRepository.findById(historialId).orElseGet(() -> {
            HistorialClinico h = new HistorialClinico();
            h.setIdHistorial(historialId);
            h.setPaciente(paciente);
            h.setFechaCreacion(new java.util.Date());
            h.setFechaUltimaActualizacion(new java.util.Date());
            h.setVersionFhir("v4.0.1");
            h.setEstado(true);
            return historialClinicoRepository.save(h);
        });

        UUID propositoId = UUID.fromString("770e8400-e29b-41d4-a716-446655440000");
        UUID consentimientoId = UUID.nameUUIDFromBytes(("consent-" + request.getFhirId()).getBytes());
        if (!consentimientoRepository.existsById(consentimientoId)) {
            Consentimiento c = new Consentimiento();
            c.setIdConsentimiento(consentimientoId);
            c.setPaciente(paciente);
            c.setIdProposito(propositoId);
            c.setEstado("Activo");
            c.setFechaInicio(new java.util.Date());
            c.setFechaExpiracion(new java.util.Date(System.currentTimeMillis() + 10L * 365 * 24 * 60 * 60 * 1000));
            consentimientoRepository.save(c);
        }

        if (request.getDiagnosticos() != null) {
            for (var dInfo : request.getDiagnosticos()) {
                Diagnostico d = new Diagnostico();
                d.setIdDiagnostico(UUID.randomUUID());
                d.setHistorialClinico(historial);
                d.setCie10(dInfo.getCie10());
                d.setDescripcion(dInfo.getDescripcion());
                d.setFechaDiagnostico(new java.util.Date());
                diagnosticoRepository.save(d);
            }
        }

        if (request.getTratamientos() != null) {
            for (var tInfo : request.getTratamientos()) {
                Tratamiento t = new Tratamiento();
                t.setIdTratamiento(UUID.randomUUID());
                t.setHistorialClinico(historial);
                t.setNombreTratamiento(tInfo.getNombreTratamiento());
                t.setIndicaciones(tInfo.getIndicaciones());
                t.setFechaInicio(new java.util.Date());
                t = tratamientoRepository.save(t);
                
                Medicacion m = new Medicacion();
                m.setIdMedicacion(UUID.randomUUID());
                m.setTratamiento(t);
                m.setPrincipioActivo(tInfo.getPrincipioActivo());
                m.setDosis("Dosis estándar");
                m.setFechaInicio(new java.util.Date());
                m.setEsAlergia(false);
                medicacionRepository.save(m);
            }
        }

        if (request.getFiliacion() != null) {
            for (var fInfo : request.getFiliacion()) {
                DatosFiliacion f = new DatosFiliacion();
                f.setIdFiliacion(UUID.randomUUID());
                f.setHistorialClinico(historial);
                f.setComunidadAutonoma(fInfo.getComunidadAutonoma());
                f.setCentroAsignado(fInfo.getCentroAsignado());
                f.setNivelSocieconomico(fInfo.getNivelSocieconomico());
                f.setIdiomaPreferido(fInfo.getIdiomaPreferido());
                datosFiliacionRepository.save(f);
            }
        }

        if (request.getAntecedentes() != null) {
            for (var aInfo : request.getAntecedentes()) {
                AntecedentesPaciente a = new AntecedentesPaciente();
                a.setIdAntecedente(UUID.randomUUID());
                a.setHistorialClinico(historial);
                a.setTipo(aInfo.getTipo());
                a.setDescripcion(aInfo.getDescripcion());
                try {
                    if (aInfo.getFechaInicio() != null) {
                        a.setFechaInicio(new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(aInfo.getFechaInicio()));
                    }
                } catch (Exception e) {
                    throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "Formato de fecha de inicio de antecedente inválido: " + aInfo.getFechaInicio());
                }
                a.setEsActivo(aInfo.getEsActivo());
                a.setCie10(aInfo.getCie10());
                antecedentesPacienteRepository.save(a);
            }
        }

        if (request.getDispositivos() != null) {
            for (var dInfo : request.getDispositivos()) {
                DispositivoIot d = new DispositivoIot();
                d.setIdDispositivo(UUID.randomUUID());
                d.setPaciente(paciente);
                d.setTipo(dInfo.getTipo());
                d.setModelo(dInfo.getModelo());
                d.setFabricante(dInfo.getFabricante());
                try {
                    if (dInfo.getFechaInstalacion() != null) {
                        d.setFechaInstalacion(new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(dInfo.getFechaInstalacion()));
                    }
                } catch (Exception e) {
                    throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "Formato de fecha de instalación de dispositivo inválido: " + dInfo.getFechaInstalacion());
                }
                d.setConectado(dInfo.getConectado());
                d = dispositivoIotRepository.save(d);

                if (dInfo.getLecturas() != null) {
                    for (var lInfo : dInfo.getLecturas()) {
                        LecturaSensor l = new LecturaSensor();
                        l.setIdLectura(UUID.randomUUID());
                        l.setDispositivoIot(d);
                        l.setValor(lInfo.getValor());
                        l.setUnidad(lInfo.getUnidad());
                        try {
                            if (lInfo.getTimestamp() != null) {
                                l.setTimestamp(new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(lInfo.getTimestamp()));
                            }
                        } catch (Exception e) {
                            throw new ProviderApiException(ProviderErrorCode.VALIDATION_ERROR, "Formato de timestamp de lectura inválido: " + lInfo.getTimestamp());
                        }
                        l.setCalidadDato(lInfo.getCalidadDato());
                        lecturaSensorRepository.save(l);
                    }
                }
            }
        }
    }
}
