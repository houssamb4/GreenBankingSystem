package com.ecobank.core.dto;

import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

@Data
@Builder
public class UserProfile {
    private UUID id;
    private String email;
    private String firstName;
    private String lastName;
    private String phoneNumber;
    private Integer ecoScore;
    private BigDecimal totalCarbonSaved;
    private BigDecimal monthlyCarbonBudget;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
}