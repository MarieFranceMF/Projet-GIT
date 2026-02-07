package com.itu.gestionProjet.controller;

import com.itu.gestionProjet.model.Reservation;
import com.itu.gestionProjet.service.ReservationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@Controller
@RequestMapping("/reservations")
public class ReservationController {

    private final ReservationService reservationService;

    public ReservationController(ReservationService reservationService) {
        this.reservationService = reservationService;
    }

    /**
     * Affiche la liste des réservations avec possibilité de recherche par date
     */
    @GetMapping
    public String listReservations(
            @RequestParam(value = "date", required = false) String dateStr,
            Model model) {
        
        List<Reservation> reservations;
        String searchDate = null;
        String errorMessage = null;
        
        if (dateStr != null && !dateStr.isEmpty()) {
            try {
                LocalDate date = LocalDate.parse(dateStr);
                reservations = reservationService.searchByDate(date);
                searchDate = dateStr;
                model.addAttribute("searchPerformed", true);
            } catch (DateTimeParseException e) {
                errorMessage = "Format de date invalide. Utilisez le format YYYY-MM-DD";
                reservations = reservationService.getAllReservations();
            }
        } else {
            reservations = reservationService.getAllReservations();
        }
        
        model.addAttribute("reservations", reservations);
        model.addAttribute("searchDate", searchDate);
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
