package com.ecobank.core.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.Map;
import java.util.UUID;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "transaction_carbon")
public class TransactionCarbon {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "transaction_id", nullable = false)
    private Transaction transaction;
    
    @Column(name = "carbon_value_g", nullable = false, precision = 15, scale = 2)
    private BigDecimal carbonValueG;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "factor_id")
    private EmissionFactor factor;
    
    @Column(name = "calculation_method")
    private String calculationMethod;
    
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "details_json", columnDefinition = "jsonb")
    private Map<String, Object> detailsJson;
    
    @Column(name = "computed_at")
    private OffsetDateTime computedAt;
}
