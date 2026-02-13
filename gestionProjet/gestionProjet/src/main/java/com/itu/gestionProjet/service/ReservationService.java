package com.itu.gestionProjet.service;

import com.itu.gestionProjet.model.ApiResponse;
import com.itu.gestionProjet.model.Reservation;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.Collections;
import java.util.List;

@Service
public class ReservationService {

    private final RestTemplate restTemplate;
    
    @Value("${backoffice.api.url}")
    private String backofficeApiUrl;

    @Value("${backoffice.api.token}")
    private String backofficeApiToken;

    public ReservationService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
        // Ajouter le support pour text/plain avec JSON
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        converter.setSupportedMediaTypes(List.of(
            org.springframework.http.MediaType.APPLICATION_JSON,
            org.springframework.http.MediaType.TEXT_PLAIN,
            org.springframework.http.MediaType.APPLICATION_OCTET_STREAM
        ));
        restTemplate.getMessageConverters().add(0, converter);
    }

    /**
     * Récupère toutes les réservations depuis l'API du back-office (sans filtre de date)
     */
    public List<Reservation> getAllReservations() {
        return listByDateRange(null, null);
    }

    /**
     * Récupère les réservations entre deux dates (Timestamp) depuis l'API du back-office.
     * Si start et end sont null, récupère toutes les réservations.
     *
     * @param start date de début au format "yyyy-MM-dd HH:mm:ss" (peut être null)
     * @param end   date de fin au format "yyyy-MM-dd HH:mm:ss" (peut être null)
     * @return liste des réservations correspondantes
     */
    public List<Reservation> listByDateRange(String start, String end) {
        try {
            UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(backofficeApiUrl + "/reservations");
            builder.queryParam("token", backofficeApiToken);
            if (start != null && !start.isEmpty()) {
                builder.queryParam("start", start);
            }
            if (end != null && !end.isEmpty()) {
                builder.queryParam("end", end);
            }
            URI uri = builder.build().toUri();
            System.out.println("Appel API back-office: " + uri);

            ResponseEntity<ApiResponse> response = restTemplate.getForEntity(uri, ApiResponse.class);
            
            ApiResponse apiResponse = response.getBody();
            if (apiResponse != null && "success".equals(apiResponse.getStatus()) 
                    && apiResponse.getData() != null 
                    && apiResponse.getData().getModel() != null) {
                // Vérifier si le back-office a renvoyé une erreur (ex: token invalide)
                String error = apiResponse.getData().getModel().getError();
                if (error != null && !error.isEmpty()) {
                    throw new RuntimeException(error);
                }
                List<Reservation> reservations = apiResponse.getData().getModel().getReservations();
                return reservations != null ? reservations : Collections.emptyList();
            }
            return Collections.emptyList();
        } catch (RuntimeException e) {
            throw e;
        } catch (Exception e) {
            System.err.println("Erreur lors de l'appel API: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Impossible de contacter le back-office: " + e.getMessage());
        }
    }

    /**
     * Récupère une réservation par son ID depuis l'API du back-office
     */
    public Reservation getReservationById(Long id) {
        try {
            URI uri = UriComponentsBuilder.fromHttpUrl(backofficeApiUrl + "/reservations/" + id)
                    .queryParam("token", backofficeApiToken)
                    .build().toUri();
            ResponseEntity<ApiResponse> response = restTemplate.getForEntity(uri, ApiResponse.class);
            
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
