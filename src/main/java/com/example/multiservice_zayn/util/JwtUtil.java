package com.example.multiservice_zayn.util;

import com.example.multiservice_zayn.Model.User;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.stereotype.Service;

import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Service
public class JwtUtil {

    // Base64 encoded secret key
    private static final String BASE64_SECRET_KEY = "dGlsbGJsYWNrYXZhaWxhYmxlc29mdGNvbWJpbmVpbmRlcGVuZGVudGNvbWZvcnRhYmw=";
    // Decoded secret key for signing and verification
    private static final byte[] SECRET_KEY = Base64.getDecoder().decode(BASE64_SECRET_KEY);

    private static final long ACCESS_TOKEN_EXPIRATION_TIME = 1000 * 60 * 15; // 15 minutes
    private static final long REFRESH_TOKEN_EXPIRATION_TIME = 1000 * 60 * 60 * 24 * 7; // 7 days
    private static final long ONE_HOUR_EXPIRATION_TIME = 1000 * 60 * 60; // 1 hour in milliseconds

    // Generate access token with role information
    public String generateAccessToken(String email, User.UserRole role) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", role.name());
        return createToken(claims, email, ONE_HOUR_EXPIRATION_TIME);
    }

    // Generate refresh token
    public String generateRefreshToken(String email) {
        Map<String, Object> claims = new HashMap<>();
        return createToken(claims, email, REFRESH_TOKEN_EXPIRATION_TIME);
    }

    // Create token with claims, subject, and expiration time
    public String createToken(Map<String, Object> claims, String subject, long expirationTime) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationTime))
                .signWith(SignatureAlgorithm.HS256, SECRET_KEY)
                .compact();
    }



    // Validate token based on username and expiration
    public Boolean validateToken(String token, String username) {
        final String extractedUsername = extractUsername(token);
        return (extractedUsername.equals(username) && !isTokenExpired(token));
    }


    // Extract username from token
    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    // Extract expiration date from token
    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    // Extract claims from token using a function
    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    // Extract all claims from token
    public Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(SECRET_KEY)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    // Check if token is expired
    public Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    // Get username from token
    public String getUsernameFromToken(String token) {
        return extractUsername(token);
    }

    // Refresh access token using refresh token
    public String refreshAccessToken(String refreshToken) {
        if (isTokenExpired(refreshToken)) {
            throw new IllegalArgumentException("Refresh token is expired");
        }
        String username = extractUsername(refreshToken);
        Map<String, Object> claims = extractAllClaims(refreshToken);
        return generateAccessToken(username, User.UserRole.valueOf((String) claims.get("role")));
    }
}
