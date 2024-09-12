package com.example.multiservice_zayn.Model;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "service")
public class ServiceEntity {

 // Vous pouvez spécifier la stratégie de génération d'ID

    private ObjectId id;

    private String name;
    private String title;
    private String subtitle;
    private String category;
    private String description; // Correction ici : le champ doit être en minuscule
    private String image;

    // Constructeur par défaut
    public ServiceEntity() {}

    public ServiceEntity(ObjectId id, String name, String title, String subtitle, String category, String description, String image) {
        this.id = id;
        this.name = name;
        this.title = title;
        this.subtitle = subtitle;
        this.category = category;
        this.description = description;
        this.image = image;
    }

    // Getters et Setters


    public ObjectId getId() {
        return id;
    }

    public void setId(ObjectId id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description; // Correction ici
    }

    public void setDescription(String description) {
        this.description = description; // Correction ici
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
