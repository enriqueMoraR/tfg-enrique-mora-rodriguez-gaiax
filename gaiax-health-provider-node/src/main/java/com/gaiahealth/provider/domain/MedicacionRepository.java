package com.gaiahealth.provider.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface MedicacionRepository extends JpaRepository<Medicacion, UUID> {
    List<Medicacion> findByTratamiento(Tratamiento tratamiento);
}
