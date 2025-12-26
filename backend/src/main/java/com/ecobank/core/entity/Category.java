package com.ecobank.core.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "categories")
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @Column(unique = true, nullable = false)
    private String name;
    
    @Column(name = "name_fr")
    private String nameFr;
    
    private String description;
    private String icon;
    private String color;
    
    @Column(name = "created_at")
    private OffsetDateTime createdAt;
}
