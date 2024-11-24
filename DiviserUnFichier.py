import csv

def diviser_csv(chemin_fichier, lignes_par_fichier):
    try:
        with open(chemin_fichier, 'r', newline='', encoding='utf-8') as fichier_csv:
            lecteur = csv.reader(fichier_csv)
            en_tete = next(lecteur)

            compteur_fichier = 1
            lignes_ecrites = 0
            fichier_sortie = open(f'fichier_sortie_{compteur_fichier}.csv', 'w', newline='', encoding='utf-8')
            ecrivain = csv.writer(fichier_sortie)
            ecrivain.writerow(en_tete)

            for ligne in lecteur:
                if lignes_ecrites >= lignes_par_fichier:
                    fichier_sortie.close()
                    compteur_fichier += 1
                    lignes_ecrites = 0
                    fichier_sortie = open(f'fichier_sortie_{compteur_fichier}.csv', 'w', newline='', encoding='utf-8')
                    ecrivain = csv.writer(fichier_sortie)
                    ecrivain.writerow(en_tete)

                ecrivain.writerow(ligne)
                lignes_ecrites += 1

            fichier_sortie.close()
    except FileNotFoundError:
        print(f"Erreur : Le fichier '{chemin_fichier}' n'a pas été trouvé.")
    except Exception as e:
        print(f"Une erreur s'est produite : {e}")
chemin_fichier = 'C:\\Users\\dadso\\Downloads\\Retail_Transactions_Dataset.csv'
diviser_csv(chemin_fichier, 10000)
