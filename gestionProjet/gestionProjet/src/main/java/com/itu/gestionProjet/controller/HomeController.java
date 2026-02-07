package com.itu.gestionProjet.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @Value("${backoffice.api.url}")
    private String backofficeApiUrl;

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("message", "Bienvenue sur le Front Office - Gestion des Reservations");
        model.addAttribute("date", java.time.LocalDateTime.now());
        model.addAttribute("apiUrl", backofficeApiUrl);
        return "index";
    }

    @GetMapping("/test")
    public String test(Model model) {
        model.addAttribute("title", "Page de Test");
        model.addAttribute("description", "Le Front Office fonctionne correctement!");
        model.addAttribute("apiUrl", backofficeApiUrl);
        return "test";
    }
}
