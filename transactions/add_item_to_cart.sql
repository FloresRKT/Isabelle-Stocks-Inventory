DECLARE
    v_user_id NUMBER := 1;             -- User ID
    v_inventory_id NUMBER := 3;        -- Inventory item ID
    v_quantity NUMBER := 2;            -- Quantity
    
    v_cart_id NUMBER;
    v_existing_item NUMBER := 0;
    v_available_qty NUMBER;
BEGIN
    -- Verify that requested inventory exists and has sufficient quantity
    BEGIN
        SELECT quantity INTO v_available_qty
        FROM inventory
        WHERE inventory_id = v_inventory_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Inventory item does not exist');
    END;
    
    IF v_available_qty < v_quantity THEN
        RAISE_APPLICATION_ERROR(-20002, 'Not enough inventory available. Only ' || 
                               v_available_qty || ' items in stock.');
    END IF;
    
    -- Check if user has an existing shopping cart
    BEGIN
        SELECT cart_id INTO v_cart_id
        FROM shopping_carts
        WHERE user_id = v_user_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Create new cart if none exists
            v_cart_id := seq_cart_id.NEXTVAL;
            
            INSERT INTO shopping_carts (cart_id, user_id, last_modified)
            VALUES (v_cart_id, v_user_id, SYSDATE);
    END;
    
    -- Check if item is already in cart
    BEGIN
        SELECT COUNT(*) INTO v_existing_item
        FROM cart_items
        WHERE cart_id = v_cart_id AND inventory_id = v_inventory_id;
    END;
    
    IF v_existing_item > 0 THEN
        -- Update existing cart item quantity
        UPDATE cart_items
        SET quantity = quantity + v_quantity,
            date_added = SYSDATE
        WHERE cart_id = v_cart_id AND inventory_id = v_inventory_id;
        
        DBMS_OUTPUT.PUT_LINE('Updated quantity of existing item in cart');
    ELSE
        -- Add new cart item
        INSERT INTO cart_items (
            cart_item_id, cart_id, inventory_id, quantity, date_added
        ) VALUES (
            seq_cart_item_id.NEXTVAL, v_cart_id, v_inventory_id, v_quantity, SYSDATE
        );
        
        DBMS_OUTPUT.PUT_LINE('Added new item to cart');
    END IF;
    
    -- Update the last_modified timestamp of the cart
    UPDATE shopping_carts
    SET last_modified = SYSDATE
    WHERE cart_id = v_cart_id;
    
    COMMIT;
    
    -- Display cart summary
    DBMS_OUTPUT.PUT_LINE('Item added to cart successfully');
    DBMS_OUTPUT.PUT_LINE('Cart ID: ' || v_cart_id);
    DBMS_OUTPUT.PUT_LINE('User ID: ' || v_user_id);
    
    -- Print cart details
    FOR item IN (
        SELECT 
            p.name, 
            i.color, 
            i.product_size, 
            ci.quantity, 
            i.price, 
            (ci.quantity * i.price) AS subtotal
        FROM 
            cart_items ci
            JOIN inventory i ON ci.inventory_id = i.inventory_id
            JOIN products p ON i.product_id = p.product_id
        WHERE 
            ci.cart_id = v_cart_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Product: ' || item.name || 
            ', Color: ' || NVL(item.color, 'N/A') || 
            ', Size: ' || NVL(item.product_size, 'N/A') || 
            ', Qty: ' || item.quantity || 
            ', Price: $' || item.price || 
            ', Subtotal: $' || item.subtotal
        );
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/