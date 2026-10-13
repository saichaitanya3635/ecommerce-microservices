package com.ecom.product.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.Instant;

@Entity                      // Idi database table avutundi
@Table(name = "products")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)  // ID automatic ga 1, 2, 3...
    private Long id;

    @NotBlank                // Peru empty kaakudadu
    private String name;

    private String description;

    @NotNull @Positive       // Price kachitamga undali, 0 kanna ekkuva
    private BigDecimal price;

    @NotNull @PositiveOrZero // Stock negative kaakudadu
    private Integer stock;

    private Instant createdAt = Instant.now();

    public Long getId() { return id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }
    public Instant getCreatedAt() { return createdAt; }
}