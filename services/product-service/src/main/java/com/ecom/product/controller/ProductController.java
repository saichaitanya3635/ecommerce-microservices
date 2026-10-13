package com.ecom.product.controller;

import com.ecom.product.model.Product;
import com.ecom.product.repository.ProductRepository;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private static final Logger log = LoggerFactory.getLogger(ProductController.class);
    private final ProductRepository repository;

    public ProductController(ProductRepository repository) {
        this.repository = repository;
    }

    // GET /api/products → anni products
    @GetMapping
    public List<Product> getAll() {
        return repository.findAll();
    }

    // GET /api/products/1 → okka product (lekapothe 404)
    @GetMapping("/{id}")
    public ResponseEntity<Product> getById(@PathVariable Long id) {
        return repository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // POST /api/products → kotha product add
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Product create(@Valid @RequestBody Product product) {
        Product saved = repository.save(product);
        log.info("Product created id={} name={}", saved.getId(), saved.getName());
        return saved;
    }
}