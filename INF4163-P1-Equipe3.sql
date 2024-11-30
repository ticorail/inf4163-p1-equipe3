CREATE DATABASE uqo_projet_sql_1
    DEFAULT CHARACTER SET = 'utf8mb4';

CREATE TABLE ToutesTransactions (
    Transaction_ID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Date DATETIME NOT NULL,
    Customer_Name VARCHAR(255) NOT NULL,
    Product TEXT NOT NULL,
    Total_Items INT NOT NULL,
    Total_Cost DECIMAL(10, 2) NOT NULL,
    Payment_Method VARCHAR(50) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Store_Type VARCHAR(100) NOT NULL,
    Discount_Applied VARCHAR(5) NOT NULL,
    Customer_Category VARCHAR(50) NOT NULL,
    Season VARCHAR(20) NOT NULL,
    Promotion VARCHAR(255)
);

-- Nombre de client par catégorie
SELECT Customer_Category, COUNT(*) AS customer_count
FROM ToutesTransactions
GROUP BY Customer_Category;

--Nombre de produis
WITH CleanedProducts AS (
    SELECT
        TRIM(BOTH ' ' FROM REGEXP_REPLACE(Product, '[\\[\\]\']', '')) AS CleanedProduct
    FROM ToutesTransactions
),
ProductList AS (
    SELECT
        TRIM(BOTH ' ' FROM SUBSTRING_INDEX(SUBSTRING_INDEX(CleanedProduct, ',', n.n), ',', -1)) AS product
    FROM CleanedProducts
    CROSS JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) n
    WHERE CHAR_LENGTH(CleanedProduct) - CHAR_LENGTH(REPLACE(CleanedProduct, ',', '')) >= n.n - 1
)
SELECT product, COUNT(*) AS product_count
FROM ProductList
GROUP BY product
ORDER BY product_count DESC;

-- Lieu de vente
SELECT DISTINCT City
FROM ToutesTransactions;

-- Mode de paiement
SELECT DISTINCT Payment_Method
FROM ToutesTransactions;

-- Création des tables
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

-- Création d'un nouveau client qui effectue une transaction

START TRANSACTION;

-- Insertion du nouveau client
INSERT INTO client (nom_client, categorie_client) 
VALUES ('Jean Mathieu dela franchise', 'Nouveau');
 
SET @new_client_id = LAST_INSERT_ID();

-- Création de la nouvelle transaction
INSERT INTO transaction (
    id_magasin, 
    id_client, 
    date_transaction, 
    montant_total, 
    saison, 
    produits, 
    methode_paiement
) VALUES (
    1, 
    @new_client_id, 
    NOW(), 
    250.50, 
    'Printemps', 
    '1,2,3', 
    'Carte Bancaire'
);

-- Mis à jour du stock des produits
UPDATE produit 
SET quantite_en_stock = quantite_en_stock - 1 
WHERE id_produit IN (1, 2, 3);

COMMIT;
SELECT 'Création client réussie' AS result;


-- Création d'un nouveaux magasin

START TRANSACTION;

-- Création du nouveau magasin
INSERT INTO magasin (nom_magasin, ville, adresse, type_magasin)
VALUES ('George Weya Centre-Ville', 'Gatineau', '12 Rue Principale', 'Luxe');

-- Récupération de l'ID du nouveau magasin
SET @new_store_id = LAST_INSERT_ID();

COMMIT;

