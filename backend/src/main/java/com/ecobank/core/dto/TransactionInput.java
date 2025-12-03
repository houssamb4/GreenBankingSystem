package com.ecobank.core.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class TransactionInput {
    private BigDecimal amount;
    private String currency = "USD";
    private String category;
    private String merchant;
    private String description;
    private String location;
}