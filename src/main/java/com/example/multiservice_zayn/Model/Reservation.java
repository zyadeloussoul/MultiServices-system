package com.example.multiservice_zayn.Model;// Reservation.java

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "reservation")
public class Reservation {
    @Id
    private String id;
    private String name;
    private String email;
    private String city;
    private String date;
    private String category;

    // Category-specific fields
    private String address;
    private String area;
    private String packagingUnpacking;
    private String loadingUnloading;
    private String setup;
    private String departureAddress;
    private String arrivalAddress;

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getPackagingUnpacking() {
        return packagingUnpacking;
    }

    public void setPackagingUnpacking(String packagingUnpacking) {
        this.packagingUnpacking = packagingUnpacking;
    }

    public String getLoadingUnloading() {
        return loadingUnloading;
    }

    public void setLoadingUnloading(String loadingUnloading) {
        this.loadingUnloading = loadingUnloading;
    }

    public String getSetup() {
        return setup;
    }

    public void setSetup(String setup) {
        this.setup = setup;
    }

    public String getDepartureAddress() {
        return departureAddress;
    }

    public void setDepartureAddress(String departureAddress) {
        this.departureAddress = departureAddress;
    }

    public String getArrivalAddress() {
        return arrivalAddress;
    }

    public void setArrivalAddress(String arrivalAddress) {
        this.arrivalAddress = arrivalAddress;
    }
}
