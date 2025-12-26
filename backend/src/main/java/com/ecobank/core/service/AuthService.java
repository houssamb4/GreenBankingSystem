package com.ecobank.core.service;

import com.ecobank.core.entity.Account;
import com.ecobank.core.entity.User;
import com.ecobank.core.repository.AccountRepository;
import com.ecobank.core.repository.UserRepository;
import com.ecobank.core.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class AuthService {

    private final UserRepository userRepository;
    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider tokenProvider;

    public Map<String, Object> register(String email, String password, String firstName, String lastName) {
        if (userRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("User already exists");
        }

        User user = User.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode(password))
                .firstName(firstName)
                .lastName(lastName)
                .fullName(firstName + " " + lastName)
                .isActive(true)
                .twoFactorEnabled(false)
                .preferences(new HashMap<>())
                .build();

        user = userRepository.saveAndFlush(user);

        // Create default account
        Account account = Account.builder()
                .user(user)
                .name("Compte Principal")
                .accountType("CHECKING")
                .currency("EUR")
                .balance(BigDecimal.ZERO)
                .isActive(true)
                .build();
        
        accountRepository.save(account);

        String token = tokenProvider.generateToken(email);

        Map<String, Object> result = new HashMap<>();
        result.put("token", token);
        result.put("user", convertUserToMap(user));
        
        return result;
    }

    public Map<String, Object> login(String email, String password) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Invalid credentials"));

        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new RuntimeException("Invalid credentials");
        }

        String token = tokenProvider.generateToken(email);

        Map<String, Object> result = new HashMap<>();
        result.put("token", token);
        result.put("user", convertUserToMap(user));
        
        return result;
    }

    public Map<String, Object> getCurrentUser(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return convertUserToMap(user);
    }

    private Map<String, Object> convertUserToMap(User user) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", user.getId().toString());
        map.put("email", user.getEmail());
        map.put("firstName", user.getFirstName());
        map.put("lastName", user.getLastName());
        map.put("fullName", user.getFullName());
        map.put("phoneNumber", user.getPhoneNumber());
        map.put("createdAt", user.getCreatedAt());
        map.put("updatedAt", user.getUpdatedAt());
        return map;
    }
}
