package com.ecobank.core.service;

import com.ecobank.core.entity.CarbonFactor;
import com.ecobank.core.repository.CarbonFactorRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CarbonCalculatorServiceTest {

    @Mock
    private CarbonFactorRepository carbonFactorRepository;

    @InjectMocks
    private CarbonCalculatorService carbonCalculatorService;

    private CarbonFactor foodFactor;
    private CarbonFactor transportFactor;

    @BeforeEach
    void setUp() {
        foodFactor = CarbonFactor.builder()
                .category("FOOD")
                .emissionFactor(new BigDecimal("0.5"))
                .description("Food and groceries")
                .build();

        transportFactor = CarbonFactor.builder()
                .category("TRANSPORT")
                .emissionFactor(new BigDecimal("2.1"))
                .description("Transportation")
                .build();
    }

    @Test
    void testCalculateCarbonFootprint_WithDatabaseFactor() {
        // Arrange
        BigDecimal amount = new BigDecimal("100.00");
        when(carbonFactorRepository.findByCategory("FOOD"))
                .thenReturn(Optional.of(foodFactor));

        // Act
        BigDecimal result = carbonCalculatorService.calculateCarbonFootprint(amount, "FOOD");

        // Assert
        assertEquals(new BigDecimal("50.00"), result);
        verify(carbonFactorRepository, times(1)).findByCategory("FOOD");
    }

    @Test
    void testCalculateCarbonFootprint_WithDefaultFactor() {
        // Arrange
        BigDecimal amount = new BigDecimal("100.00");
        when(carbonFactorRepository.findByCategory("FOOD"))
                .thenReturn(Optional.empty());

        // Act
        BigDecimal result = carbonCalculatorService.calculateCarbonFootprint(amount, "FOOD");

        // Assert
        assertEquals(new BigDecimal("50.00"), result); // Default factor is 0.5
        verify(carbonFactorRepository, times(1)).findByCategory("FOOD");
    }

    @Test
    void testCalculateCarbonFootprint_HighEmissionCategory() {
        // Arrange
        BigDecimal amount = new BigDecimal("50.00");
        when(carbonFactorRepository.findByCategory("TRANSPORT"))
                .thenReturn(Optional.of(transportFactor));

        // Act
        BigDecimal result = carbonCalculatorService.calculateCarbonFootprint(amount, "TRANSPORT");

        // Assert
        assertEquals(new BigDecimal("105.00"), result); // 50 * 2.1 = 105
    }

    @Test
    void testCalculateCarbonFootprint_SmallAmount() {
        // Arrange
        BigDecimal amount = new BigDecimal("5.50");
        when(carbonFactorRepository.findByCategory("FOOD"))
                .thenReturn(Optional.of(foodFactor));

        // Act
        BigDecimal result = carbonCalculatorService.calculateCarbonFootprint(amount, "FOOD");

        // Assert
        assertEquals(new BigDecimal("2.75"), result); // 5.50 * 0.5 = 2.75
    }

    @Test
    void testGetEmissionFactor_ExistingCategory() {
        // Arrange
        when(carbonFactorRepository.findByCategory("FOOD"))
                .thenReturn(Optional.of(foodFactor));

        // Act
        BigDecimal factor = carbonCalculatorService.getEmissionFactor("FOOD");

        // Assert
        assertEquals(new BigDecimal("0.5"), factor);
    }

    @Test
    void testGetEmissionFactor_NonExistingCategory() {
        // Arrange
        when(carbonFactorRepository.findByCategory("UNKNOWN"))
                .thenReturn(Optional.empty());

        // Act
        BigDecimal factor = carbonCalculatorService.getEmissionFactor("UNKNOWN");

        // Assert
        assertEquals(new BigDecimal("0.5"), factor); // Default factor
    }

    @Test
    void testUpdateCarbonFactor_NewCategory() {
        // Arrange
        String category = "NEW_CATEGORY";
        BigDecimal newFactor = new BigDecimal("1.5");
        when(carbonFactorRepository.findByCategory(category))
                .thenReturn(Optional.empty());
        when(carbonFactorRepository.save(any(CarbonFactor.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // Act
        CarbonFactor result = carbonCalculatorService.updateCarbonFactor(category, newFactor);

        // Assert
        assertNotNull(result);
        assertEquals("NEW_CATEGORY", result.getCategory());
        assertEquals(newFactor, result.getEmissionFactor());
        verify(carbonFactorRepository, times(1)).save(any(CarbonFactor.class));
    }

    @Test
    void testUpdateCarbonFactor_ExistingCategory() {
        // Arrange
        String category = "FOOD";
        BigDecimal newFactor = new BigDecimal("0.8");
        when(carbonFactorRepository.findByCategory(category))
                .thenReturn(Optional.of(foodFactor));
        when(carbonFactorRepository.save(any(CarbonFactor.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // Act
        CarbonFactor result = carbonCalculatorService.updateCarbonFactor(category, newFactor);

        // Assert
        assertNotNull(result);
        assertEquals(newFactor, result.getEmissionFactor());
        verify(carbonFactorRepository, times(1)).save(any(CarbonFactor.class));
    }

    @Test
    void testCalculateCarbonFootprint_CaseInsensitive() {
        // Arrange
        BigDecimal amount = new BigDecimal("100.00");
        when(carbonFactorRepository.findByCategory("FOOD"))
                .thenReturn(Optional.of(foodFactor));

        // Act
        BigDecimal result = carbonCalculatorService.calculateCarbonFootprint(amount, "food");

        // Assert
        assertEquals(new BigDecimal("50.00"), result);
        verify(carbonFactorRepository, times(1)).findByCategory("FOOD");
    }

    @Test
    void testCalculateCarbonFootprint_ZeroAmount() {
        // Arrange
        BigDecimal amount = BigDecimal.ZERO;
        when(carbonFactorRepository.findByCategory("FOOD"))
                .thenReturn(Optional.of(foodFactor));

        // Act
        BigDecimal result = carbonCalculatorService.calculateCarbonFootprint(amount, "FOOD");

        // Assert
        assertEquals(BigDecimal.ZERO.setScale(2), result);
    }

    @Test
    void testCalculateCarbonFootprint_Precision() {
        // Arrange
        BigDecimal amount = new BigDecimal("33.33");
        when(carbonFactorRepository.findByCategory("FOOD"))
                .thenReturn(Optional.of(foodFactor));

        // Act
        BigDecimal result = carbonCalculatorService.calculateCarbonFootprint(amount, "FOOD");

        // Assert
        assertEquals(2, result.scale()); // Should have 2 decimal places
        assertEquals(new BigDecimal("16.67"), result); // 33.33 * 0.5 = 16.665 rounded to 16.67
    }
}
