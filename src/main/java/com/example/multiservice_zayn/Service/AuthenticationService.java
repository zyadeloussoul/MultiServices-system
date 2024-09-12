package com.example.multiservice_zayn.Service;

import com.example.multiservice_zayn.Model.User;
import com.example.multiservice_zayn.Repository.UserRepo;
import com.example.multiservice_zayn.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.Map;



@Service
public class AuthenticationService {

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User register(User user) {
        if (userRepo.findByEmail(user.getEmail()) != null) {
            throw new RuntimeException("User already exists");
        }

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepo.save(user);
    }

    public Map<String, String> login(String email, String password) {
        User user = userRepo.findByEmail(email);
        if (user == null || !passwordEncoder.matches(password, user.getPassword())) {
            throw new RuntimeException("Invalid credentials");
        }

        String accessToken = jwtUtil.generateAccessToken(user.getEmail(), user.getRole());
        String refreshToken = jwtUtil.generateRefreshToken(user.getEmail());

        Map<String, String> tokens = new HashMap<>();
        tokens.put("accessToken", accessToken);
        tokens.put("refreshToken", refreshToken);

        return tokens;
    }

    public User getUserByEmail(String email) {
        return userRepo.findByEmail(email);
    }
    public User getUserName(String Username) {
        return userRepo.findByEmail(Username);
    }

    public User getUserById(String id) {
        return userRepo.findById(id).orElse(null);
    }

private String encryptPassword(String password) {
        // TODO: Implémenter le cryptage réel du mot de passe
        return password;
    }

    private boolean checkPassword(String inputPassword, String storedPassword) {
        // TODO: Implémenter la vérification réelle du mot de passe
        return inputPassword.equals(storedPassword);
    }
}
