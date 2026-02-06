package com.itu.gestionProjet.service;

import com.itu.gestionProjet.model.Reservation;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

@Service
public class ReservationService {

    private final RestTemplate restTemplate;
    
    @Value("${backoffice.api.url}")
    private String backofficeApiUrl;

    public ReservationService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    /**
     * Récupère toutes les réservations depuis l'API du back-office
     */
    public List<Reservation> getAllReservations() {
        try {
            String url = backofficeApiUrl + "/reservations";
            ResponseEntity<List<Reservation>> response = restTemplate.exchange(
                url,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Reservation>>() {}
            );
            return response.getBody() != null ? response.getBody() : Collections.emptyList();
        } catch (Exception e) {
            System.err.println("Erreur lors de l'appel API: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * Recherche les réservations par date depuis l'API du back-office
     */
    public List<Reservation> searchByDate(LocalDate date) {
        try {
            String url = backofficeApiUrl + "/reservations/search?date=" + date.toString();
            ResponseEntity<List<Reservation>> response = restTemplate.exchange(
                url,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Reservation>>() {}
            );
            return response.getBody() != null ? response.getBody() : Collections.emptyList();
        } catch (Exception e) {
            System.err.println("Erreur lors de la recherche par date: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * Récupère une réservation par son ID depuis l'API du back-office
     */
    public Reservation getReservationById(Long id) {
        try {
            String url = backofficeApiUrl + "/reservations/" + id;
            return restTemplate.getForObject(url, Reservation.class);
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération de la réservation: " + e.getMessage());
            return null;
        }
    }
}
