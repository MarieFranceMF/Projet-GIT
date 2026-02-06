package com.itu.gestionProjet.model;

import java.time.LocalDateTime;

public class Reservation {
    
    private Long id;
    private Long clientId;
    private Integer placesRequises;
    private LocalDateTime debutTs;
    private LocalDateTime finTs;
    private Long hotelDepartId;
    private Long hotelArriveeId;
    private String typeReservation;
    private String statut;
    private LocalDateTime creeLe;
    
    // Informations supplémentaires (si retournées par l'API avec jointures)
    private String nomClient;
    private String hotelDepartNom;
    private String hotelArriveeNom;

    public Reservation() {
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getClientId() {
        return clientId;
    }

    public void setClientId(Long clientId) {
        this.clientId = clientId;
    }

    public Integer getPlacesRequises() {
        return placesRequises;
    }

    public void setPlacesRequises(Integer placesRequises) {
        this.placesRequises = placesRequises;
    }

    public LocalDateTime getDebutTs() {
        return debutTs;
    }

    public void setDebutTs(LocalDateTime debutTs) {
        this.debutTs = debutTs;
    }

    public LocalDateTime getFinTs() {
        return finTs;
    }

    public void setFinTs(LocalDateTime finTs) {
        this.finTs = finTs;
    }

    public Long getHotelDepartId() {
        return hotelDepartId;
    }

    public void setHotelDepartId(Long hotelDepartId) {
        this.hotelDepartId = hotelDepartId;
    }

    public Long getHotelArriveeId() {
        return hotelArriveeId;
    }

    public void setHotelArriveeId(Long hotelArriveeId) {
        this.hotelArriveeId = hotelArriveeId;
    }

    public String getTypeReservation() {
        return typeReservation;
    }

    public void setTypeReservation(String typeReservation) {
        this.typeReservation = typeReservation;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public LocalDateTime getCreeLe() {
        return creeLe;
    }

    public void setCreeLe(LocalDateTime creeLe) {
        this.creeLe = creeLe;
    }

    public String getNomClient() {
        return nomClient;
    }

    public void setNomClient(String nomClient) {
        this.nomClient = nomClient;
    }

    public String getHotelDepartNom() {
        return hotelDepartNom;
    }

    public void setHotelDepartNom(String hotelDepartNom) {
        this.hotelDepartNom = hotelDepartNom;
    }

    public String getHotelArriveeNom() {
        return hotelArriveeNom;
    }

    public void setHotelArriveeNom(String hotelArriveeNom) {
        this.hotelArriveeNom = hotelArriveeNom;
    }
}
