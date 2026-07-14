package com.gaiahealth.provider.application;

import com.gaiahealth.provider.domain.Medico;
import com.gaiahealth.provider.domain.MedicoRepository;
import com.gaiahealth.provider.domain.ProveedorSalud;
import com.gaiahealth.provider.domain.ProveedorSaludRepository;
import com.gaiahealth.provider.domain.dto.ProveedorSaludDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ProveedorSaludService {

    private final ProveedorSaludRepository proveedorSaludRepository;
    private final MedicoRepository medicoRepository;

    public List<ProveedorSaludDTO> findAllProveedores() {
        List<ProveedorSalud> proveedores = proveedorSaludRepository.findAll();
        
        return proveedores.stream().map(proveedor -> {
            ProveedorSaludDTO dto = new ProveedorSaludDTO();
            dto.setIdProveedor(proveedor.getIdProveedor());
            dto.setNombreInstitucion(proveedor.getNombreInstitucion());
            dto.setNifCif(proveedor.getNifCif());
            dto.setTipoProveedor(proveedor.getTipoProveedor());
            dto.setIdGaiaX(proveedor.getIdGaiaX());
            dto.setCertificacionSoap(proveedor.getCertificacionSoap());
            dto.setDireccion(proveedor.getDireccion());
            
            List<Medico> medicos = medicoRepository.findByProveedorSalud(proveedor);
            
            List<ProveedorSaludDTO.MedicoDTO> medicosDto = medicos.stream().map(medico -> {
                ProveedorSaludDTO.MedicoDTO mDto = new ProveedorSaludDTO.MedicoDTO();
                mDto.setIdMedico(medico.getIdMedico());
                mDto.setNombre(medico.getNombre());
                mDto.setNroColegiado(medico.getNroColegiado());
                mDto.setEspecialidad(medico.getEspecialidad());
                mDto.setEstadoActivo(medico.isEstadoActivo());
                return mDto;
            }).collect(Collectors.toList());
            
            dto.setMedicos(medicosDto);
            return dto;
        }).collect(Collectors.toList());
    }
}
