package com.itu.gestionProjet.model;

public class Hotel {
    
    private Long id;
    private String nom;

    public Hotel() {
    }

    public Hotel(Long id, String nom) {
        this.id = id;
        this.nom = nom;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}
