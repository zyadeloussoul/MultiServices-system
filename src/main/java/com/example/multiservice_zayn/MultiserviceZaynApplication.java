package com.example.multiservice_zayn;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;

@SpringBootApplication
@EntityScan(basePackages = "com.example.multiservice_zayn.Model") // Indique où trouver les entités
public class MultiserviceZaynApplication {
    public static void main(String[] args) {
        SpringApplication.run(MultiserviceZaynApplication.class, args);
    }
}

