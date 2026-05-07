package com.ecohome.api.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;
import java.io.Serializable;

@Embeddable
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class ProductSaleId implements Serializable {
    @Column(name = "id_sale")
    private Long idSale;

    @Column(name = "id_product")
    private Long idProduct;
}