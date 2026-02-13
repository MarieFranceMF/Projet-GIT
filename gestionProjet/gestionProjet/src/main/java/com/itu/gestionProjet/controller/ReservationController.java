package com.itu.gestionProjet.controller;

import com.itu.gestionProjet.model.Reservation;
import com.itu.gestionProjet.service.ReservationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/reservations")
public class ReservationController {

    private final ReservationService reservationService;
    private static final DateTimeFormatter TIMESTAMP_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public ReservationController(ReservationService reservationService) {
        this.reservationService = reservationService;
    }

    /**
     * Affiche la liste des réservations avec possibilité de recherche par plage de dates (Timestamp)
     * Les paramètres start et end sont au format "yyyy-MM-ddTHH:mm" (datetime-local HTML5)
     */
    @GetMapping
    public String listReservations(
            @RequestParam(value = "start", required = false) String startStr,
            @RequestParam(value = "end", required = false) String endStr,
            Model model) {
        
        List<Reservation> reservations;
        String errorMessage = null;
        String startValue = startStr != null ? startStr : "";
        String endValue = endStr != null ? endStr : "";
        boolean searchPerformed = false;
        
        // Convertir les valeurs datetime-local (yyyy-MM-ddTHH:mm) en Timestamp (yyyy-MM-dd HH:mm:ss)
        String startTimestamp = null;
        String endTimestamp = null;
        
        if ((startStr != null && !startStr.isEmpty()) || (endStr != null && !endStr.isEmpty())) {
            try {
                if (startStr != null && !startStr.isEmpty()) {
                    LocalDateTime startDt = LocalDateTime.parse(startStr);
                    startTimestamp = startDt.format(TIMESTAMP_FMT);
                }
                if (endStr != null && !endStr.isEmpty()) {
                    LocalDateTime endDt = LocalDateTime.parse(endStr);
                    endTimestamp = endDt.format(TIMESTAMP_FMT);
                }
                searchPerformed = true;
            } catch (DateTimeParseException e) {
                errorMessage = "Format de date invalide. Utilisez le sélecteur de date.";
            }
        }
        
        if (errorMessage == null) {
            try {
                reservations = reservationService.listByDateRange(startTimestamp, endTimestamp);
            } catch (RuntimeException e) {
                errorMessage = e.getMessage();
                reservations = Collections.emptyList();
            }
        } else {
            reservations = Collections.emptyList();
        }
        
        model.addAttribute("reservations", reservations);
        model.addAttribute("startValue", startValue);
        model.addAttribute("endValue", endValue);
        model.addAttribute("searchPerformed", searchPerformed);
        model.addAttribute("errorMessage", errorMessage);
        model.addAttribute("totalCount", reservations.size());
        
        return "reservations/list";
    }

    /**
     * Affiche les détails d'une réservation
     */
    @GetMapping("/details")
    public String showDetails(@RequestParam("id") Long id, Model model) {
        Reservation reservation = reservationService.getReservationById(id);
        
        if (reservation == null) {
            model.addAttribute("errorMessage", "Réservation non trouvée");
            return "reservations/list";
        }
        
        model.addAttribute("reservation", reservation);
        return "reservations/details";
    }
}
