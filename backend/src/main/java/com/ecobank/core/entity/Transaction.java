package com.ecobank.core.entity;

import jakarta.persistence.*;
import lombok.*;

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
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    @Column(nullable = false)
    private OffsetDateTime date;

    @Column(name = "merchant_name")
    private String merchantName;

    @Column(nullable = false, precision = 15, scale = 2)
    private BigDecimal amount;

    @Builder.Default
    private String currency = "EUR";

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    @Column(name = "payment_method")
    private String paymentMethod;

    private String description;

    @OneToOne(mappedBy = "transaction", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private TransactionCarbon transactionCarbon;

    public BigDecimal getCarbonFootprint() {
        return transactionCarbon != null ? transactionCarbon.getCarbonValueG() : BigDecimal.ZERO;
    }
}
