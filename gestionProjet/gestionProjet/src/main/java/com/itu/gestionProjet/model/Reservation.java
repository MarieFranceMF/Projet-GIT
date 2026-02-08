package com.itu.gestionProjet.model;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Modèle correspondant à la structure JSON de l'API back-office:
 * {
 *   "id": 1,
 *   "clientId": "001",
 *   "placesRequises": 2,
 *   "dateheureArrive": "2026-02-06 16:21:00.0",
 *   "hotel": { "id": 1, "nom": "Hotel de la Plage" },
 *   "creeLe": "2026-02-06 16:21:13.177"
 * }
 */
public class Reservation {
    
    private Long id;
    private String clientId;
    private Integer placesRequises;
    
    @JsonProperty("dateheureArrive")
    private String dateheureArrive;
    
    private Hotel hotel;
    private String creeLe;

    public Reservation() {
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getClientId() {
        return clientId;
    }

    public void setClientId(String clientId) {
        this.clientId = clientId;
    }

    public Integer getPlacesRequises() {
        return placesRequises;
    }

    public void setPlacesRequises(Integer placesRequises) {
        this.placesRequises = placesRequises;
    }

    public String getDateheureArrive() {
        return dateheureArrive;
    }

    public void setDateheureArrive(String dateheureArrive) {
        this.dateheureArrive = dateheureArrive;
    }

    public Hotel getHotel() {
        return hotel;
    }

    public void setHotel(Hotel hotel) {
        this.hotel = hotel;
    }

    public String getCreeLe() {
        return creeLe;
    }

    public void setCreeLe(String creeLe) {
        this.creeLe = creeLe;
    }
}
