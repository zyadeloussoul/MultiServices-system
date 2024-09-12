package com.example.multiservice_zayn.Controller;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;


    public class LoginRequest {
        @Email
        private String email;

        @Size(min = 6, message = "Password must be at least 6 characters")
        private String password;

        public LoginRequest(String email, String password) {
            this.email = email;
            this.password = password;
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

        // Getters and setters
    }



    // Getters and setters


