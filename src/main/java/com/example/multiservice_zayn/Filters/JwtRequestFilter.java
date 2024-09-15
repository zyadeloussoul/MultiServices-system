package com.example.multiservice_zayn.Filters;

import com.example.multiservice_zayn.Service.CustomUserDetailsService;
import com.example.multiservice_zayn.util.JwtUtil;
import io.jsonwebtoken.Claims;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class JwtRequestFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(JwtRequestFilter.class);

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        final String authorizationHeader = request.getHeader("Authorization");

        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            String jwt = authorizationHeader.substring(7);
            logger.debug("JWT Token: {}", jwt);

            try {
                String username = jwtUtil.extractUsername(jwt);
                logger.debug("Extracted username from JWT: {}", username);

                if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                    UserDetails userDetails = userDetailsService.loadUserByUsername(username);

                    if (userDetails != null && jwtUtil.validateToken(jwt, username)) {
                        Claims claims = jwtUtil.extractAllClaims(jwt);
                        logger.debug("Token claims: {}", claims);

                        String role = claims.get("role", String.class);
                        if (role != null && !jwtUtil.isTokenExpired(jwt)) {
                            UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                                    userDetails, null, userDetails.getAuthorities());
                            auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                            SecurityContextHolder.getContext().setAuthentication(auth);
                            logger.info("Authenticated user: {} with role: {}", username, role);
                        } else {
                            logger.warn("JWT token is expired or role is invalid.");
                        }
                    } else {
                        logger.warn("Invalid JWT token for user: {}", username);
                    }
                }
            } catch (Exception e) {
                logger.error("JWT Token validation error: {}", e.getMessage(), e);
            }
        }

        chain.doFilter(request, response);
    }
}