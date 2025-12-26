package com.ecobank.core.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "emission_factors")
@EqualsAndHashCode(callSuper = true)
public class EmissionFactor extends AuditModel {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;
    
    @Column(name = "factor_value", nullable = false, precision = 10, scale = 4)
    private BigDecimal factorValue;
    
    private String unit;
    private String source;
    
    @Column(name = "effective_date")
    private LocalDate effectiveDate;
    
    @Column(name = "end_date")
    private LocalDate endDate;
}
