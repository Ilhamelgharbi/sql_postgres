-- Challenge 1 : Création de la base de données
CREATE DATABASE store_db;

-- Challenge 2 : Création des tables avec contraintes

-- Table: customers
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
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
  stock INT DEFAULT 100
);

-- Table: orders
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total_amount DECIMAL(10, 2) NOT NULL,
  customer_id INT NOT NULL,
  CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- Table: order_items
CREATE TABLE order_items (
  item_id SERIAL PRIMARY KEY, 
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Challenge 3 : Insertion de Données

-- Clients
INSERT INTO customers (first_name, last_name, email, phone_number) VALUES
  ('John', 'Doe', 'john.doe@gmail.com', '0612345678'),
  ('Alice', 'Smith', 'alice.smith@yahoo.com', '0623456789'),
  ('David', 'Dubois', 'david.dubois@live.com', '0634567890'),
  ('Maria', 'Gonzalez', 'maria.gon@gmail.com', '0645678901'),
  ('Karim', 'Dali', 'karim.dali@outlook.com', '0656789012');

-- Produits
INSERT INTO products (name, price, category, stock) VALUES
  ('Laptop', 899.99, 'Electronics', 20),
  ('Smartphone', 599.50, 'Electronics', 100),
  ('Office Chair', 149.90, 'Furniture', 50),
  ('Coffee Maker', 79.99, 'Appliances', 30),
  ('USB-C Cable', 15.00, 'Accessories', 100);

-- Commandes
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
  (1, '2024-01-15', 914.99),
  (3, '2024-03-02', 79.99),
  (2, '2023-12-30', 149.90),
  (1, '2024-04-18', 599.50),
  (5, '2022-11-01', 79.99);

-- Détails des commandes
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
  (1, 1, 1, 899.99),
  (1, 5, 1, 15.00),
  (2, 4, 1, 79.99),
  (3, 3, 1, 149.90),
  (4, 2, 1, 599.50),
  (5, 4, 1, 79.99);

-- Challenge 4 : Sélections
-- 1. Sélectionner tous les clients
SELECT * FROM customers;
-- 2. Sélectionner tous les produits
SELECT * FROM orders WHERE order_date > '2024-01-01';
-- 3. Sélectionner les commandes d’un client spécifique
SELECT c.first_name, c.last_name, c.email FROM customers c JOIN orders o ON c.customer_id = o.customer_id;

-- Challenge 5 : Clauses WHERE
-- 1. Sélectionner les clients avec le prénom 'John'
SELECT * FROM customers WHERE first_name = 'John';
-- 2. Sélectionner les commandes avec un montant total supérieur à 100
SELECT * FROM orders WHERE total_amount > 100;
-- 3. Sélectionner les clients dont le prénom commence par 'D'
SELECT * FROM customers WHERE first_name LIKE 'D%';

-- Challenge 6 : Mise à jour
-- 1. Mettre à jour le numéro de téléphone d’un client
UPDATE customers SET phone_number = '0615131417' WHERE customer_id = 2;
-- 2. Mettre à jour le stock d’un produit
UPDATE orders SET total_amount = total_amount * 1.1;
-- 3. Mettre à jour l’email d’un client
UPDATE customers SET email = 'john.newemail@gmail.com' WHERE customer_id = 1;

-- Challenge 7 : Suppressions
-- 1. Supprimer les commandes avant 2023 (et leurs items)
DELETE FROM order_items WHERE order_id IN (SELECT order_id FROM orders WHERE order_date < '2023-01-01');
DELETE FROM orders WHERE order_date < '2023-01-01';

-- 2. Supprimer un client et toutes ses commandes liées automatiquement (déjà géré par ON DELETE CASCADE)
DELETE FROM customers WHERE customer_id = 4;

-- 3. Supprimer toutes les commandes d’un client spécifique
DELETE FROM orders WHERE customer_id = 1;
