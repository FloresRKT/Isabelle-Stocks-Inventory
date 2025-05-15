-- Product Information
CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_type VARCHAR2(50) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    is_active NUMBER(1) DEFAULT 1 NOT NULL,         -- 1 for active, 0 for inactive
    CONSTRAINT chk_is_active CHECK (is_active IN (0, 1))
);

-- Product Inventory
CREATE TABLE inventory (
    inventory_id NUMBER PRIMARY KEY,
    product_id NUMBER NOT NULL,
    color VARCHAR2(50),
    product_size VARCHAR2(20),
    price NUMBER(10,2) NOT NULL,        -- Selling price
    cost_price NUMBER(10,2),            -- Initial cost, used for profit calculation
    quantity NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT fk_inventory_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT chk_price_positive CHECK (price > 0),             -- Price must be greater than 0
    CONSTRAINT chk_cost_price_positive CHECK (cost_price >= 0),  -- Cost price must be greater than or equal to 0
    CONSTRAINT chk_quantity_positive CHECK (quantity >= 0)       -- Quantity must be greater than or equal to 0
);

-- User Information. Includes all users (customers, admins, and super admin)
CREATE TABLE users (
    user_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    password VARCHAR2(100) NOT NULL,
    user_role VARCHAR2(20) NOT NULL,
    contact_number VARCHAR2(11),
    is_active NUMBER(1) DEFAULT 1 NOT NULL,
    CONSTRAINT uk_user_email UNIQUE (email),
    CONSTRAINT chk_email_format CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')),
    CONSTRAINT chk_user_role CHECK (user_role IN ('CUSTOMER', 'ADMIN', 'SUPER ADMIN'))
);

-- Client Address Information.
-- This table can store multiple shipping addresses for each customer.
CREATE TABLE addresses (
    address_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    address_type VARCHAR2(20) DEFAULT 'BILLING' NOT NULL,
    street_address VARCHAR2(100) NOT NULL,
    city VARCHAR2(50),
    region VARCHAR2(50),
    postal_code VARCHAR2(4),
    is_default NUMBER(1) DEFAULT 0 NOT NULL,
    CONSTRAINT fk_address_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT chk_address_type CHECK (address_type IN ('BILLING', 'SHIPPING')),
    CONSTRAINT chk_address_default CHECK (is_default IN (0, 1))
);

-- Customer Orders
CREATE TABLE orders (
    order_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    order_date DATE DEFAULT SYSDATE NOT NULL,
    ship_date DATE,
    status VARCHAR2(20) DEFAULT 'PENDING' NOT NULL,
    shipping_cost NUMBER(10,2) DEFAULT 0,
    total_amount NUMBER(10,2) NOT NULL,
    CONSTRAINT fk_orders_customer FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT chk_total_amount CHECK (total_amount >= 0),
    CONSTRAINT chk_order_status CHECK (status IN ('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED'))
);

-- Individual Order Items. This table contains the items in each order.
-- Each order can have multiple items, and each item can be different products.
CREATE TABLE order_items (
    order_item_id NUMBER PRIMARY KEY,
    order_id NUMBER NOT NULL,
    inventory_id NUMBER NOT NULL,
    quantity NUMBER NOT NULL,
    unit_price NUMBER(10,2) NOT NULL,
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_inventory FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),
    CONSTRAINT chk_order_quantity CHECK (quantity > 0)
);

-- Inventory Restocking
CREATE TABLE purchase_orders (
    po_id NUMBER PRIMARY KEY,
    order_date DATE DEFAULT SYSDATE NOT NULL,
    arrival_date DATE,
    status VARCHAR2(20) DEFAULT 'PENDING' NOT NULL,
    total_amount NUMBER(10,2) NOT NULL,
    CONSTRAINT chk_po_status CHECK (status IN ('PENDING', 'RECEIVED', 'CANCELLED'))
);

-- Purchase Order Items table to track inventory items being restocked
-- This table is linked to the purchase_orders table similar to how order_items is linked to the orders table.
CREATE TABLE purchase_order_items (
    po_item_id NUMBER PRIMARY KEY,
    po_id NUMBER NOT NULL,
    product_id NUMBER NOT NULL,
    quantity NUMBER NOT NULL,
    unit_cost NUMBER(10,2) NOT NULL,
    color VARCHAR2(50),
    product_size VARCHAR2(20),
    CONSTRAINT fk_po_items_po FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id),
    CONSTRAINT fk_po_items_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT chk_po_quantity CHECK (quantity > 0),
    CONSTRAINT chk_po_unit_cost CHECK (unit_cost >= 0)
);

-- Inventory History Tracking
CREATE TABLE inventory_transactions (
    transaction_id NUMBER PRIMARY KEY,
    inventory_id NUMBER NOT NULL,
    transaction_type VARCHAR2(20) NOT NULL,  -- PURCHASE, SALE, ADJUSTMENT
    quantity NUMBER NOT NULL,
    transaction_date DATE DEFAULT SYSDATE NOT NULL,
    reference_id NUMBER,                      -- Links to order_id, po_id, etc.
    notes VARCHAR2(255),
    CONSTRAINT fk_transactions_inventory FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),
    CONSTRAINT chk_transaction_type CHECK (transaction_type IN ('PURCHASE', 'SALE', 'ADJUSTMENT', 'RETURN'))
);

-- Shopping Cart Information
CREATE TABLE shopping_carts (
    cart_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    last_modified DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_cart_customer FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Individual Cart Items
CREATE TABLE cart_items (
    cart_item_id NUMBER PRIMARY KEY,
    cart_id NUMBER NOT NULL,
    inventory_id NUMBER NOT NULL,
    quantity NUMBER DEFAULT 1 NOT NULL,
    date_added DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_cart_items_cart FOREIGN KEY (cart_id) REFERENCES shopping_carts(cart_id),
    CONSTRAINT fk_cart_items_inventory FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),
    CONSTRAINT chk_cart_quantity CHECK (quantity > 0)
);

-- Create sequences for auto-incrementing IDs
CREATE SEQUENCE seq_product_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_inventory_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_order_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_order_item_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_user_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_address_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_po_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_transaction_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_cart_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_cart_item_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_po_item_id START WITH 1 INCREMENT BY 1;