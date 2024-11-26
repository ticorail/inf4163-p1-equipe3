

CREATE TABLE magasin (
    id_magasin INT PRIMARY KEY not null,
    nom_magasin VARCHAR(50) NOT NULL,
    ville VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    type_magasin Varchar(50) NOT NULL
);

CREATE TABLE Promotion (
	id_promotion INT PRIMARY KEY,
	type_promtion VARCHAR(50) NOT NULL,
	descriptions TEXT,
	date_debut DATETIME NOT NULL,
	date_fin DATETIME NOT NULL
	
);

CREATE TABLE client (
	cd_client bigint not null,
	nom_client varchar(255) not null,
	categorie_client varchar(50) 

);



CREATE TABLE [transaction](
	id_transaction bigint primary key not null,
	[date] datetime not null,
	montant_total decimal( 10,2) not null,
	saison varchar(50) not null,
	produits TEXT not null,
	methode_paiement varchar(255) not null,
	promotion_appliquee varchar (255),
	FOREIGN KEY (id_magasin) REFERENCES Magasin(Id_magasin),
	FOREIGN KEY (id_client) REFERENCES Client(Id_client)
);

CREATE TABLE produit(
	id_produit int primary key not null,
	nom_produit varchar(50) not null,
	category_produit varchar(50),
	quantite_en_stock int not null,
	prix_unitaire decimal (10,2),
	[description] text
	foreign key (Id_promotion) references Promotion(Id_promotion)

);








