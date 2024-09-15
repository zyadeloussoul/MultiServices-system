package com.example.multiservice_zayn.Service;

import com.example.multiservice_zayn.Model.User;
import com.example.multiservice_zayn.Repository.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepo userRepo;

    public User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !(authentication.getPrincipal() instanceof UserDetails)) {
            return null;
        }

        String username = ((UserDetails) authentication.getPrincipal()).getUsername();
        return userRepo.findByUsername(username);
    }

    public User getUserById(String id) {
        return userRepo.findById(id).orElse(null);
    }

    public User getUserByUsername(String username) {
        return userRepo.findByUsername(username);
    }


}
