package com.ecobank.core.service;

import com.ecobank.core.entity.CarbonFactor;
import com.ecobank.core.repository.CarbonFactorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CarbonFactorService {

    private final CarbonFactorRepository carbonFactorRepository;

    @PreAuthorize("hasRole('ADMIN')")
    public CarbonFactor updateCarbonFactor(String category, BigDecimal factor) {
        Optional<CarbonFactor> existingFactor = carbonFactorRepository.findByCategory(category);
        
        CarbonFactor carbonFactor;
        if (existingFactor.isPresent()) {
            carbonFactor = existingFactor.get();
            carbonFactor.setEmissionFactor(factor);
        } else {
            carbonFactor = CarbonFactor.builder()
                    .category(category)
                    .emissionFactor(factor)
                    .description("Auto-generated factor for " + category)
                    .build();
        }
        
        return carbonFactorRepository.save(carbonFactor);
    }
}
