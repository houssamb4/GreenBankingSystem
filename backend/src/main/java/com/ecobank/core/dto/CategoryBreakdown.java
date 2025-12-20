package com.ecobank.core.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CategoryBreakdown {
    private String category;
    private BigDecimal totalCarbon;
    private BigDecimal totalAmount;
    private Integer transactionCount;
    private Float percentage;
}
