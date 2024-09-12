package com.example.multiservice_zayn.Controller;

import com.example.multiservice_zayn.Model.User;
import com.example.multiservice_zayn.Service.AuthenticationService;
import com.example.multiservice_zayn.util.JwtUtil;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthenticationController {

    @Autowired
    private AuthenticationService authenticationService;

    @Autowired
    private JwtUtil jwtUtil;
    @GetMapping("/{id}")
    public User getUserById(@PathVariable String id) {
        return authenticationService.getUserById(id);
    }

    @GetMapping("/email/{email}")
    public User getUserByEmail(@PathVariable String email) {
        return authenticationService.getUserByEmail(email);
    }
    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody @Valid User user) {
        try {
            User registeredUser = authenticationService.register(user);
            return ResponseEntity.ok("User registered successfully: " + registeredUser.getEmail());
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> login(@RequestBody LoginRequest loginRequest) {
        try {
            Map<String, String> tokens = authenticationService.login(loginRequest.getEmail(), loginRequest.getPassword());
            return ResponseEntity.ok(tokens);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Collections.singletonMap("error", e.getMessage()));
        }
    }

}
