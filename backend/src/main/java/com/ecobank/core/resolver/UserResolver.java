package com.ecobank.core.resolver;

import com.ecobank.core.entity.Transaction;
import com.ecobank.core.entity.User;
import com.ecobank.core.service.TransactionService;
import lombok.RequiredArgsConstructor;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
public class UserResolver {
    
    private final TransactionService transactionService;
    
    @SchemaMapping(typeName = "User", field = "transactions")
    public List<Transaction> resolveTransactions(User user) {
        // Return transactions for the user
        return transactionService.getUserTransactions(user.getId());
    }
}
