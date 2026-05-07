package com.ecohome.api.controller;

import org.springframework.web.bind.annotation.RestController;

import com.ecohome.api.dto.ProductRequest;
import com.ecohome.api.model.Product;
import com.ecohome.api.model.ProductStatus;
import com.ecohome.api.repository.ProductRepository;

import lombok.RequiredArgsConstructor;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;


@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class ProductController {

    private final ProductRepository productRepository;
    
    @GetMapping("/v1/products")
    public ResponseEntity<List<Product>> getProducts() {
        
        return ResponseEntity.ok(productRepository.findAll());
    }

   @GetMapping("/v1/products/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        return ResponseEntity.ok(productRepository.findById(id).orElse(null));
    }   

    @PreAuthorize("hasAuthority('Admin')")
    @PostMapping("/v1/products")
    public ResponseEntity<Product> createProduct(@RequestBody ProductRequest product) {
        Product newProduct = new Product();
        newProduct.setName(product.getName());
        newProduct.setStatus(ProductStatus.available);
        newProduct.setPrice(product.getPrice());
        newProduct.setStockQuantity(product.getStockQuantity());
        newProduct.setCreatedAt(java.time.LocalDateTime.now());

        return ResponseEntity.ok(productRepository.save(newProduct));
    }
    
    @PreAuthorize("hasAuthority('Admin')")
    @PutMapping("/v1/products/{id}")
    public ResponseEntity<Product> updateProduct(@RequestBody ProductRequest product, @PathVariable Long id) {
        Product existingProduct = productRepository.findById(id).orElse(null);
        if (existingProduct == null) {
            return ResponseEntity.notFound().build();
        }

        existingProduct.setName(product.getName());
        existingProduct.setPrice(product.getPrice());
        existingProduct.setStockQuantity(product.getStockQuantity());
        existingProduct.setUpdatedAt(java.time.LocalDateTime.now());

        return ResponseEntity.ok(productRepository.save(existingProduct));
    }   

    @PreAuthorize("hasAuthority('Admin')")
    @PatchMapping("/v1/products/{id}")
    public ResponseEntity<Product> patchProduct(@RequestBody String stockQuantity, @PathVariable  Long id) {
        try {
            Product existingProduct = productRepository.findById(id).orElse(null);
            Integer newQuantity = Integer.parseInt(stockQuantity);
            if (existingProduct == null) {
                return ResponseEntity.notFound().build();
            }
            existingProduct.setStockQuantity(newQuantity);
            return ResponseEntity.ok(productRepository.save(existingProduct));

        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PreAuthorize("hasAuthority('Admin')")
    @DeleteMapping("/v1/products/{id}")
    public ResponseEntity<Void> deleteProduct(Long id) {
        productRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }   
        
}
