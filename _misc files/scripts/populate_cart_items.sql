INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (1, 1, 104, 2, TO_DATE('05-10-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (2, 1, 245, 1, TO_DATE('05-10-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (3, 1, 358, 1, TO_DATE('05-12-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (4, 2, 152, 1, TO_DATE('05-08-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (5, 2, 436, 3, TO_DATE('05-09-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (6, 2, 571, 2, TO_DATE('05-11-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (7, 3, 73, 1, TO_DATE('05-07-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (8, 3, 189, 2, TO_DATE('05-13-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (9, 3, 276, 1, TO_DATE('05-13-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (10, 4, 312, 1, TO_DATE('05-05-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (11, 4, 445, 2, TO_DATE('05-10-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (12, 4, 518, 1, TO_DATE('05-14-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (13, 5, 27, 2, TO_DATE('05-09-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (14, 5, 203, 1, TO_DATE('05-12-2025', 'MM-DD-YYYY'));
INSERT INTO cart_items (cart_item_id, user_id, inventory_id, quantity, date_added) VALUES (15, 5, 387, 3, TO_DATE('05-15-2025', 'MM-DD-YYYY'));

ALTER SEQUENCE seq_cart_item_id INCREMENT BY 15;