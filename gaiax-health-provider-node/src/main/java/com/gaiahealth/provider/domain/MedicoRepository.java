package com.gaiahealth.provider.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

import java.util.List;

@Repository
public interface MedicoRepository extends JpaRepository<Medico, UUID> {
    List<Medico> findByProveedorSalud(ProveedorSalud proveedorSalud);
}
