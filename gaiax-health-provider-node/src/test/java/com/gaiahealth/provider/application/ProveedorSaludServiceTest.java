package com.gaiahealth.provider.application;

import com.gaiahealth.provider.domain.Medico;
import com.gaiahealth.provider.domain.MedicoRepository;
import com.gaiahealth.provider.domain.ProveedorSalud;
import com.gaiahealth.provider.domain.ProveedorSaludRepository;
import com.gaiahealth.provider.domain.dto.ProveedorSaludDTO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProveedorSaludServiceTest {

    @Mock
    private ProveedorSaludRepository proveedorSaludRepository;

    @Mock
    private MedicoRepository medicoRepository;

    @InjectMocks
    private ProveedorSaludService proveedorSaludService;

    private ProveedorSalud proveedor;
    private Medico medico;

    @BeforeEach
    void setUp() {
        proveedor = new ProveedorSalud();
        proveedor.setIdProveedor(UUID.randomUUID());
        proveedor.setNombreInstitucion("Hospital General");
        proveedor.setNifCif("A12345678");

        medico = new Medico();
        medico.setIdMedico(UUID.randomUUID());
        medico.setNombre("Dr. House");
        medico.setEspecialidad("Diagnóstico");
        medico.setNroColegiado("12345");
        medico.setEstadoActivo(true);
        medico.setProveedorSalud(proveedor);
    }

    @Test
    void findAllProveedores_Success() {
        when(proveedorSaludRepository.findAll()).thenReturn(List.of(proveedor));
        when(medicoRepository.findByProveedorSalud(proveedor)).thenReturn(List.of(medico));

        List<ProveedorSaludDTO> results = proveedorSaludService.findAllProveedores();

        assertNotNull(results);
        assertEquals(1, results.size());
        
        ProveedorSaludDTO dto = results.get(0);
        assertEquals(proveedor.getIdProveedor(), dto.getIdProveedor());
        assertEquals("Hospital General", dto.getNombreInstitucion());
        assertEquals("A12345678", dto.getNifCif());
        
        assertEquals(1, dto.getMedicos().size());
        ProveedorSaludDTO.MedicoDTO medicoDTO = dto.getMedicos().get(0);
        assertEquals(medico.getIdMedico(), medicoDTO.getIdMedico());
        assertEquals("Dr. House", medicoDTO.getNombre());
        assertEquals("Diagnóstico", medicoDTO.getEspecialidad());
        assertEquals(true, medicoDTO.getEstadoActivo());
    }

    @Test
    void findAllProveedores_EmptyList() {
        when(proveedorSaludRepository.findAll()).thenReturn(List.of());

        List<ProveedorSaludDTO> results = proveedorSaludService.findAllProveedores();

        assertNotNull(results);
        assertEquals(0, results.size());
    }
}
