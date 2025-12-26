package com.ecobank.core.repository;

import com.ecobank.core.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, UUID> {
    
    @Query("SELECT t FROM Transaction t WHERE t.account.user.id = :userId ORDER BY t.date DESC")
    List<Transaction> findByUserId(UUID userId);
    
    @Query("SELECT t FROM Transaction t WHERE t.account.id = :accountId ORDER BY t.date DESC")
    List<Transaction> findByAccountId(UUID accountId);
    
    @Query("SELECT COALESCE(SUM(tc.carbonValueG), 0) FROM Transaction t " +
           "JOIN t.transactionCarbon tc WHERE t.account.user.id = :userId " +
           "AND t.date >= :startDate AND t.date < :endDate")
    BigDecimal getMonthlyCarbonByUserId(UUID userId, OffsetDateTime startDate, OffsetDateTime endDate);
    
    @Query("SELECT COALESCE(SUM(tc.carbonValueG), 0) FROM Transaction t " +
           "JOIN t.transactionCarbon tc WHERE t.account.user.id = :userId")
    BigDecimal getTotalCarbonByUserId(UUID userId);
}
