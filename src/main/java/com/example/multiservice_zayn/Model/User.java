package com.example.multiservice_zayn.Model;

import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "User")
public class User {
    private String id;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    private String username;
    private String email;
    private String password;
    private UserRole role;  // Add this field

    // Getters and Setters

    public User() {

    }

    public User(String id, String username, String password, String email, UserRole role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public UserRole getRole() {
        return role;
    }

    public void setRole(UserRole role) {
        this.role = role;
    }

    public enum UserRole {
        ADMIN,
        EMPLOYEE,
        USER
    }
}
