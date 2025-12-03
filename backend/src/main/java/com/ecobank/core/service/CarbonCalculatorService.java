package com.ecobank.core.service;

import com.ecobank.core.entity.CarbonFactor;
import com.ecobank.core.repository.CarbonFactorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CarbonCalculatorService {
    
    private final CarbonFactorRepository carbonFactorRepository;
    
    // Default emission factors if not in database
    private static final Map<String, BigDecimal> DEFAULT_FACTORS = new HashMap<>();
    
    static {
        DEFAULT_FACTORS.put("FOOD", new BigDecimal("0.5"));
        DEFAULT_FACTORS.put("TRANSPORT", new BigDecimal("2.1"));
        DEFAULT_FACTORS.put("SHOPPING", new BigDecimal("0.8"));
        DEFAULT_FACTORS.put("ENERGY", new BigDecimal("1.7"));
        DEFAULT_FACTORS.put("SERVICES", new BigDecimal("0.3"));
    }
    
    public BigDecimal calculateCarbonFootprint(BigDecimal amount, String category) {
        BigDecimal emissionFactor = getEmissionFactor(category);
        
        // Calculate: amount * emission_factor
        return amount.multiply(emissionFactor)
                .setScale(2, RoundingMode.HALF_UP);
    }
    
    public BigDecimal getEmissionFactor(String category) {
        return carbonFactorRepository.findByCategory(category.toUpperCase())
                .map(CarbonFactor::getEmissionFactor)
                .orElseGet(() -> DEFAULT_FACTORS.getOrDefault(
                    category.toUpperCase(), 
                    new BigDecimal("0.5") // Default factor
                ));
    }
    
    public CarbonFactor updateCarbonFactor(String category, BigDecimal factor) {
        CarbonFactor carbonFactor = carbonFactorRepository.findByCategory(category)
                .orElse(CarbonFactor.builder().build());
        
        carbonFactor.setCategory(category.toUpperCase());
        carbonFactor.setEmissionFactor(factor);
        
        return carbonFactorRepository.save(carbonFactor);
    }
}