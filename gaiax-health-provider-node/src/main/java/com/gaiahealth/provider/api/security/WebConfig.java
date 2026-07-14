package com.gaiahealth.provider.api.security;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class WebConfig implements WebMvcConfigurer {

    private final ConsentimientoInterceptor consentimientoInterceptor;
    private final AuditoriaInterceptor auditoriaInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(consentimientoInterceptor)
                .addPathPatterns("/api/v1/historial/**");
        
        registry.addInterceptor(auditoriaInterceptor)
                .addPathPatterns("/api/v1/historial/**");
    }
}
