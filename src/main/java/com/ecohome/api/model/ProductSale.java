package com.ecohome.api.model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "products_sales")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductSale {

    @EmbeddedId
    private ProductSaleId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idSale")
    @JoinColumn(name = "id_sale")
    private Sale sale;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idProduct")
    @JoinColumn(name = "id_product")
    private Product product;

    @Column(nullable = false)
    private Integer quantity;

    @Column(name = "unit_price", nullable = false, precision = 10, scale = 2)
    private BigDecimal unitPrice;
}