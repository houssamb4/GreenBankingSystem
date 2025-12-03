package com.ecobank.core.service;

import com.ecobank.core.dto.TransactionInput;
import com.ecobank.core.entity.Transaction;
import com.ecobank.core.entity.User;
import com.ecobank.core.repository.TransactionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional
public class TransactionService {
    
    private final TransactionRepository transactionRepository;
    private final UserService userService;
    private final CarbonCalculatorService carbonCalculatorService;
    private final BlockchainService blockchainService;
    
    public Transaction createTransaction(TransactionInput input) {
        User user = userService.getCurrentUser();
        
        // Calculate carbon footprint
        BigDecimal carbonFootprint = carbonCalculatorService.calculateCarbonFootprint(
            input.getAmount(), 
            input.getCategory()
        );
        
        // Create transaction using builder pattern
        Transaction transaction = Transaction.builder()
            .user(user)
            .amount(input.getAmount())
            .currency(input.getCurrency() != null ? input.getCurrency() : "USD")
            .category(input.getCategory())
            .merchant(input.getMerchant())
            .description(input.getDescription())
            .location(input.getLocation())
            .carbonFootprint(carbonFootprint)
            .transactionDate(LocalDateTime.now())
            .build();
        
        // Save to database
        Transaction savedTransaction = transactionRepository.save(transaction);
        
        // Record on blockchain (async)
        blockchainService.recordTransactionAsync(savedTransaction);
        
        // Update user eco score
        userService.updateUserEcoScore(user.getId());
        
        return savedTransaction;
    }
    
    public Transaction getTransactionById(UUID id) {
        return transactionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Transaction not found"));
    }
    
    public List<Transaction> getUserTransactions(UUID userId) {
        return transactionRepository.findByUserId(userId);
    }
    
    public List<Transaction> getCurrentUserTransactions() {
        User user = userService.getCurrentUser();
        return transactionRepository.findByUserId(user.getId());
    }
    
    public List<Transaction> getTransactionsByCategory(String category) {
        User user = userService.getCurrentUser();
        return transactionRepository.findByUserIdAndCategory(user.getId(), category);
    }
    
    public BigDecimal getMonthlyCarbon(UUID userId) {
        LocalDateTime startDate = LocalDateTime.now().withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
        LocalDateTime endDate = startDate.plusMonths(1);
        
        return transactionRepository.getMonthlyCarbonByUserId(userId, startDate, endDate);
    }
    
    public List<Object[]> getCategoryBreakdown(UUID userId) {
        return transactionRepository.getCategoryBreakdown(userId);
    }
    
    public Transaction updateTransaction(UUID id, TransactionInput input) {
        Transaction transaction = getTransactionById(id);
        
        // Check if user owns this transaction
        User currentUser = userService.getCurrentUser();
        if (!transaction.getUser().getId().equals(currentUser.getId())) {
            throw new RuntimeException("Unauthorized");
        }
        
        // Update fields
        if (input.getAmount() != null) {
            transaction.setAmount(input.getAmount());
        }
        if (input.getCategory() != null) {
            transaction.setCategory(input.getCategory());
        }
        if (input.getMerchant() != null) {
            transaction.setMerchant(input.getMerchant());
        }
        if (input.getDescription() != null) {
            transaction.setDescription(input.getDescription());
        }
        if (input.getLocation() != null) {
            transaction.setLocation(input.getLocation());
        }
        
        // Recalculate carbon footprint if amount or category changed
        if (input.getAmount() != null || input.getCategory() != null) {
            BigDecimal carbonFootprint = carbonCalculatorService.calculateCarbonFootprint(
                transaction.getAmount(), 
                transaction.getCategory()
            );
            transaction.setCarbonFootprint(carbonFootprint);
        }
        
        return transactionRepository.save(transaction);
    }
    
    public boolean deleteTransaction(UUID id) {
        Transaction transaction = getTransactionById(id);
        
        // Check if user owns this transaction
        User currentUser = userService.getCurrentUser();
        if (!transaction.getUser().getId().equals(currentUser.getId())) {
            throw new RuntimeException("Unauthorized");
        }
        
        transactionRepository.delete(transaction);
        userService.updateUserEcoScore(currentUser.getId());
        
        return true;
    }
}