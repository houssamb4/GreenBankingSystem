package com.ecobank.core.resolver;

import com.ecobank.core.entity.Transaction;
import com.ecobank.core.service.AuthService;
import com.ecobank.core.service.TransactionService;
import com.ecobank.core.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@Slf4j
public class QueryResolver {

    private final UserService userService;
    private final AuthService authService;
    private final TransactionService transactionService;

    @QueryMapping(name = "getCurrentUser")
    public Map<String, Object> getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return authService.getCurrentUser(auth.getName());
    }

    @QueryMapping
    public List<Map<String, Object>> getUserTransactions(@Argument String userId) {
        UUID id = UUID.fromString(userId);
        return transactionService.getUserTransactions(id).stream()
                .map(this::convertTransactionToMap)
                .collect(Collectors.toList());
    }

    @QueryMapping
    public Map<String, Object> getCarbonStats(@Argument String userId) {
        UUID id = UUID.fromString(userId);
        return transactionService.getCarbonStats(id);
    }

    @QueryMapping
    public List<Map<String, Object>> getCategoryBreakdown(@Argument String userId) {
        UUID id = UUID.fromString(userId);
        return transactionService.getCategoryBreakdown(id);
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
