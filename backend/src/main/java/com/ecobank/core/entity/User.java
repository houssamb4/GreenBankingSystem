package com.ecobank.core.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "users")
@EqualsAndHashCode(callSuper = true)
public class User extends AuditModel {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @Column(unique = true, nullable = false)
    private String email;
    
    @Column(nullable = false)
    private String passwordHash;
    
    private String firstName;
    private String lastName;
    private String phoneNumber;
    
    @Builder.Default
    @Column(name = "eco_score")
    private Integer ecoScore = 100;

    @Builder.Default
    @Column(name = "total_carbon_saved", precision = 10, scale = 2)
    private BigDecimal totalCarbonSaved = BigDecimal.ZERO;

    @Builder.Default
    @Column(name = "monthly_carbon_budget", precision = 10, scale = 2)
    private BigDecimal monthlyCarbonBudget = new BigDecimal("100.0");

    @Builder.Default
    private Boolean isActive = true;
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Transaction> transactions;
}