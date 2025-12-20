package com.ecobank.core.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CarbonStats {
    private UUID userId;
    private BigDecimal totalCarbon;
    private BigDecimal monthlyCarbon;
    private BigDecimal carbonBudget;
    private Float carbonPercentage;
    private Integer ecoScore;
}
