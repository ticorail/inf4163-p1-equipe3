CREATE TABLE magasin (
    id_magasin INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_magasin VARCHAR(50) NOT NULL,
    ville VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    type_magasin VARCHAR(50) NOT NULL
);

CREATE TABLE promotion (
    id_promotion INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    type_promotion VARCHAR(50) NOT NULL,
    description_promotion TEXT,
    date_debut DATETIME NOT NULL,
    date_fin DATETIME NOT NULL
);

CREATE TABLE client (
    id_client BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_client VARCHAR(255) NOT NULL,
    categorie_client VARCHAR(50)
);

CREATE TABLE transaction (
    id_transaction BIGINT PRIMARY KEY NOT NULL,
    id_magasin INT NOT NULL,
    id_client BIGINT NOT NULL,
    date_transaction DATETIME NOT NULL,
    montant_total DECIMAL(10, 2) NOT NULL,
    saison VARCHAR(50) NOT NULL,
    produits TEXT NOT NULL,
    methode_paiement VARCHAR(255) NOT NULL,
    promotion_appliquee TEXT,
    FOREIGN KEY (id_magasin) REFERENCES magasin(id_magasin)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_client) REFERENCES client(id_client)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE produit (
    id_produit INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_produit VARCHAR(50) NOT NULL,
    category_produit VARCHAR(50),
    quantite_en_stock INT NOT NULL,
    prix_unitaire DECIMAL(10, 2) NOT NULL,
    description_produit TEXT,
    id_promotion INT,
    FOREIGN KEY (id_promotion) REFERENCES Promotion(id_promotion)
        ON DELETE SET NULL ON UPDATE CASCADE
);
