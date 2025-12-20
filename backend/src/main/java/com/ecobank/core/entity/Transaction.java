package com.ecobank.core.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "transactions")
@EqualsAndHashCode(callSuper = true)
public class Transaction extends AuditModel {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @Column(nullable = false)
    private BigDecimal amount;
    
    private String currency = "USD";
    
    @Column(nullable = false)
    private String category;
    
    private String merchant;
    private String description;
    private String location;
    
    @Column(name = "carbon_footprint", nullable = false)
    private BigDecimal carbonFootprint;
    
    @Column(name = "blockchain_hash")
    private String blockchainHash;
    
    @Column(name = "transaction_date")
    private OffsetDateTime transactionDate;
}