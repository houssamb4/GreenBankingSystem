package com.ecobank.core.service;

import com.ecobank.core.dto.UserProfile;
import com.ecobank.core.entity.User;
import com.ecobank.core.repository.TransactionRepository;
import com.ecobank.core.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional
public class UserService {

    private final UserRepository userRepository;
    private final TransactionRepository transactionRepository;
    
    public User getCurrentUser() {
        String email = getCurrentUserEmail();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }
    
    public UserProfile getCurrentUserProfile() {
        User user = getCurrentUser();
        return mapToUserProfile(user);
    }
    
    public User getUserById(UUID id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }
    
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    
    public User updateUserProfile(String firstName, String lastName, String phoneNumber) {
        User user = getCurrentUser();
        
        if (firstName != null) user.setFirstName(firstName);
        if (lastName != null) user.setLastName(lastName);
        if (phoneNumber != null) user.setPhoneNumber(phoneNumber);
        
        return userRepository.save(user);
    }
    
    public User updateCarbonBudget(BigDecimal budget) {
        User user = getCurrentUser();
        user.setMonthlyCarbonBudget(budget);
        return userRepository.save(user);
    }
    
    public void updateUserEcoScore(UUID userId) {
        User user = getUserById(userId);

        // Calculate monthly carbon directly using repository
        LocalDateTime startDate = LocalDateTime.now().withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
        LocalDateTime endDate = startDate.plusMonths(1);
        BigDecimal monthlyCarbon = transactionRepository.getMonthlyCarbonByUserId(userId, startDate, endDate);

        BigDecimal budget = user.getMonthlyCarbonBudget();

        if (budget.compareTo(BigDecimal.ZERO) <= 0) {
            user.setEcoScore(100);
            userRepository.save(user);
            return;
        }

        double percentage = monthlyCarbon.divide(budget, 4, RoundingMode.HALF_UP).doubleValue();
        int ecoScore;

        if (percentage <= 0.5) ecoScore = 100;
        else if (percentage <= 0.75) ecoScore = 75;
        else if (percentage <= 1.0) ecoScore = 50;
        else if (percentage <= 1.25) ecoScore = 25;
        else ecoScore = 0;

        user.setEcoScore(ecoScore);
        userRepository.save(user);
    }
    
    public UserProfile mapToUserProfile(User user) {
        return UserProfile.builder()
                .id(user.getId())
                .email(user.getEmail())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .phoneNumber(user.getPhoneNumber())
                .ecoScore(user.getEcoScore())
                .totalCarbonSaved(user.getTotalCarbonSaved())
                .monthlyCarbonBudget(user.getMonthlyCarbonBudget())
                .createdAt(user.getCreatedAt())
                .updatedAt(user.getUpdatedAt())
                .build();
    }
    
    private String getCurrentUserEmail() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        System.out.println("DEBUG AUTH: Principal class: " + principal.getClass().getName());
        System.out.println("DEBUG AUTH: Principal value: " + principal);
        
        if (principal instanceof UserDetails) {
            return ((UserDetails) principal).getUsername();
        } else {
            return principal.toString();
        }
    }
}