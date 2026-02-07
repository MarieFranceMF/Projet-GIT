package com.itu.gestionProjet.model;

import java.util.List;

/**
 * Classe wrapper pour la réponse de l'API back-office
 * Structure:
 * {
 *   "status": "success",
 *   "code": 200,
 *   "data": {
 *     "viewName": "...",
 *     "model": {
 *       "reservations": [...],
 *       "start": "",
 *       "end": ""
 *     }
 *   }
 * }
 */
public class ApiResponse {
    
    private String status;
    private int code;
    private ApiData data;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public ApiData getData() {
        return data;
    }

    public void setData(ApiData data) {
        this.data = data;
    }

    // Classe interne pour "data"
    public static class ApiData {
        private String viewName;
        private ApiModel model;

        public String getViewName() {
            return viewName;
        }

        public void setViewName(String viewName) {
            this.viewName = viewName;
        }

        public ApiModel getModel() {
            return model;
        }

        public void setModel(ApiModel model) {
            this.model = model;
        }
    }

    // Classe interne pour "model"
    public static class ApiModel {
        private List<Reservation> reservations;
        private String start;
        private String end;

        public List<Reservation> getReservations() {
            return reservations;
        }

        public void setReservations(List<Reservation> reservations) {
            this.reservations = reservations;
        }

        public String getStart() {
            return start;
        }

        public void setStart(String start) {
            this.start = start;
        }

        public String getEnd() {
            return end;
        }

        public void setEnd(String end) {
            this.end = end;
        }
    }
}
