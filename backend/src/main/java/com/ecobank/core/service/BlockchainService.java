package com.ecobank.core.service;

import com.ecobank.core.entity.Transaction;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class BlockchainService {
    
    public void recordTransactionAsync(Transaction transaction) {
        // TODO: Implement blockchain integration
        // For now, just log
        log.info("Transaction would be recorded on blockchain: {}", transaction.getId());
    }
}