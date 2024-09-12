package com.example.multiservice_zayn.Service;

import com.example.multiservice_zayn.Model.User;
import com.example.multiservice_zayn.Repository.UserRepo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.Collections;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private static final Logger logger = LoggerFactory.getLogger(CustomUserDetailsService.class);

    @Autowired
    private UserRepo userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        try {
            logger.debug("Attempting to load user by username: {}", username);
            User user = userRepository.findByUsername(username);
            if (user == null) {
                logger.error("User not found with username: {}", username);
                throw new UsernameNotFoundException("User not found with username: " + username);
            } else {
                logger.info("User found: {}", user.getUsername());

                // Convert UserRole to GrantedAuthority
                Collection<? extends GrantedAuthority> authorities = Collections.singletonList(
                        new SimpleGrantedAuthority("ROLE_" + user.getRole().name())
                );

                return new org.springframework.security.core.userdetails.User(
                        user.getUsername(),
                        user.getPassword(),
                        authorities
                );
            }
        } catch (Exception e) {
            logger.error("Error loading user: {}", e.getMessage(), e);
            throw new UsernameNotFoundException("Error occurred while loading user", e);
        }
    }
}