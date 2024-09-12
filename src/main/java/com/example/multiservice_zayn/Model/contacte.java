package com.example.multiservice_zayn.Model;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "contacte")
public class contacte {
    @Id
    private String id;
    String nom;
    String email;
    String telephone;
    String Sujet;
    String message;
    public contacte(String id,String nom, String email, String telephone, String sujet, String message) {
        this.nom = nom;
        this.email = email;
        this.telephone = telephone;
        Sujet = sujet;
        this.message = message;
    }

    public contacte(){}
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getSujet() {
        return Sujet;
    }

    public void setSujet(String sujet) {
        Sujet = sujet;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
