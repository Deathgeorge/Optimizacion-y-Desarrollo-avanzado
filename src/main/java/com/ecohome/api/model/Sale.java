package com.ecohome.api.model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "sales")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sale {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_sale")
    private Long idSale;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_user")
    private User user;

    @Column(name = "bill_number", length = 100)
    private String billNumber;

    @Column(name = "total_bill", precision = 12, scale = 2)
    private BigDecimal totalBill;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}