-- Schéma PostgreSQL optimisé pour la gestion clients / véhicules / réservations
-- Inclut : normalisation, contraintes, index, fonctions d'assignation et protection contre chevauchement


-- Tables de référence (noms en français)
CREATE TABLE IF NOT EXISTS statuts_reservation (nom TEXT PRIMARY KEY);
CREATE TABLE IF NOT EXISTS types_reservation (nom TEXT PRIMARY KEY);
CREATE TABLE IF NOT EXISTS statuts_vehicule (nom TEXT PRIMARY KEY);
CREATE TABLE IF NOT EXISTS statuts_affectation (nom TEXT PRIMARY KEY);

-- Valeurs initiales des tables de référence
INSERT INTO statuts_reservation(nom) VALUES ('en_attente'), ('confirmee'), ('annulee'), ('terminee') ON CONFLICT (nom) DO NOTHING;
INSERT INTO types_reservation(nom) VALUES ('prise_aeroport'), ('depose_aeroport'), ('excursion'), ('transfert') ON CONFLICT (nom) DO NOTHING;
INSERT INTO statuts_vehicule(nom) VALUES ('disponible'), ('attribue'), ('en_service'), ('maintenance'), ('hors_service') ON CONFLICT (nom) DO NOTHING;
INSERT INTO statuts_affectation(nom) VALUES ('attribue'), ('demarre'), ('terminee'), ('annulee') ON CONFLICT (nom) DO NOTHING;   

-- Clients
CREATE TABLE IF NOT EXISTS clients (
    id SERIAL PRIMARY KEY,
    prenom TEXT NOT NULL,
    nom TEXT NOT NULL,
    email TEXT UNIQUE,
    telephone TEXT,
    adresse VARCHAR(255),
    cree_le TIMESTAMP DEFAULT LOCALTIMESTAMP
);

-- Types de carburant
CREATE TABLE IF NOT EXISTS types_carburant (
    id SERIAL PRIMARY KEY,
    nom TEXT NOT NULL UNIQUE
);

-- Hôtels
CREATE TABLE IF NOT EXISTS hotels (
    id SERIAL PRIMARY KEY,
    nom TEXT NOT NULL,
    adresse TEXT,
    telephone TEXT,
    email TEXT,
    cree_le TIMESTAMP DEFAULT LOCALTIMESTAMP
);

-- Véhicules
CREATE TABLE IF NOT EXISTS vehicules (
    id SERIAL PRIMARY KEY,
    immatriculation TEXT UNIQUE,
    nom TEXT,
    marque TEXT,
    modele TEXT,
    annee SMALLINT,
    places SMALLINT NOT NULL CHECK (places > 0),
    type_carburant_id INT REFERENCES types_carburant(id) ON DELETE SET NULL,
    kilometrage BIGINT NOT NULL DEFAULT 0,
    statut TEXT NOT NULL DEFAULT 'disponible' REFERENCES statuts_vehicule(nom),
    cree_le TIMESTAMP DEFAULT LOCALTIMESTAMP,
    modifie_le TIMESTAMP DEFAULT LOCALTIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_vehicules_statut ON vehicules(statut);
CREATE INDEX IF NOT EXISTS idx_vehicules_type_carburant ON vehicules(type_carburant_id);

-- Réservations
CREATE TABLE IF NOT EXISTS reservations (
    id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    places_requises SMALLINT NOT NULL CHECK (places_requises > 0),
    debut_ts TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP,
    fin_ts TIMESTAMP NOT NULL DEFAULT (LOCALTIMESTAMP + INTERVAL '1 hour'),
    hotel_depart_id INT REFERENCES hotels(id) ON DELETE SET NULL,
    hotel_arrivee_id INT REFERENCES hotels(id) ON DELETE SET NULL,
    type_reservation TEXT NOT NULL DEFAULT 'transfert' REFERENCES types_reservation(nom),
    statut TEXT NOT NULL DEFAULT 'en_attente' REFERENCES statuts_reservation(nom),
    cree_le TIMESTAMP DEFAULT LOCALTIMESTAMP,
    CHECK (fin_ts > debut_ts)
);

CREATE INDEX IF NOT EXISTS idx_reservations_start_end ON reservations(debut_ts, fin_ts);
CREATE INDEX IF NOT EXISTS idx_reservations_client ON reservations(client_id);

-- Regroupement des réservations (pour optimisation de trajets)
CREATE TABLE IF NOT EXISTS groupes_reservations (
    id SERIAL PRIMARY KEY,
    nom TEXT,
    cree_le TIMESTAMP DEFAULT LOCALTIMESTAMP
);

CREATE TABLE IF NOT EXISTS membres_groupes_reservations (
    groupe_id INT NOT NULL REFERENCES groupes_reservations(id) ON DELETE CASCADE,
    reservation_id INT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    PRIMARY KEY (groupe_id, reservation_id)
);

-- Affectations véhicules <-> réservations
-- On utilise une colonne 'trajet' (tsrange) construite à partir de 'debut_trajet'/'fin_trajet' (timestamp local) pour protéger contre chevauchements via une contrainte EXCLUDE
CREATE TABLE IF NOT EXISTS affectations_vehicules (
    id SERIAL PRIMARY KEY,
    reservation_id INT NOT NULL UNIQUE REFERENCES reservations(id) ON DELETE CASCADE,
    vehicule_id INT NOT NULL REFERENCES vehicules(id) ON DELETE RESTRICT,
    attribue_par TEXT,
    attribue_le TIMESTAMP DEFAULT LOCALTIMESTAMP,
    statut TEXT NOT NULL DEFAULT 'attribue' REFERENCES statuts_affectation(nom),
    debut_trajet TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP,
    fin_trajet TIMESTAMP NOT NULL DEFAULT (LOCALTIMESTAMP + INTERVAL '1 hour'),
    CHECK (fin_trajet > debut_trajet),
    cree_le TIMESTAMP DEFAULT LOCALTIMESTAMP
);


-- Paramètres globaux (clé/valeur)
CREATE TABLE IF NOT EXISTS parametres (
    cle TEXT PRIMARY KEY,
    valeur  VARCHAR(255) NOT NULL,
    description TEXT
);

-- Exemple de paramètres par défaut
INSERT INTO parametres(cle, valeur, description)
VALUES
('vitesse_vehicule_kmh', '20', 'Vitesse de référence en km/h'),
('temps_attente_minutes', '30', 'Temps d attente par défaut en minutes')
ON CONFLICT (cle) DO NOTHING;

