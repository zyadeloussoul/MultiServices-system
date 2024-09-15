package com.example.multiservice_zayn.Controller;

import com.example.multiservice_zayn.Model.User;
import com.example.multiservice_zayn.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.nio.file.AccessDeniedException;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser(Authentication authentication) {
        if (authentication == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not authenticated");
        }

        String username = authentication.getName();
        User user = userService.getUserByUsername(username);
        if (user != null) {
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }
    }


    @GetMapping("/{id}")
    public User getUserById(@PathVariable String id) throws AccessDeniedException {
        // Get the currently authenticated user
        User currentUser = userService.getCurrentUser();

        if (currentUser == null) {
            throw new AccessDeniedException("Utilisateur non trouvé.");
        }

        // Retrieve the requested user
        User requestedUser = userService.getUserById(id);

        if (requestedUser == null) {
            throw new AccessDeniedException("Utilisateur non trouvé.");
        }

        // Verify that the requested user ID matches the current user's ID
        if (!currentUser.getId().equals(requestedUser.getId())) {
            throw new AccessDeniedException("Vous ne pouvez pas accéder aux données de cet utilisateur.");
        }

        return requestedUser;
    }
}
