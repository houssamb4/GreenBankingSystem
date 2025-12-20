package com.ecobank.core.repository;

import com.ecobank.core.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, UUID> {
    
    List<Transaction> findByUserId(UUID userId);
    List<Transaction> findByUserIdAndCategory(UUID userId, String category);
    
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND " +
           "EXTRACT(YEAR FROM t.transactionDate) = :year AND " +
           "EXTRACT(MONTH FROM t.transactionDate) = :month")
    List<Transaction> findByUserIdAndMonth(@Param("userId") UUID userId, 
                                          @Param("year") int year, 
                                          @Param("month") int month);
    
    @Query("SELECT COALESCE(SUM(t.carbonFootprint), 0) FROM Transaction t WHERE t.user.id = :userId")
    BigDecimal getTotalCarbonByUserId(@Param("userId") UUID userId);
    
    @Query("SELECT COALESCE(SUM(t.carbonFootprint), 0) FROM Transaction t WHERE t.user.id = :userId " +
           "AND t.transactionDate >= :startDate AND t.transactionDate < :endDate")
    BigDecimal getMonthlyCarbonByUserId(@Param("userId") UUID userId, 
                                       @Param("startDate") OffsetDateTime startDate,
                                       @Param("endDate") OffsetDateTime endDate);
    
    @Query("SELECT t.category, SUM(t.carbonFootprint) as totalCarbon, " +
           "SUM(t.amount) as totalAmount, COUNT(t) as transactionCount " +
           "FROM Transaction t WHERE t.user.id = :userId " +
           "GROUP BY t.category")
    List<Object[]> getCategoryBreakdown(@Param("userId") UUID userId);
}