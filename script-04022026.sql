-- ============================================
-- Script de création de base de données
-- Projet: Gestion et optimisation d'assignation 
--         de véhicules aéroport
-- Date: 04/02/2026
-- ============================================

-- Suppression des tables si elles existent (dans l'ordre des dépendances)
DROP TABLE IF EXISTS assignation_vehicule;
DROP TABLE IF EXISTS regroupement_reservation;
DROP TABLE IF EXISTS regroupement;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS vol;
DROP TABLE IF EXISTS vehicule;
DROP TABLE IF EXISTS type_carburant;
DROP TABLE IF EXISTS destination;
DROP TABLE IF EXISTS parametre;

-- ============================================
-- TABLE: type_carburant
-- Types de carburant disponibles pour les véhicules
-- ============================================
CREATE TABLE type_carburant (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    cout_par_litre DECIMAL(10, 2) NOT NULL
);

-- ============================================
-- TABLE: vehicule
-- Véhicules disponibles à l'aéroport
-- ============================================
CREATE TABLE vehicule (
    id SERIAL PRIMARY KEY,
    immatriculation VARCHAR(20) NOT NULL UNIQUE,
    marque VARCHAR(50) NOT NULL,
    modele VARCHAR(50) NOT NULL,
    capacite INT NOT NULL CHECK (capacite > 0),
    id_type_carburant INT NOT NULL,
    consommation_100km DECIMAL(5, 2) NOT NULL, -- Litres/100km
    est_disponible BOOLEAN DEFAULT TRUE,
    date_mise_en_service DATE,
    FOREIGN KEY (id_type_carburant) REFERENCES type_carburant(id)
);

-- ============================================
-- TABLE: destination
-- Destinations possibles (hôtels, lieux)
-- ============================================
CREATE TABLE destination (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    adresse VARCHAR(255),
    distance_aeroport_km DECIMAL(10, 2) NOT NULL, -- Distance depuis l'aéroport
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8)
);

-- ============================================
-- TABLE: vol
-- Informations sur les vols arrivants
-- ============================================
CREATE TABLE vol (
    id SERIAL PRIMARY KEY,
    numero_vol VARCHAR(20) NOT NULL UNIQUE,
    compagnie VARCHAR(100),
    provenance VARCHAR(100),
    date_heure_arrivee TIMESTAMP NOT NULL,
    terminal VARCHAR(10)
);

-- ============================================
-- TABLE: client
-- Passagers/Clients du service de transport
-- ============================================
CREATE TABLE client (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    telephone VARCHAR(20),
    email VARCHAR(100),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE: reservation
-- Réservations de transport par les clients
-- ============================================
CREATE TABLE reservation (
    id SERIAL PRIMARY KEY,
    reference VARCHAR(50) NOT NULL UNIQUE,
    id_client INT NOT NULL,
    id_vol INT,
    id_destination INT NOT NULL,
    nombre_passagers INT NOT NULL CHECK (nombre_passagers > 0),
    nombre_bagages INT DEFAULT 0,
    date_heure_souhaitee TIMESTAMP NOT NULL,
    statut VARCHAR(30) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'CONFIRMEE', 'ASSIGNEE', 'EN_COURS', 'TERMINEE', 'ANNULEE')),
    commentaire TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_client) REFERENCES client(id),
    FOREIGN KEY (id_vol) REFERENCES vol(id),
    FOREIGN KEY (id_destination) REFERENCES destination(id)
);

-- ============================================
-- TABLE: regroupement
-- Regroupement de réservations pour optimisation
-- (plusieurs clients vers même destination ou proche)
-- ============================================
CREATE TABLE regroupement (
    id SERIAL PRIMARY KEY,
    code_regroupement VARCHAR(50) NOT NULL UNIQUE,
    date_heure_depart TIMESTAMP NOT NULL,
    total_passagers INT NOT NULL DEFAULT 0,
    statut VARCHAR(30) DEFAULT 'EN_PREPARATION' CHECK (statut IN ('EN_PREPARATION', 'PRET', 'EN_COURS', 'TERMINE')),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE: regroupement_reservation
-- Association entre regroupements et réservations
-- ============================================
CREATE TABLE regroupement_reservation (
    id SERIAL PRIMARY KEY,
    id_regroupement INT NOT NULL,
    id_reservation INT NOT NULL,
    ordre_depot INT, -- Ordre de dépôt des passagers
    FOREIGN KEY (id_regroupement) REFERENCES regroupement(id),
    FOREIGN KEY (id_reservation) REFERENCES reservation(id),
    UNIQUE (id_regroupement, id_reservation)
);

-- ============================================
-- TABLE: assignation_vehicule
-- Assignation d'un véhicule à un regroupement
-- ============================================
CREATE TABLE assignation_vehicule (
    id SERIAL PRIMARY KEY,
    id_vehicule INT NOT NULL,
    id_regroupement INT NOT NULL,
    date_heure_assignation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_heure_depart TIMESTAMP,
    date_heure_retour TIMESTAMP,
    kilometrage_debut DECIMAL(10, 2),
    kilometrage_fin DECIMAL(10, 2),
    statut VARCHAR(30) DEFAULT 'ASSIGNEE' CHECK (statut IN ('ASSIGNEE', 'EN_ROUTE', 'TERMINEE', 'ANNULEE')),
    FOREIGN KEY (id_vehicule) REFERENCES vehicule(id),
    FOREIGN KEY (id_regroupement) REFERENCES regroupement(id)
);

-- ============================================
-- TABLE: parametre
-- Paramètres de configuration du système
-- ============================================
CREATE TABLE parametre (
    id SERIAL PRIMARY KEY,
    cle VARCHAR(50) NOT NULL UNIQUE,
    valeur VARCHAR(255) NOT NULL,
    description TEXT,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- INSERTIONS DE DONNÉES DE BASE
-- ============================================

-- Types de carburant
INSERT INTO type_carburant (libelle, cout_par_litre) VALUES
('Essence', 4500.00),
('Diesel', 4200.00),
('Electrique', 0.00),
('Hybride', 4500.00);

-- Paramètres système
INSERT INTO parametre (cle, valeur, description) VALUES
('VITESSE_MOYENNE_KMH', '20', 'Vitesse moyenne de circulation en km/h'),
('TEMPS_ATTENTE_MIN', '15', 'Temps d''attente moyen en minutes à l''aéroport'),
('MARGE_REGROUPEMENT_MIN', '30', 'Marge de temps en minutes pour regrouper des réservations'),
('DISTANCE_MAX_REGROUPEMENT_KM', '5', 'Distance maximale entre destinations pour regroupement');

-- Destinations exemples
INSERT INTO destination (nom, adresse, distance_aeroport_km) VALUES
('Hotel Carlton', 'Anosy, Antananarivo', 18.5),
('Hotel Colbert', 'Analakely, Antananarivo', 17.0),
('Hotel Ibis', 'Ankorondrano, Antananarivo', 12.0),
('Hotel Radisson', 'Ambodivona, Antananarivo', 15.0),
('Centre-ville Analakely', 'Analakely, Antananarivo', 17.5);

-- Véhicules exemples
INSERT INTO vehicule (immatriculation, marque, modele, capacite, id_type_carburant, consommation_100km, est_disponible) VALUES
('1234 TAN', 'Toyota', 'Hiace', 12, 2, 10.5, TRUE),
('5678 TAN', 'Mercedes', 'Sprinter', 15, 2, 12.0, TRUE),
('9012 TAN', 'Toyota', 'Corolla', 4, 1, 7.5, TRUE),
('3456 TAN', 'Hyundai', 'H1', 8, 2, 9.0, TRUE),
('7890 TAN', 'Toyota', 'Fortuner', 6, 2, 11.0, TRUE);

-- ============================================
-- VUES UTILES
-- ============================================

-- Vue des réservations en attente avec détails
CREATE OR REPLACE VIEW v_reservations_en_attente AS
SELECT 
    r.id,
    r.reference,
    c.nom || ' ' || c.prenom AS client,
    c.telephone,
    v.numero_vol,
    v.date_heure_arrivee,
    d.nom AS destination,
    d.distance_aeroport_km,
    r.nombre_passagers,
    r.date_heure_souhaitee,
    r.statut
FROM reservation r
JOIN client c ON r.id_client = c.id
LEFT JOIN vol v ON r.id_vol = v.id
JOIN destination d ON r.id_destination = d.id
WHERE r.statut = 'EN_ATTENTE'
ORDER BY r.date_heure_souhaitee;

-- Vue des véhicules disponibles avec capacité
CREATE OR REPLACE VIEW v_vehicules_disponibles AS
SELECT 
    v.id,
    v.immatriculation,
    v.marque || ' ' || v.modele AS vehicule,
    v.capacite,
    tc.libelle AS type_carburant,
    v.consommation_100km
FROM vehicule v
JOIN type_carburant tc ON v.id_type_carburant = tc.id
WHERE v.est_disponible = TRUE
ORDER BY v.capacite DESC;

-- ============================================
-- INDEX POUR OPTIMISATION
-- ============================================
CREATE INDEX idx_reservation_statut ON reservation(statut);
CREATE INDEX idx_reservation_date ON reservation(date_heure_souhaitee);
CREATE INDEX idx_vehicule_disponible ON vehicule(est_disponible);
CREATE INDEX idx_vol_date ON vol(date_heure_arrivee);
CREATE INDEX idx_assignation_statut ON assignation_vehicule(statut);

-- ============================================
-- FIN DU SCRIPT
-- ============================================
