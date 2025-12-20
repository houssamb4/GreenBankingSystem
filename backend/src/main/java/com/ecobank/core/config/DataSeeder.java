package com.ecobank.core.config;

import com.ecobank.core.entity.CarbonFactor;
import com.ecobank.core.repository.CarbonFactorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

@Component
@RequiredArgsConstructor
public class DataSeeder implements CommandLineRunner {

    private final CarbonFactorRepository carbonFactorRepository;

    @Override
    public void run(String... args) throws Exception {
        seedCarbonFactors();
    }

    private void seedCarbonFactors() {
        if (carbonFactorRepository.count() > 0) {
            return;
        }

        List<CarbonFactor> factors = Arrays.asList(
            createFactor("FOOD", 0.5, "Food and dining"),
            createFactor("TRANSPORT", 2.3, "Transportation and fuel"),
            createFactor("SHOPPING", 1.2, "General shopping"),
            createFactor("ENERGY", 0.8, "Electricity and gas"),
            createFactor("SERVICES", 0.3, "Services"),
            createFactor("ENTERTAINMENT", 0.4, "Entertainment"),
            createFactor("TRAVEL", 3.5, "Flights and hotels"),
            createFactor("HEALTHCARE", 0.2, "Medical services"),
            createFactor("EDUCATION", 0.1, "Education"),
            createFactor("TECHNOLOGY", 0.6, "Electronics and software"),
            createFactor("FASHION", 1.5, "Clothing and accessories"),
            createFactor("HOME", 0.7, "Home improvement"),
            createFactor("GREEN", 0.0, "Eco-friendly purchases"),
            createFactor("OTHER", 0.5, "Miscellaneous")
        );

        carbonFactorRepository.saveAll(factors);
        System.out.println("Seeded " + factors.size() + " carbon factors.");
    }

    private CarbonFactor createFactor(String category, double factor, String description) {
        return CarbonFactor.builder()
                .category(category)
                .emissionFactor(BigDecimal.valueOf(factor))
                .description(description)
                .build();
    }
}
