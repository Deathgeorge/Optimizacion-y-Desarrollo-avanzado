package com.ecohome.api.controller;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.JWTVerifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.corundumstudio.socketio.SocketIOServer;
import com.ecohome.api.model.HistoricalChat;
import com.ecohome.api.repository.HistoricalChatsRepository;
import com.ecohome.api.repository.UserRepository;
import com.ecohome.api.service.UsuarioService;

@Component
public class SocketManager implements CommandLineRunner {

    @Value("${jwt.secret}")
    private String jwtSecret;

    private final HistoricalChatsRepository historicalChatsRepository;
    private final UserRepository userRepository;
    private final SocketIOServer server;

    public SocketManager(SocketIOServer server, HistoricalChatsRepository historicalChatsRepository, UserRepository userRepository) {
        this.historicalChatsRepository = historicalChatsRepository;
this.userRepository = userRepository;
this.server = server;
    }

    @Override
    public void run(String... args) throws Exception {
        // Evento de conexión
        server.addConnectListener(client -> {
            System.out.println("Cliente intentando conectar: " + client.getSessionId());
            
            // Opción 1: Si el cliente envía el token en los parámetros de la URL (ej: ?token=ey...)
            String tokenParam = client.getHandshakeData().getSingleUrlParam("token");
            
            // Opción 2: Si el cliente envía el token en la cabecera HTTP (ej: Authorization: Bearer ey...)
            String authHeader = client.getHandshakeData().getHttpHeaders().get("Authorization");
            
            String token = null;
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                token = authHeader.substring(7);
            } else if (tokenParam != null && !tokenParam.isEmpty()) {
                token = tokenParam;
            }

            if (token == null) {
                System.out.println("❌ Conexión de socket rechazada: Token no proporcionado");
                client.disconnect();
                return;
            }

            try {
                Algorithm algorithm = Algorithm.HMAC256(jwtSecret);
                JWTVerifier verifier = JWT.require(algorithm).withIssuer("ecohome-api").build();
                DecodedJWT decodedJWT = verifier.verify(token);
                System.out.println("✅ Cliente autenticado con éxito. Usuario (Documento): " + decodedJWT.getSubject());
                
                // Extraemos el userId del token y lo guardamos en la sesión del socket
                Long userId = decodedJWT.getClaim("userId").asLong();
                client.set("userId", userId);
            } catch (Exception e) {
                System.out.println("❌ Conexión de socket rechazada: Token inválido - " + e.getMessage());
                client.disconnect();
            }
        });

        // Evento personalizado (ej: "enviar_mensaje")
        server.addEventListener("enviar_mensaje", ChatMessage.class, (client, data, ackSender) -> {
            // Recuperamos el userId seguro de la sesión del cliente
            Long userId = client.get("userId");
            data.setUserId(userId);

            System.out.println("Mensaje recibido del usuario " + userId + ": " + data.getContent());
            // Reenviar a todos los conectados (broadcast)
            System.out.println("Se guardará el siguiente mensaje en la base de datos: " + data.getContent());

            HistoricalChat historicalChat = new HistoricalChat();
            HistoricalChat historicalChatCreado = new HistoricalChat();
            historicalChat.setContent(data.getContent());
            historicalChat.setUser(userRepository.findById(userId).orElse(null ));
            historicalChat.setCreatedAt(java.time.LocalDateTime.now());
            historicalChatCreado = historicalChatsRepository.save(historicalChat);
            System.out.println("verificacion de prueba "+historicalChatCreado.getIdChat());
            server.getBroadcastOperations().sendEvent("nuevo_mensaje", data);
        });

        server.start();
    }

    // DTO interno para mapear la data del Socket. 
    // Puedes mover esta clase a tu paquete com.ecohome.api.dto
    public static class ChatMessage {
        private String content;
        private Long userId;

        public ChatMessage() {}

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }

        public Long getUserId() {
            return userId;
        }

        public void setUserId(Long userId) {
            this.userId = userId;
        }
    }
}
