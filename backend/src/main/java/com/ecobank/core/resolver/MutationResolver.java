package com.ecobank.core.resolver;

import com.ecobank.core.dto.AuthResponse;
import com.ecobank.core.dto.LoginRequest;
import com.ecobank.core.dto.RegisterRequest;
import com.ecobank.core.dto.TransactionInput;
import com.ecobank.core.entity.Transaction;
import com.ecobank.core.entity.User;
import com.ecobank.core.service.AuthService;
import com.ecobank.core.service.TransactionService;
import com.ecobank.core.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

import java.math.BigDecimal;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
public class MutationResolver {
    
    private final AuthService authService;
    private final UserService userService;
    private final TransactionService transactionService;
    
    @MutationMapping
    public AuthResponse register(@Argument("input") RegisterRequest input) {
        return authService.register(input);
    }
    
    @MutationMapping
    public AuthResponse login(@Argument("input") LoginRequest input) {
        return authService.login(input);
    }
    
    @MutationMapping
    public AuthResponse refreshToken(@Argument("token") String token) {
        return authService.refreshToken(token);
    }
    
    @MutationMapping
    public Transaction createTransaction(@Argument("input") TransactionInput input) {
        return transactionService.createTransaction(input);
    }
    
    @MutationMapping
    public Transaction updateTransaction(
            @Argument("id") UUID id,
            @Argument("input") TransactionInput input) {
        return transactionService.updateTransaction(id, input);
    }
    
    @MutationMapping
    public Boolean deleteTransaction(@Argument("id") UUID id) {
        return transactionService.deleteTransaction(id);
    }
    
    @MutationMapping
    public User updateCarbonBudget(@Argument("budget") BigDecimal budget) {
        return userService.updateCarbonBudget(budget);
    }
}