package com.example.multiservice_zayn.Model;

import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "User")
public class Employee extends User {
    private String address;
    private String position;

    public Employee(String id, String username, String password, String email, UserRole role, String address, String position) {
        super(id, username, password, email, role);
        this.address = address;
        this.position = position;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }
}
