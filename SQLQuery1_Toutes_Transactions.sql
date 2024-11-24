
/* Note importante pour les autres collaborateurs 

 Mes tests se font sur les premieres 60 miles lignes de donnees.

*/

-- Le nombre de produit distinct 41611

SELECT COUNT(DISTINCT Product) AS nombre_de_produits_distincts
FROM Toutes_Transactions;

-- Lieu de vente : 10
/*Miami, Los Angeles, Seattle, Atlanta, New York, Houston, Boston, Dallas, Chicago, San Francisco */

SELECT COUNT(DISTINCT City) AS Nombre_lieu_de_vente
FROM Toutes_Transactions;
SELECT DISTINCT City
FROM Toutes_Transactions;

-- Moyen de paiment: 4 
/*Debit Card, Cash, Mobile Payment, redit Card */

SELECT COUNT(DISTINCT Payment_Method) AS Nombre_moyen_de_paiement
FROM Toutes_Transactions;

-- Noms des moyens de paiement distincts
SELECT DISTINCT Payment_Method
FROM Toutes_Transactions;

-- categorie de clients :8

--et nombre clients par categorie

SELECT COUNT(DISTINCT Customer_Category) AS Categorie_de_client
FROM Toutes_Transactions;

SELECT Customer_Category, COUNT(*) AS Nombre_de_clients
FROM Toutes_Transactions
GROUP BY Customer_Category;
