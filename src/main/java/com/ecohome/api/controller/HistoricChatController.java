package com.ecohome.api.controller;

import com.ecohome.api.model.HistoricalChat;
import com.ecohome.api.repository.HistoricalChatsRepository;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/chats")
@RequiredArgsConstructor
public class HistoricChatController {
    
    private final HistoricalChatsRepository historicalChatsRepository;

    @GetMapping("/latest")
    public ResponseEntity<List<ChatResponseDto>> getLatestChats() {
        List<HistoricalChat> chats = historicalChatsRepository.findTop10ByOrderByCreatedAtDesc();
        
        List<ChatResponseDto> response = chats.stream().map(chat -> {
            ChatResponseDto dto = new ChatResponseDto();
            dto.setIdChat(chat.getIdChat());
            dto.setContent(chat.getContent());
            dto.setCreatedAt(chat.getCreatedAt());
            dto.setUserId(chat.getUser().getIdUser());
            dto.setUserName(chat.getUser().getName());
            return dto;
        }).collect(Collectors.toList());

        System.out.println("Entró al servicio. Chats recuperados: " + chats.size());
        return ResponseEntity.ok(response);
    }

    @Data
    public static class ChatResponseDto {
        private Long idChat;
        private String content;
        private LocalDateTime createdAt;
        private Long userId;
        private String userName;
    }
}
