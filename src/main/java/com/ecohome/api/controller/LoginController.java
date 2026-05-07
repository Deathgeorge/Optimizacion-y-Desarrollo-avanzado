package com.ecohome.api.controller;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.ecohome.api.dto.LoginRequest;
import com.ecohome.api.dto.SignUpRequest;
import com.ecohome.api.model.Role;
import com.ecohome.api.model.User;
import com.ecohome.api.model.UserStatus;
import com.ecohome.api.repository.RoleRepository;
import com.ecohome.api.repository.UserRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class LoginController {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    @Value("${jwt.secret}")
    private String jwtSecret;

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest loginRequest) {
        Optional<User> userOpt = userRepository.findByEmail(loginRequest.getEmail());

        if (userOpt.isEmpty()) {
            System.out.println("❌ Login fallido: No se encontró usuario con documento " + loginRequest.getEmail());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Usuario no encontrado"));
        }

        User user = userOpt.get();
        System.out.println(generarPswd(loginRequest.getPassword()));
        try {
            if (BCrypt.checkpw(loginRequest.getPassword(), user.getPassword())) {
                
                // Generar el token JWT
                Algorithm algorithm = Algorithm.HMAC256(jwtSecret);
                String token = JWT.create()
                        .withIssuer("ecohome-api")
                        .withSubject(user.getDocumentNumber())
                        .withClaim("userId", user.getIdUser())
                        .withClaim("name", user.getName())
                        .withClaim("role", user.getRole().getName()) // <-- AÑADIR ESTA LÍNEA
                        .withIssuedAt(new Date())
                        .withExpiresAt(new Date(System.currentTimeMillis() + 86400000)) // Expira en 24h
                        .sign(algorithm);

                Map<String, Object> response = new HashMap<>();
                response.put("message", "Login exitoso");
                response.put("userId", user.getIdUser());
                response.put("name", user.getName());
                response.put("token", token);
                
                System.out.println("✅ Login exitoso para el usuario: " + user.getName());
                return ResponseEntity.ok(response);
            } else {
                System.out.println("❌ Login fallido: La contraseña no coincide para el usuario " + user.getName());
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Contraseña incorrecta"));
            }
        } catch (IllegalArgumentException e) {
            // Esto ocurre si la contraseña en base de datos está en texto plano y no es un hash de BCrypt válido
            System.out.println("⚠️ Error en Hash: La contraseña en la BD no tiene formato BCrypt válido para el usuario " + user.getName());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", "La contraseña almacenada no tiene un formato válido"));
        }
    }
    
  
    public String generarPswd(String password){
        return BCrypt.hashpw(password, BCrypt.gensalt(10));
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@Valid @RequestBody SignUpRequest signUpRequest) {
        Role role = roleRepository.findByName(signUpRequest.getRole()).orElse(null);
        if (userRepository.existsByDocumentNumber(signUpRequest.getDocumentNumber()) || role==null) {
            System.out.println("❌ Registro fallido: Verifique la informacion");
            return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of("error", "Datos erroneos"));
        } else {
            User user = new User();
            user.setName(signUpRequest.getName());
            user.setDocumentNumber(signUpRequest.getDocumentNumber());
            user.setPassword(BCrypt.hashpw(signUpRequest.getPassword(), BCrypt.gensalt(10)));
            user.setRole(role);
            user.setEmail(signUpRequest.getEmail());
            user.setStatus(UserStatus.active); 
            userRepository.save(user);
            System.out.println("✅ Registro exitoso");
            return ResponseEntity.ok(Map.of("message", "Registro exitoso"));
        }
    }
}
