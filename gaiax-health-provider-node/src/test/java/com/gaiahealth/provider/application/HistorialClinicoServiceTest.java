package com.gaiahealth.provider.application;

import com.gaiahealth.provider.domain.*;
import com.gaiahealth.provider.domain.dto.HistorialClinicoDTO;
import com.gaiahealth.provider.domain.dto.InitHistorialRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.text.SimpleDateFormat;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class HistorialClinicoServiceTest {

    @Mock
    private HistorialClinicoRepository historialClinicoRepository;
    @Mock
    private DiagnosticoRepository diagnosticoRepository;
    @Mock
    private TratamientoRepository tratamientoRepository;
    @Mock
    private MedicacionRepository medicacionRepository;
    @Mock
    private PacienteRepository pacienteRepository;
    @Mock
    private ConsentimientoRepository consentimientoRepository;
    @Mock
    private DatosFiliacionRepository datosFiliacionRepository;
    @Mock
    private AntecedentesPacienteRepository antecedentesPacienteRepository;
    @Mock
    private DispositivoIotRepository dispositivoIotRepository;
    @Mock
    private LecturaSensorRepository lecturaSensorRepository;

    @InjectMocks
    private HistorialClinicoService historialClinicoService;

    private UUID pacienteId;
    private Paciente paciente;
    private HistorialClinico historial;

    @BeforeEach
    void setUp() {
        pacienteId = UUID.randomUUID();
        paciente = new Paciente();
        paciente.setIdPaciente(pacienteId);
        paciente.setNombreCompleto("Juan Perez");
        paciente.setNifDni("12345678A");

        historial = new HistorialClinico();
        historial.setIdHistorial(UUID.randomUUID());
        historial.setPaciente(paciente);
        historial.setFechaCreacion(new Date());
    }

    @Test
    void findHistorialCompletoByPacienteId_Success() {
        when(historialClinicoRepository.findByPacienteIdPaciente(pacienteId)).thenReturn(Optional.of(historial));
        
        Diagnostico d = new Diagnostico();
        d.setIdDiagnostico(UUID.randomUUID());
        d.setDescripcion("Fiebre");
        when(diagnosticoRepository.findByHistorialClinico(historial)).thenReturn(List.of(d));

        Tratamiento t = new Tratamiento();
        t.setIdTratamiento(UUID.randomUUID());
        t.setNombreTratamiento("Paracetamol");
        when(tratamientoRepository.findByHistorialClinico(historial)).thenReturn(List.of(t));

        Medicacion m = new Medicacion();
        m.setIdMedicacion(UUID.randomUUID());
        m.setTratamiento(t);
        m.setPrincipioActivo("Paracetamol 500mg");
        when(medicacionRepository.findByTratamientoIn(List.of(t))).thenReturn(List.of(m));

        when(datosFiliacionRepository.findByHistorialClinico(historial)).thenReturn(Collections.emptyList());
        when(antecedentesPacienteRepository.findByHistorialClinico(historial)).thenReturn(Collections.emptyList());
        when(dispositivoIotRepository.findByPaciente(paciente)).thenReturn(Collections.emptyList());

        HistorialClinicoDTO dto = historialClinicoService.findHistorialCompletoByPacienteId(pacienteId);

        assertNotNull(dto);
        assertEquals(historial.getIdHistorial(), dto.getIdHistorial());
        assertEquals("Juan Perez", dto.getPaciente().getNombreCompleto());
        assertEquals(1, dto.getDiagnosticos().size());
        assertEquals("Fiebre", dto.getDiagnosticos().get(0).getDescripcion());
        assertEquals(1, dto.getTratamientos().size());
        assertEquals("Paracetamol", dto.getTratamientos().get(0).getNombreTratamiento());
        assertEquals(1, dto.getTratamientos().get(0).getMedicaciones().size());
        assertEquals("Paracetamol 500mg", dto.getTratamientos().get(0).getMedicaciones().get(0).getPrincipioActivo());
    }

    @Test
    void findHistorialCompletoByPacienteId_NotFound() {
        when(historialClinicoRepository.findByPacienteIdPaciente(pacienteId)).thenReturn(Optional.empty());

        ProviderApiException ex = assertThrows(ProviderApiException.class, 
            () -> historialClinicoService.findHistorialCompletoByPacienteId(pacienteId));
        assertEquals(ProviderErrorCode.NOT_FOUND, ex.code());
    }

    @Test
    void addDiagnostico_Success() {
        UUID historialId = historial.getIdHistorial();
        Diagnostico diagnostico = new Diagnostico();
        diagnostico.setDescripcion("Nueva enfermedad");

        when(historialClinicoRepository.findById(historialId)).thenReturn(Optional.of(historial));
        when(diagnosticoRepository.save(any(Diagnostico.class))).thenAnswer(inv -> inv.getArgument(0));

        Diagnostico result = historialClinicoService.addDiagnostico(historialId, diagnostico);

        assertNotNull(result);
        assertEquals(historial, result.getHistorialClinico());
        verify(diagnosticoRepository).save(diagnostico);
    }

    @Test
    void addTratamiento_Success() {
        UUID historialId = historial.getIdHistorial();
        Tratamiento tratamiento = new Tratamiento();
        tratamiento.setNombreTratamiento("Nuevo tratamiento");

        when(historialClinicoRepository.findById(historialId)).thenReturn(Optional.of(historial));
        when(tratamientoRepository.save(any(Tratamiento.class))).thenAnswer(inv -> inv.getArgument(0));

        Tratamiento result = historialClinicoService.addTratamiento(historialId, tratamiento);

        assertNotNull(result);
        assertEquals(historial, result.getHistorialClinico());
        verify(tratamientoRepository).save(tratamiento);
    }

    @Test
    void initializePacienteHistorial_Success() {
        InitHistorialRequest req = new InitHistorialRequest();
        req.setFhirId("fhir-123");
        req.setNombreCompleto("Test Patient");
        req.setNifDni("12345");
        req.setFechaNacimiento("1990-01-01");

        InitHistorialRequest.DiagnosticoInfo dInfo = new InitHistorialRequest.DiagnosticoInfo();
        dInfo.setDescripcion("Diabetes");
        dInfo.setCie10("E11");
        req.setDiagnosticos(List.of(dInfo));

        UUID expectedPacienteId = UUID.nameUUIDFromBytes("fhir-123".getBytes());
        UUID expectedHistorialId = UUID.nameUUIDFromBytes("historial-fhir-123".getBytes());

        when(pacienteRepository.findById(expectedPacienteId)).thenReturn(Optional.empty());
        when(pacienteRepository.save(any(Paciente.class))).thenAnswer(inv -> inv.getArgument(0));
        when(historialClinicoRepository.findById(expectedHistorialId)).thenReturn(Optional.empty());
        when(historialClinicoRepository.save(any(HistorialClinico.class))).thenAnswer(inv -> inv.getArgument(0));

        historialClinicoService.initializePacienteHistorial(req);

        verify(pacienteRepository).save(any(Paciente.class));
        verify(historialClinicoRepository).save(any(HistorialClinico.class));
        verify(diagnosticoRepository, times(1)).save(any(Diagnostico.class));
    }

    @Test
    void initializePacienteHistorial_InvalidDateFormat() {
        InitHistorialRequest req = new InitHistorialRequest();
        req.setFhirId("fhir-123");
        req.setFechaNacimiento("bad-date");

        ProviderApiException ex = assertThrows(ProviderApiException.class, 
            () -> historialClinicoService.initializePacienteHistorial(req));
        assertEquals(ProviderErrorCode.VALIDATION_ERROR, ex.code());
    }
}
