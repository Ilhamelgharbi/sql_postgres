-- Partie 1 : Requêtes SQL basiques

-- 1. Lister tous les livres disponibles
SELECT * FROM Livre WHERE disponible = TRUE;

-- 2. Afficher les utilisateurs ayant le rôle 'bibliothecaire'
SELECT * FROM Utilisateurs WHERE role = 'bibliothecaire';

-- 3. Emprunts en retard (non retournés + date prévue < aujourd'hui)
SELECT *
FROM Emprunts
WHERE date_retour_reelle IS NULL
  AND date_retour_prevue < CURRENT_DATE;

-- 4. Nombre total d’emprunts
SELECT COUNT(*) AS total_emprunts FROM Emprunts;

-- 5. 5 derniers commentaires avec nom utilisateur et titre livre
SELECT u.nom, l.titre, c.texte, c.note
FROM Commentaires c
JOIN Utilisateurs u ON c.id_utilisateur = u.id_utilisateur
JOIN Livre l ON c.id_livre = l.id_livre
ORDER BY c.id_commentaire DESC
LIMIT 5;

-- Partie 2 : Requêtes SQL avancées

-- 1. Nombre de livres empruntés par utilisateur
SELECT u.nom, COUNT(e.id_emprunts) AS nb_emprunts
FROM Utilisateurs u
LEFT JOIN Emprunts e ON u.id_utilisateur = e.id_utilisateur
GROUP BY u.nom;

-- 2. Livres jamais empruntés
SELECT * FROM Livre l
WHERE NOT EXISTS (
  SELECT 1 FROM Emprunts e WHERE e.id_livre = l.id_livre
);

-- 3. Durée moyenne de prêt par livre
SELECT l.titre, 
       AVG(DATE_PART('day', e.date_retour_reelle - e.date_emprunt)) AS duree_moyenne
FROM Livre l
JOIN Emprunts e ON l.id_livre = e.id_livre
WHERE e.date_retour_reelle IS NOT NULL
GROUP BY l.titre;

-- 4. Les 3 livres les mieux notés
SELECT l.titre, AVG(c.note) AS moyenne_notes
FROM Livre l
JOIN Commentaires c ON l.id_livre = c.id_livre
GROUP BY l.titre
ORDER BY moyenne_notes DESC
LIMIT 3;

-- 5. Utilisateurs ayant emprunté un livre de "Science-fiction"
SELECT DISTINCT u.nom
FROM Utilisateurs u
JOIN Emprunts e ON u.id_utilisateur = e.id_utilisateur
JOIN Livre l ON e.id_livre = l.id_livre
WHERE l.categorie = 'Science-fiction';

-- Partie 3 : Mises à jour & transactions

-- 1. Mettre disponible à FALSE pour livres empruntés non retournés
UPDATE Livre
SET disponible = FALSE
WHERE id_livre IN (
  SELECT id_livre FROM Emprunts
  WHERE date_retour_reelle IS NULL
);

-- 2. Transaction pour emprunter un livre
BEGIN;
-- vérifier la disponibilité
-- remplacez 1 et 2 par l'id_utilisateur et id_livre souhaités
INSERT INTO Emprunts (id_utilisateur, id_livre, date_emprunt, date_retour_prevue)
SELECT 1, 2, CURRENT_DATE, CURRENT_DATE + INTERVAL '14 days'
WHERE EXISTS (
  SELECT 1 FROM Livre WHERE id_livre = 2 AND disponible = TRUE
);
UPDATE Livre SET disponible = FALSE WHERE id_livre = 2;
COMMIT;

-- 3. Supprimer les commentaires des utilisateurs inactifs
DELETE FROM Commentaires
WHERE id_utilisateur IN (
  SELECT u.id_utilisateur
  FROM Utilisateurs u
  LEFT JOIN Emprunts e ON u.id_utilisateur = e.id_utilisateur
  WHERE e.id_emprunts IS NULL
);

-- Partie 4 : Vues et fonctions

-- 1. Vue des emprunts actifs
CREATE OR REPLACE VIEW Vue_Emprunts_Actifs AS
SELECT * FROM Emprunts
WHERE date_retour_reelle IS NULL;

-- 2. Fonction nombre d'emprunts par utilisateur
CREATE OR REPLACE FUNCTION nb_emprunts_utilisateur(uid INT)
RETURNS INT AS $$
DECLARE
  total INT;
BEGIN
  SELECT COUNT(*) INTO total
  FROM Emprunts
  WHERE id_utilisateur = uid;
  RETURN total;
END;
$$ LANGUAGE plpgsql;
