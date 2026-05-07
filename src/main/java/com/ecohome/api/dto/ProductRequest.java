package com.ecohome.api.dto;

import java.math.BigDecimal;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ProductRequest {
    
    @NotBlank(message = "El nombre es obligatorio")
    private String name;

    private BigDecimal price;

    private Integer stockQuantity;



}
