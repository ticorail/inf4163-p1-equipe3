/*

CREATE TABLE magasin (
    Id_magasin INT PRIMARY KEY not null,
    Nom_Magasin VARCHAR(50) NOT NULL,
    Ville VARCHAR(255) NOT NULL,
    Adresse VARCHAR(255) NOT NULL,
	Type_magasin Varchar(50) NOT NULL
);

CREATE TABLE Promotion (
	Id_promotion INT PRIMARY KEY,
	Type_promtion VARCHAR(50) NOT NULL,
	Descriptions TEXT,
	Date_debut DATETIME NOT NULL,
	Date_fin DATETIME NOT NULL
	
);

CREATE TABLE Client (
	Id_client bigint not null,
	Nom_client varchar(255) not null,
	categorie_client varchar(50) 

);

*/

CREATE TABLE [Transaction](
	Id_transaction bigint primary key not null,
	[Date] datetime not null,
	Montant_total decimal( 10,2) not null,
	saison varchar(50) not null,
	produits varchar(255)not null,
	Methode_paiement varchar(255) not null,
	promotion_appliquee varchar (255),
	FOREIGN KEY (Id_magasin) REFERENCES Magasin(Id_magasin),
	FOREIGN KEY (Id_client) REFERENCES Client(Id_client)
)

CREATE TABLE Produit(
	Id_produit int primary key not null,
	Nom_produit varchar(50) not null,
	Category_produit varchar(50),
	Quantite_en_stock int not null,
	prix_unitaire decimal (10,2),
	[Description] text
	foreign key (Id_promotion) references Promotion(Id_promotion)

)








