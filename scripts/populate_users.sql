INSERT INTO users (user_id, first_name, last_name, email, password, user_role, contact_number, is_active) VALUES (1, 'John', 'Doe', 'john.doe@example.com', 'password123hash', 'CUSTOMER', 09123456789, 1);
INSERT INTO users (user_id, first_name, last_name, email, password, user_role, contact_number, is_active) VALUES (2, 'Sarah', 'Johnson', 'sarah.j@example.com', 'securepass456hash', 'CUSTOMER', 09234567890, 1);
INSERT INTO users (user_id, first_name, last_name, email, password, user_role, contact_number, is_active) VALUES (3, 'Michael', 'Smith', 'msmith@example.com', 'msmith2025hash', 'CUSTOMER', 09345678901, 1);
INSERT INTO users (user_id, first_name, last_name, email, password, user_role, contact_number, is_active) VALUES (4, 'Jessica', 'Williams', 'jwill@example.com', 'jesspass789hash', 'CUSTOMER', 09456789012, 1);
INSERT INTO users (user_id, first_name, last_name, email, password, user_role, contact_number, is_active) VALUES (5, 'David', 'Brown', 'dbrown@example.com', 'browndb2025hash', 'CUSTOMER', 09567890123, 1);
INSERT INTO users (user_id, first_name, last_name, email, password, user_role, contact_number, is_active) VALUES (6, 'Jennifer', 'Garcia', 'jennifer.admin@example.com', 'admin_secure_hash', 'ADMIN', 09678901234, 1);
INSERT INTO users (user_id, first_name, last_name, email, password, user_role, contact_number, is_active) VALUES (7, 'Robert', 'Chen', 'robert.superadmin@example.com', 'super_secure_hash', 'SUPER ADMIN', 09789012345, 1);

ALTER SEQUENCE seq_user_id INCREMENT BY 7;