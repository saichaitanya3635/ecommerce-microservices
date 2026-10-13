package com.ecom.product.repository;

import com.ecom.product.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;

// Ee okka line tho save, findAll, findById, delete anni free ga vastayi!
public interface ProductRepository extends JpaRepository<Product, Long> {
}