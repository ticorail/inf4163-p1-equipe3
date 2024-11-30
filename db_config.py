import os
import random
import pymysql
import csv

from faker import Faker
from dotenv import load_dotenv
from datetime import timedelta

load_dotenv ()

# Connexion à la base de données
db = pymysql.connect(
    host="localhost",
    user="root",
    password=os.getenv('DB_PASSWORD'),
    database=os.getenv('DB_NAME')
)

cursor = db.cursor()

# Instance faker pour remplir les champs avec des données fictives
fake = Faker()

# Limites
MAX_TRANSACTIONS = 200000
MAX_CLIENTS = 50000
MAX_STORES = 100
MAX_PROMOTIONS = 100

promotion_ids = set()
store_ids = set()
client_ids = set()

def insert_magasin(store_type, city):
    store_query = """
        INSERT INTO magasin (nom_magasin, ville, adresse, type_magasin)
        VALUES (%s, %s, %s, %s)
    """
    address = fake.address()
    cursor.execute(store_query, (store_type, city, address, store_type))
    db.commit()

def insert_promotion(promotion_name):
    if len(promotion_ids) < MAX_PROMOTIONS:
        promo_query = """
            INSERT INTO Promotion (type_promotion, description_promotion, date_debut, date_fin)
            VALUES (%s, %s, %s, %s)
        """
        # Génération des dates de début et de fin
        start_date = fake.date_this_year()
        end_date = start_date + timedelta(days=random.randint(1, 365))
        
        cursor.execute(promo_query, (promotion_name, "", start_date, end_date))
        db.commit()
        
        cursor.execute("SELECT LAST_INSERT_ID()")
        promotion_id = cursor.fetchone()[0]
        promotion_ids.add(promotion_id)

# Insertion des client
def insert_client(customer_name, customer_category):
    client_query = """
        INSERT INTO client (nom_client, categorie_client)
        VALUES (%s, %s)
    """
    cursor.execute(client_query, (customer_name, customer_category))
    db.commit()
    
    cursor.execute("SELECT LAST_INSERT_ID()")
    client_id = cursor.fetchone()[0]
    client_ids.add(client_id)

# Insertion des produits
def insert_product(product_name):
    product_query = """
        INSERT INTO produit (nom_produit, category_produit, quantite_en_stock, prix_unitaire, description_produit)
        VALUES (%s, %s, %s, %s, %s)
    """
    category = ""
    quantity = random.randint(1, 100)
    price = round(random.uniform(1, 500), 2)
    description = ""
    cursor.execute(product_query, (product_name, category, quantity, price, description))
    db.commit()
  
    cursor.execute("SELECT LAST_INSERT_ID()")
    return cursor.fetchone()[0]

# Insertion des transactions
def insert_transaction(transaction_id, date, client_id, store_id, products, total_cost, payment_method, promotions_applied):
    transaction_query = """
        INSERT INTO transaction (id_transaction, date_transaction, id_magasin, id_client, montant_total, 
                                 saison, produits, methode_paiement, promotion_appliquee)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    season = random.choice(['Spring', 'Summer', 'Fall', 'Winter'])
    product_ids = []

    for product in products:
        # Insert chaque produit dans la table produit si il n'existe pas déjà
        cursor.execute("SELECT id_produit FROM produit WHERE nom_produit = %s", (product,))
        product_id = cursor.fetchone()
        if product_id:
            product_ids.append(product_id[0])
        else:
            insert_product(product)
            cursor.execute("SELECT LAST_INSERT_ID()")
            product_ids.append(cursor.fetchone()[0])

    product_ids_str = ', '.join(str(pid) for pid in product_ids)
    
    num_promotions = random.randint(1, 3)
    promotions_applied = random.sample(list(promotion_ids), min(num_promotions, len(promotion_ids)))
    promotions_str = ', '.join(str(pid) for pid in promotions_applied)
    
    cursor.execute(transaction_query, (transaction_id, date, store_id, client_id, total_cost, season, product_ids_str, payment_method, promotions_str))
    db.commit()

# Ouvre la table transaction
with open('transactions.csv', 'r') as file:
    csv_reader = csv.reader(file)
    next(csv_reader)  # saute la première ligne
    
    transaction_count = 0
    for row in csv_reader:
        if transaction_count >= MAX_TRANSACTIONS:
            break

        transaction_id, date, customer_name, products, total_items, total_cost, payment_method, city, store_type, discount_applied, customer_category, season, promotion = row
        
        if len(store_ids) < MAX_STORES:
            insert_magasin(store_type, city)
            cursor.execute("SELECT LAST_INSERT_ID()")
            store_id = cursor.fetchone()[0]
            store_ids.add(store_id)
        else:
            store_id = random.choice(list(store_ids)) 

        if promotion and promotion not in promotion_ids:
            insert_promotion(promotion)

        # insère uniquement les promotions qui sont dans la liste de promotions
        promotions_applied = random.sample(list(promotion_ids), min(random.randint(1, 3), len(promotion_ids)))

        if len(client_ids) < MAX_CLIENTS:
            insert_client(customer_name, customer_category)
            cursor.execute("SELECT LAST_INSERT_ID()")
            client_id = cursor.fetchone()[0]
            client_ids.add(client_id)
        else:
            if random.random() < 0.7:
                client_id = random.choice(list(client_ids))
            else:
                insert_client(customer_name, customer_category)
                cursor.execute("SELECT LAST_INSERT_ID()")
                client_id = cursor.fetchone()[0]
                client_ids.add(client_id)

        products_list = eval(products)
        insert_transaction(transaction_id, date, client_id, store_id, products_list, total_cost, payment_method, promotions_applied)
        
        transaction_count += 1

# Ferme la connexion avec la base de donnée
cursor.close()
db.close()

print("Les donées ont été insérer")
