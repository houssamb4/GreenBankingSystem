package com.ecobank.core.service;

import com.ecobank.core.entity.*;
import com.ecobank.core.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class TransactionService {
    
    private final TransactionRepository transactionRepository;
    private final AccountRepository accountRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;

    public Transaction createTransaction(UUID userId, BigDecimal amount, String categoryName, 
                                        String merchant, String description) {
        // Get user's first account
        List<Account> accounts = accountRepository.findByUserId(userId);
        if (accounts.isEmpty()) {
            throw new RuntimeException("No account found for user");
        }
        Account account = accounts.get(0);
        
        // Find category
        Category category = categoryRepository.findByName(categoryName)
                .orElseGet(() -> categoryRepository.findByName("AUTRE")
                        .orElseThrow(() -> new RuntimeException("Default category not found")));
        
        // Create transaction
        Transaction transaction = Transaction.builder()
                .account(account)
                .date(OffsetDateTime.now())
                .merchantName(merchant)
                .amount(amount)
                .currency("EUR")
                .category(category)
                .paymentMethod("CARD")
                .description(description)
                .build();
        
        transaction = transactionRepository.save(transaction);
        
        // Calculate carbon (simplified - use 500 gCO2e/EUR as default)
        BigDecimal carbonValue = amount.multiply(new BigDecimal("500"));
        
        TransactionCarbon carbon = TransactionCarbon.builder()
                .transaction(transaction)
                .carbonValueG(carbonValue)
                .calculationMethod("FACTOR_BASED")
                .computedAt(OffsetDateTime.now())
                .build();
        
        transaction.setTransactionCarbon(carbon);
        
        return transactionRepository.save(transaction);
    }

    public List<Transaction> getUserTransactions(UUID userId) {
        return transactionRepository.findByUserId(userId);
    }

    public Map<String, Object> getCarbonStats(UUID userId) {
        OffsetDateTime startDate = OffsetDateTime.now().withDayOfMonth(1)
                .withHour(0).withMinute(0).withSecond(0).withNano(0);
        OffsetDateTime endDate = startDate.plusMonths(1);
        
        BigDecimal monthlyCarbon = transactionRepository.getMonthlyCarbonByUserId(userId, startDate, endDate);
        BigDecimal totalCarbon = transactionRepository.getTotalCarbonByUserId(userId);
        
        if (monthlyCarbon == null) monthlyCarbon = BigDecimal.ZERO;
        if (totalCarbon == null) totalCarbon = BigDecimal.ZERO;
        
        BigDecimal budget = new BigDecimal("100000"); // 100kg in grams
        double percentage = monthlyCarbon.divide(budget, 4, java.math.RoundingMode.HALF_UP).doubleValue();
        
        int ecoScore = 100;
        if (percentage > 1.25) ecoScore = 0;
        else if (percentage > 1.0) ecoScore = 25;
        else if (percentage > 0.75) ecoScore = 50;
        else if (percentage > 0.5) ecoScore = 75;
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("userId", userId.toString());
        stats.put("totalCarbon", totalCarbon);
        stats.put("monthlyCarbon", monthlyCarbon);
        stats.put("carbonBudget", budget);
        stats.put("carbonPercentage", percentage);
        stats.put("ecoScore", ecoScore);

        return stats;
    }

    public List<Map<String, Object>> getCategoryBreakdown(UUID userId) {
        List<Transaction> transactions = transactionRepository.findByUserId(userId);

        // Group by category
        Map<String, List<Transaction>> categoryGroups = new HashMap<>();
        for (Transaction t : transactions) {
            String catName = t.getCategory() != null ? t.getCategory().getName() : "AUTRE";
            categoryGroups.computeIfAbsent(catName, k -> new ArrayList<>()).add(t);
        }

        // Calculate totals
        BigDecimal grandTotalCarbon = BigDecimal.ZERO;
        for (Transaction t : transactions) {
            grandTotalCarbon = grandTotalCarbon.add(t.getCarbonFootprint());
        }

        // Build breakdown
        List<Map<String, Object>> breakdown = new ArrayList<>();
        for (Map.Entry<String, List<Transaction>> entry : categoryGroups.entrySet()) {
            BigDecimal totalCarbon = BigDecimal.ZERO;
            BigDecimal totalAmount = BigDecimal.ZERO;

            for (Transaction t : entry.getValue()) {
                totalCarbon = totalCarbon.add(t.getCarbonFootprint());
                totalAmount = totalAmount.add(t.getAmount());
            }

            double percentage = grandTotalCarbon.compareTo(BigDecimal.ZERO) > 0
                ? totalCarbon.divide(grandTotalCarbon, 4, BigDecimal.ROUND_HALF_UP).multiply(BigDecimal.valueOf(100)).doubleValue()
                : 0.0;

            Map<String, Object> item = new HashMap<>();
            item.put("category", entry.getKey());
            item.put("totalCarbon", totalCarbon);
            item.put("totalAmount", totalAmount);
            item.put("transactionCount", entry.getValue().size());
            item.put("percentage", percentage);
            breakdown.add(item);
        }

        return breakdown;
    }
}
