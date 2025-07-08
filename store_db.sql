-- Table: customers
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone_number VARCHAR(15)
);

-- Table: products
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  category VARCHAR(50) NOT NULL,
  stock INT DEFAULT 100 -- added stock to match inventory query
);

-- Table: orders
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total_amount DECIMAL(10, 2) NOT NULL,
  customer_id INT NOT NULL,
  CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
  --ON DELETE CASCADE
);

-- Table: order_items
CREATE TABLE order_items (
  item_id SERIAL PRIMARY KEY, 
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  --ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Sample customers
INSERT INTO customers (first_name, last_name, email, phone_number) VALUES
  ('John', 'Doe', 'john.doe@gmail.com', '0612345678'),
  ('Alice', 'Smith', 'alice.smith@yahoo.com', '0623456789'),
  ('David', 'Dubois', 'david.dubois@live.com', '0634567890'),
  ('Maria', 'Gonzalez', 'maria.gon@gmail.com', '0645678901'),
  ('Karim', 'Dali', 'karim.dali@outlook.com', '0656789012');

-- Sample products
INSERT INTO products (name, price, category, stock) VALUES
  ('Laptop', 899.99, 'Electronics', 20),
  ('Smartphone', 599.50, 'Electronics', 100),
  ('Office Chair', 149.90, 'Furniture', 50),
  ('Coffee Maker', 79.99, 'Appliances', 30),
  ('USB-C Cable', 15.00, 'Accessories', 100);

-- Sample orders
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
  (1, '2024-01-15', 914.99),
  (3, '2024-03-02', 79.99),
  (2, '2023-12-30', 149.90),
  (1, '2024-04-18', 599.50),
  (5, '2022-11-01', 79.99);

-- Sample order items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
  (1, 1, 1, 899.99),  -- John ordered 1 Laptop
  (1, 5, 1, 15.00),   -- John ordered 1 USB-C Cable
  (2, 4, 1, 79.99),   -- David ordered 1 Coffee Maker
  (3, 3, 1, 149.90),  -- Alice ordered 1 Office Chair
  (4, 2, 1, 599.50),  -- John ordered 1 Smartphone
  (5, 4, 1, 79.99);   -- Karim ordered 1 Coffee Maker






-- Challenge 4 : Requêtes de Sélection Simples




-- Sélectionnez tous les clients.
select * from customers ;


-- Sélectionnez les commandes passées après le 1er janvier 2024.
select * from orders where order_date > '2024-01-01';


--Sélectionnez le nom et l’e-mail des clients ayant passé une commande
SELECT 'orders:' as table_name;
SELECT c.first_name, c.last_name, c.email
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;


-- Sélectionnez les customers ayant le nom john
 select *
 from customers 
 where first_name = 'john';

 -- Sélectionnez les produits dont le prix est supérieur à 100.
select * from orders where total_amount> 100;


 --- Sélectionnez les customers ayant le nom commence par 'D'
 select * from customers where first_name like 'D%'



-- Challenge 5 : Mise à Jour de Données


--Mettez à jour le numéro de téléphone d’un client.
update customers 
set  phone_number= '0615131417'
where customer_id = 2;


--Augmentez le total_amount de toutes les commandes de 10%.
update orders 
set total_amount *= 1,1;


--Corrigez une adresse e-mail incorrecte.
 update customers 
 set email= 'david.dubois@gmail.com'
 where customer_id = 3;
 

-- select by name
 select *
 from customers 
 where first_name = 'john';


--Sélectionnez les commandes dont le montant est supérieur à 100 €.

select * from orders where total_amount> 100;

 --- Sélectionnez les customers ayant le nom commence par 'D'
 select * from customers where first_name like 'D%'



-- Challenge 6 : Mise à Jour de Données

--Mettez à jour le numéro de téléphone d’un client.
update customers 
set  phone_number= '0615131417'
where customer_id = 2;

select * from customers where customer_id = 2;

--Augmentez le total_amount de toutes les commandes de 10%.
update orders
set total_amount = total_amount * 1.1;

select * from orders ;

--Corrigez une adresse e-mail incorrecte.
 update customers 
 set email= 'david.dubois@gmail.com'
 where customer_id = 3;

 select * from customers where customer_id= 3; 
 
--Challenge 7 : Suppression de Données
--Supprimez les commandes antérieures à 2023.
select * from orders;
DELETE FROM order_items
WHERE order_id IN (
  SELECT order_id
  FROM orders
  WHERE order_date < '2023-01-01'
);

DELETE FROM orders
WHERE order_date < '2023-01-01';


--supprimez un client et toutes ses commandes associées (ON DELETE CASCADE).

ALTER TABLE order_items
DROP CONSTRAINT order_items_order_id_fkey;
-- Ajoutez la contrainte de clé étrangère avec ON DELETE CASCADE
ALTER TABLE order_items
ADD CONSTRAINT order_items_order_id_fkey
FOREIGN KEY (order_id) REFERENCES orders(order_id)
ON DELETE CASCADE;

ALTER TABLE orders
DROP CONSTRAINT fk_customer;
-- Ajoutez la contrainte de clé étrangère avec ON DELETE CASCADE
ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
ON DELETE CASCADE;
DELETE FROM customers WHERE customer_id = 4;


-- Supprimez toutes les commandes d’un client spécifique.
DELETE FROM order_items
where order_id IN (
  SELECT order_id
  FROM orders
  WHERE customer_id=1
);
DELETE FROM orders WHERE customer_id=1  ;

