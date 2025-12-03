package com.ecobank.core.repository;

import com.ecobank.core.entity.CarbonFactor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface CarbonFactorRepository extends JpaRepository<CarbonFactor, UUID> {
    Optional<CarbonFactor> findByCategory(String category);
    boolean existsByCategory(String category);
}
