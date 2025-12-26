package com.ecobank.core.resolver;

import com.ecobank.core.entity.Transaction;
import com.ecobank.core.service.AuthService;
import com.ecobank.core.service.TransactionService;
import com.ecobank.core.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import java.math.BigDecimal;
import java.util.*;

@Controller
@RequiredArgsConstructor
@Slf4j
public class MutationResolver {

    private final AuthService authService;
    private final TransactionService transactionService;
    private final UserService userService;

    @MutationMapping
    public Map<String, Object> register(@Argument Map<String, Object> input) {
        String email = (String) input.get("email");
        String password = (String) input.get("password");
        String firstName = (String) input.get("firstName");
        String lastName = (String) input.get("lastName");
        
        return authService.register(email, password, firstName, lastName);
    }

    @MutationMapping
    public Map<String, Object> login(@Argument Map<String, Object> input) {
        String email = (String) input.get("email");
        String password = (String) input.get("password");
        
        return authService.login(email, password);
    }

    @MutationMapping
    public Map<String, Object> createTransaction(@Argument Map<String, Object> input) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        
        UUID userId = userService.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"))
                .getId();
        
        BigDecimal amount = new BigDecimal(input.get("amount").toString());
        String category = (String) input.get("category");
        String merchant = (String) input.get("merchant");
        String description = (String) input.getOrDefault("description", "");
        
        Transaction transaction = transactionService.createTransaction(
                userId, amount, category, merchant, description);
        
        return convertTransactionToMap(transaction);
    }

    private Map<String, Object> convertTransactionToMap(Transaction t) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", t.getId().toString());
        map.put("amount", t.getAmount());
        map.put("currency", t.getCurrency());
        map.put("category", t.getCategory() != null ? t.getCategory().getName() : "AUTRE");
        map.put("merchantName", t.getMerchantName());
        map.put("description", t.getDescription());
        map.put("carbonFootprint", t.getCarbonFootprint());
        map.put("date", t.getDate());
        map.put("createdAt", t.getCreatedAt());
        map.put("updatedAt", t.getUpdatedAt());
        return map;
    }
}
