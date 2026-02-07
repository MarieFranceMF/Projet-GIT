package com.itu.gestionProjet.service;

import com.itu.gestionProjet.model.ApiResponse;
import com.itu.gestionProjet.model.Reservation;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
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
        // Ajouter le support pour text/plain avec JSON
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        converter.setSupportedMediaTypes(List.of(
            org.springframework.http.MediaType.APPLICATION_JSON,
            org.springframework.http.MediaType.TEXT_PLAIN
        ));
        restTemplate.getMessageConverters().add(0, converter);
    }

    /**
     * Récupère toutes les réservations depuis l'API du back-office
     */
    public List<Reservation> getAllReservations() {
        try {
            String url = backofficeApiUrl + "/reservations";
            ResponseEntity<ApiResponse> response = restTemplate.getForEntity(url, ApiResponse.class);
            
            ApiResponse apiResponse = response.getBody();
            if (apiResponse != null && "success".equals(apiResponse.getStatus()) 
                    && apiResponse.getData() != null 
                    && apiResponse.getData().getModel() != null) {
                List<Reservation> reservations = apiResponse.getData().getModel().getReservations();
                return reservations != null ? reservations : Collections.emptyList();
            }
            return Collections.emptyList();
        } catch (Exception e) {
            System.err.println("Erreur lors de l'appel API: " + e.getMessage());
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    /**
     * Recherche les réservations par date depuis l'API du back-office
     */
    public List<Reservation> searchByDate(LocalDate date) {
        try {
            String url = backofficeApiUrl + "/reservations/search?date=" + date.toString();
            ResponseEntity<ApiResponse> response = restTemplate.getForEntity(url, ApiResponse.class);
            
            ApiResponse apiResponse = response.getBody();
            if (apiResponse != null && "success".equals(apiResponse.getStatus()) 
                    && apiResponse.getData() != null 
                    && apiResponse.getData().getModel() != null) {
                List<Reservation> reservations = apiResponse.getData().getModel().getReservations();
                return reservations != null ? reservations : Collections.emptyList();
            }
            return Collections.emptyList();
        } catch (Exception e) {
            System.err.println("Erreur lors de la recherche par date: " + e.getMessage());
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    /**
     * Récupère une réservation par son ID depuis l'API du back-office
     */
    public Reservation getReservationById(Long id) {
        try {
            String url = backofficeApiUrl + "/reservations/" + id;
            ResponseEntity<ApiResponse> response = restTemplate.getForEntity(url, ApiResponse.class);
            
            ApiResponse apiResponse = response.getBody();
            if (apiResponse != null && "success".equals(apiResponse.getStatus()) 
                    && apiResponse.getData() != null 
                    && apiResponse.getData().getModel() != null) {
                List<Reservation> reservations = apiResponse.getData().getModel().getReservations();
                if (reservations != null && !reservations.isEmpty()) {
                    return reservations.get(0);
                }
            }
            return null;
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération de la réservation: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
