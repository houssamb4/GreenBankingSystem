package com.ecobank.core.resolver;

import com.ecobank.core.entity.Transaction;
import com.ecobank.core.entity.User;
import com.ecobank.core.service.TransactionService;
import com.ecobank.core.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
public class QueryResolver {
    
    private final UserService userService;
    private final TransactionService transactionService;
    
    @QueryMapping
    public User getCurrentUser() {
        return userService.getCurrentUser();
    }
    
    @QueryMapping
    public User getUser(@Argument("id") UUID id) {
        return userService.getUserById(id);
    }
    
    @PreAuthorize("hasRole('ADMIN')")
    @QueryMapping
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }
    
    @QueryMapping
    public Transaction getTransaction(@Argument("id") UUID id) {
        return transactionService.getTransactionById(id);
    }
    
    @QueryMapping
    public List<Transaction> getUserTransactions(@Argument("userId") UUID userId) {
        return transactionService.getUserTransactions(userId);
    }
    
    @QueryMapping
    public List<Transaction> getCurrentUserTransactions() {
        return transactionService.getCurrentUserTransactions();
    }
}
