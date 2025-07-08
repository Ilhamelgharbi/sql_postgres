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
