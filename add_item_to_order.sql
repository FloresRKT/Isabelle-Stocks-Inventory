DECLARE
    v_customer_id NUMBER := 1;               -- Customer ID
    v_shipping_cost NUMBER(10,2) := 5.99;    -- Shipping cost
    v_order_id NUMBER;                       -- To store new order ID
    v_cart_id NUMBER;                        -- Cart ID
    v_total_amount NUMBER(10,2) := 0;        -- To calculate order total
	v_cart_count NUMBER;					 -- To check if cart has items
    
    -- Exception for insufficient inventory
    v_insufficient_inventory EXCEPTION;
    v_insufficient_item VARCHAR2(100);
BEGIN
    -- Check if customer has items in cart
    SELECT COUNT(*)
    INTO v_cart_count
    FROM shopping_carts sc, cart_items ci
    WHERE sc.cart_id = ci.cart_id
    AND sc.user_id = v_customer_id;
    
    IF v_cart_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No items in customer cart');
    END IF;
    
    -- Get cart ID for this customer
    SELECT cart_id INTO v_cart_id
    FROM shopping_carts
    WHERE user_id = v_customer_id;
    
    -- Verify inventory for all items before proceeding
    FOR item IN (
        SELECT ci.inventory_id, ci.quantity, i.quantity AS available_quantity, 
               p.name || ' - ' || i.color || ' (' || i.product_size || ')' AS product_desc
        FROM cart_items ci
        JOIN inventory i ON ci.inventory_id = i.inventory_id
        JOIN products p ON i.product_id = p.product_id
        WHERE ci.cart_id = v_cart_id
    ) LOOP
        IF item.available_quantity < item.quantity THEN
            v_insufficient_item := item.product_desc;
            RAISE v_insufficient_inventory;
        END IF;
    END LOOP;
    
    -- Create new order
    v_order_id := seq_order_id.NEXTVAL;
    
    INSERT INTO orders (
        order_id, user_id, order_date, 
        shipping_cost, status, total_amount
    ) VALUES (
        v_order_id, v_customer_id, SYSDATE, 
        v_shipping_cost, 'PENDING', 0
    );
    
    -- Process each cart item
    FOR item IN (
        SELECT ci.inventory_id, ci.quantity, i.price
        FROM cart_items ci
        JOIN inventory i ON ci.inventory_id = i.inventory_id
        WHERE ci.cart_id = v_cart_id
    ) LOOP
        -- Add item to order
        INSERT INTO order_items (
            order_item_id, order_id, inventory_id, 
            quantity, unit_price
        ) VALUES (
            seq_order_item_id.NEXTVAL, v_order_id, item.inventory_id,
            item.quantity, item.price
        );
        
        -- Update inventory
        UPDATE inventory
        SET quantity = quantity - item.quantity
        WHERE inventory_id = item.inventory_id;
        
        -- Track inventory transaction
        INSERT INTO inventory_transactions (
            transaction_id, inventory_id, transaction_type,
            quantity, reference_id, notes
        ) VALUES (
            seq_transaction_id.NEXTVAL, item.inventory_id, 'SALE',
            item.quantity, v_order_id, 'Order #' || v_order_id
        );
        
        -- Add to running total
        v_total_amount := v_total_amount + (item.quantity * item.price);
    END LOOP;
    
    -- Update order with calculated total
    v_total_amount := v_total_amount + v_shipping_cost;
    
    UPDATE orders
    SET total_amount = v_total_amount
    WHERE order_id = v_order_id;
    
    -- Empty the cart
    DELETE FROM cart_items
    WHERE cart_id = v_cart_id;
    
    -- Commit the entire transaction
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Order #' || v_order_id || ' created successfully. Total: $' || v_total_amount);

EXCEPTION
    WHEN v_insufficient_inventory THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: Insufficient inventory for ' || v_insufficient_item);
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error processing order: ' || SQLERRM);
END;
/