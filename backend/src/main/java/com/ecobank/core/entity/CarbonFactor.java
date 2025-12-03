package com.ecobank.core.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.UUID;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "carbon_factors")
@EqualsAndHashCode(callSuper = true)
public class CarbonFactor extends AuditModel {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @Column(unique = true, nullable = false)
    private String category;
    
    @Column(name = "emission_factor", nullable = false, precision = 10, scale = 4)
    private BigDecimal emissionFactor;
    
    private String description;
}