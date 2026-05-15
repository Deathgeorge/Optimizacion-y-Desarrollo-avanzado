package com.ecohome.api.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecohome.api.model.HistoricalChat;

import java.util.List;
import java.util.Optional;

@Repository
public interface HistoricalChatsRepository extends JpaRepository<HistoricalChat, Long> {
    
    HistoricalChat save(HistoricalChat historicalChat); 
    Optional<HistoricalChat> findById(Long id);
    List<HistoricalChat> findTop10ByOrderByCreatedAtDesc();
    void deleteById(Long id);
}
