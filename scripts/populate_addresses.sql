INSERT INTO addresses (address_id, user_id, street_address, city, province, postal_code, is_default) VALUES (1, 1, '123 Main Street', 'Manila', 'Metro Manila', 1000, 1);
INSERT INTO addresses (address_id, user_id, street_address, city, province, postal_code, is_default) VALUES (2, 2, '456 Oak Avenue', 'Quezon', 'Metro Manila', 1100, 1);
INSERT INTO addresses (address_id, user_id, street_address, city, province, postal_code, is_default) VALUES (3, 3, '789 Pine Road', 'Makati', 'Metro Manila', 1200, 1);
INSERT INTO addresses (address_id, user_id, street_address, city, province, postal_code, is_default) VALUES (4, 4, '27 Business Center Ave', 'Marikina', 'Metro Manila', 1226, 1);
INSERT INTO addresses (address_id, user_id, street_address, city, province, postal_code, is_default) VALUES (5, 5, '541 Sunset Boulevard', 'Marilao', 'Bulacan', 6000, 1);
INSERT INTO addresses (address_id, user_id, street_address, city, province, postal_code, is_default) VALUES (6, 6, '82 Mountain View', 'Antipolo', 'Rizal', 1870, 1);
INSERT INTO addresses (address_id, user_id, street_address, city, province, postal_code, is_default) VALUES (7, 7, '25 Harbor Road', 'San Mateo', 'Rizal', 1850, 1);

ALTER SEQUENCE seq_address_id INCREMENT BY 7;