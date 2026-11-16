-- First Create DataBase and Table That's We Can Use in Our Project

CREATE DATABASE IF NOT EXISTS ecommerce_portfolio;
USE ecommerce_portfolio;


CREATE TABLE customers (
    customer_id    INT           PRIMARY KEY,
    customer_name  VARCHAR(100)  NOT NULL,
    city           VARCHAR(50),                 -- intentionally messy (case, spaces, NULL)
    signup_date    DATE          NOT NULL
);

CREATE TABLE products (
    product_id     INT           PRIMARY KEY,
    product_name   VARCHAR(100)  NOT NULL,
    category       VARCHAR(50)   NOT NULL,
    unit_price     DECIMAL(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id       INT           PRIMARY KEY,
    customer_id    INT           NOT NULL,
    order_date     DATE          NOT NULL,
    status         VARCHAR(20)   NOT NULL,      -- Delivered / Cancelled / Returned
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id  INT           PRIMARY KEY,
    order_id       INT           NOT NULL,
    product_id     INT           NOT NULL,
    quantity       INT           NOT NULL CHECK (quantity > 0),
    unit_price     DECIMAL(10,2) NOT NULL,      -- price at time of sale
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

