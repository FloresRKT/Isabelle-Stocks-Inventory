CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_type VARCHAR2(50) NOT NULL,
    name VARCHAR2(50) NOT NULL
);

CREATE TABLE inventory (
	inventory_id NUMBER PRIMARY KEY,
    product_id NUMBER NOT NULL REFERENCES products(product_id),
    color VARCHAR2(50),
    product_size NUMBER,
    price NUMBER(10,2),
    quantity NUMBER,
    sales_quantity NUMBER
);

CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    address VARCHAR2(200) NOT NULL,
    contact_number NUMBER NOT NULL
);

CREATE TABLE orders (
    order_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL REFERENCES customers(customer_id)
);