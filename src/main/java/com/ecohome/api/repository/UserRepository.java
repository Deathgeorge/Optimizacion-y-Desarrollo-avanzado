package com.ecohome.api.repository;

import com.ecohome.api.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByDocumentNumber(String documentNumber);
    Optional<User> findByEmail(String email);
    Boolean existsByDocumentNumber(String documentNumber);


}