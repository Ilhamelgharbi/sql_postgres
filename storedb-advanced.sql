--challenge 1
-- 1-Liste des commandes d'un client spécifique
select first_name , last_name,order_id  ,order_date,total_amount
from customers c join orders o on c.customer_id = o.customer_id;
--Listez les clients n’ayant passé aucune commande (jointure externe).
select first_name, last_name 
from customers c left join orders o on c.customer_id= o.customer_id
where o.order_id is null;
--3Listez tous les clients avec le nombre de commandes qu’ils ont passées.
select first_name , last_name , count(o.order_id) as number_of_orders
from customers c left join orders o on c.customer_id = o.customer_id
group by c.customer_id;

--Challenge 2 : Agrégation de Données

--1Calculez le montant total des commandes (SUM()).
select SUM(total_amount) as total_commandes
from orders;
--2 Comptez le nombre de clients (COUNT()).
   select count(*)
   from customers;
--3 Calculez le montant moyen des commandes (AVG()).
  select AVG(total_amount)
  from rders;

--Challenge 3 : Groupement de Données

--1 Montant total des commandes par client (GROUP BY customer_id).
select sum(o.total_amount)
from  orders o left join customers c on c.customer_id = o.customer_id
group by c.customer_id;

--2 Nombre de commandes par mois.
select count(*)
from orders 
where 
--3 Montant moyen des commandes par mois.
SELECT 
  TO_CHAR(order_date, 'YYYY-MM') AS month,
  COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

--4 Afficher les clients ayant un montant total de commandes supérieur à 1000 €.
SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  SUM(o.total_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING SUM(o.total_amount) > 1000;


--Challenge 4 : Sous-Requêtes

--1 Clients ayant passé au moins une commande > 200 €
SELECT *
FROM customers c
WHERE (
  SELECT SUM(o.total_amount)
  FROM orders o
  WHERE o.customer_id = c.customer_id
) > 200;

--2 Client avec le plus gros montant cumulé de commandes.
SELECT c.*, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.phone_number
ORDER BY total_spent DESC;

--3 Commandes > à la moyenne des montants de commande.
SELECT *
FROM orders
WHERE total_amount > (
  SELECT AVG(total_amount)
  FROM orders
);


--Challenge 5 : Création de Vues

--1 Créez une vue customer_orders_view (client + commandes).
CREATE OR REPLACE VIEW customer_orders_view AS
SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  c.email,
  o.order_id,
  o.order_date,
  o.total_amount
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id;


--2 Utilisez cette vue pour afficher les clients avec > 1000 € en commandes.
SELECT 
  customer_id,
  first_name,
  last_name,
  SUM(total_amount) AS total_spent
FROM customer_orders_view
GROUP BY customer_id, first_name, last_name
HAVING SUM(total_amount) > 1000;

--3 Créez une vue monthly_sales_view (ventes totales par mois).
CREATE OR REPLACE VIEW monthly_sales_view AS
SELECT 
  TO_CHAR(order_date, 'YYYY-MM') AS month,
  COUNT(*) AS total_orders,
  SUM(total_amount) AS total_sales
FROM orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;


