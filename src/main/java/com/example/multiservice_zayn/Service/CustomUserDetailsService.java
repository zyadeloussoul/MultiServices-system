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

    private final UserRepo userRepository;

    @Autowired
    public CustomUserDetailsService(UserRepo userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        logger.debug("Tentative de chargement de l'utilisateur par email : {}", email);

        User user = userRepository.findByEmail(email);
        if (user == null) {
            logger.error("Utilisateur non trouvé avec l'email : {}", email);
            throw new UsernameNotFoundException("Utilisateur non trouvé avec l'email : " + email);
        }

        logger.info("Utilisateur trouvé : {}", user.getUsername());

        return createUserDetails(user);
    }

    private UserDetails createUserDetails(User user) {
        Collection<GrantedAuthority> authorities = Collections.singletonList(
                new SimpleGrantedAuthority("ROLE_" + user.getRole().name())
        );

        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                authorities
        );
    }
}
