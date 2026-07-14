package com.gaiahealth.provider.api;

import com.gaiahealth.provider.application.ProveedorSaludService;
import com.gaiahealth.provider.domain.dto.ProveedorSaludDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/proveedores")
@RequiredArgsConstructor
public class ProveedorSaludController {

    private final ProveedorSaludService proveedorSaludService;

    @GetMapping
    public ResponseEntity<List<ProveedorSaludDTO>> getAllProveedores() {
        return ResponseEntity.ok(proveedorSaludService.findAllProveedores());
    }
}
