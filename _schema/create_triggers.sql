-- Products table trigger
CREATE OR REPLACE TRIGGER trg_products_insert
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  IF :new.product_id IS NULL THEN
    SELECT seq_product_id.NEXTVAL INTO :new.product_id FROM dual;
  END IF;
END;
/

-- Inventory table trigger
CREATE OR REPLACE TRIGGER trg_inventory_insert
BEFORE INSERT ON inventory
FOR EACH ROW
BEGIN
  IF :new.inventory_id IS NULL THEN
    SELECT seq_inventory_id.NEXTVAL INTO :new.inventory_id FROM dual;
  END IF;
END;
/

-- Users table trigger
CREATE OR REPLACE TRIGGER trg_users_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
  IF :new.user_id IS NULL THEN
    SELECT seq_user_id.NEXTVAL INTO :new.user_id FROM dual;
  END IF;
END;
/

-- Addresses table trigger
CREATE OR REPLACE TRIGGER trg_addresses_insert
BEFORE INSERT ON addresses
FOR EACH ROW
BEGIN
  IF :new.address_id IS NULL THEN
    SELECT seq_address_id.NEXTVAL INTO :new.address_id FROM dual;
  END IF;
END;
/

-- Orders table trigger with reference number generation
CREATE OR REPLACE TRIGGER trg_orders_insert
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
  IF :new.order_id IS NULL THEN
    SELECT seq_order_id.NEXTVAL INTO :new.order_id FROM dual;
  END IF;
  
  -- Generate reference number if not provided
  IF :new.reference_number IS NULL THEN
    :new.reference_number := 'ORD-' || LPAD(seq_order_ref_num.NEXTVAL, 6, '0');
  END IF;
END;
/

-- Order Items table trigger
CREATE OR REPLACE TRIGGER trg_order_items_insert
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
  IF :new.order_item_id IS NULL THEN
    SELECT seq_order_item_id.NEXTVAL INTO :new.order_item_id FROM dual;
  END IF;
END;
/

-- Inventory Transactions table trigger
CREATE OR REPLACE TRIGGER trg_inventory_trans_insert
BEFORE INSERT ON inventory_transactions
FOR EACH ROW
BEGIN
  IF :new.transaction_id IS NULL THEN
    SELECT seq_transaction_id.NEXTVAL INTO :new.transaction_id FROM dual;
  END IF;
END;
/

-- Cart Items table trigger
CREATE OR REPLACE TRIGGER trg_cart_items_insert
BEFORE INSERT ON cart_items
FOR EACH ROW
BEGIN
  IF :new.cart_item_id IS NULL THEN
    SELECT seq_cart_item_id.NEXTVAL INTO :new.cart_item_id FROM dual;
  END IF;
END;
/

-- Payments table trigger with reference number generation
CREATE OR REPLACE TRIGGER trg_payments_insert
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
  IF :new.payment_id IS NULL THEN
    SELECT seq_payment_id.NEXTVAL INTO :new.payment_id FROM dual;
  END IF;
  
  -- Generate reference number if not provided
  IF :new.reference_number IS NULL THEN
    :new.reference_number := 'PAY-' || LPAD(seq_payment_ref_num.NEXTVAL, 6, '0');
  END IF;
END;
/

-- Trigger to automatically generate order reference numbers
CREATE OR REPLACE TRIGGER trg_order_reference_number
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    -- Reference number follows the format ORD-YYYYMMDD-XXXX where XXXX is the sequence number
    :NEW.reference_number := 'ORD-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || 
                            LPAD(TO_CHAR(seq_order_ref_num.NEXTVAL), 4, '0');
END;
/

-- Trigger to update inventory quantity after a successful order
CREATE OR REPLACE TRIGGER trg_update_inventory_after_order
AFTER INSERT ON order_items
FOR EACH ROW
DECLARE
    v_transaction_type VARCHAR2(20) := 'SALE';
    v_available_qty NUMBER;
BEGIN
    -- Check if sufficient inventory is available
    SELECT quantity INTO v_available_qty 
    FROM inventory
    WHERE inventory_id = :NEW.inventory_id;
    
    IF v_available_qty < :NEW.quantity THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient inventory for inventory_id: ' || :NEW.inventory_id);
    END IF;
    
    -- Reduce inventory quantity
    UPDATE inventory
    SET quantity = quantity - :NEW.quantity
    WHERE inventory_id = :NEW.inventory_id;
    
    -- Record the transaction in inventory_transactions
    INSERT INTO inventory_transactions (
        transaction_id,
        inventory_id,
        transaction_type,
        quantity,
        transaction_date
    ) VALUES (
        seq_transaction_id.NEXTVAL,
        :NEW.inventory_id,
        v_transaction_type,
        -1 * :NEW.quantity,  -- Negative quantity for sales
        SYSDATE
    );
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error processing order item: ' || SQLERRM);
END;
/

-- Trigger to automatically generate payment reference numbers
CREATE OR REPLACE TRIGGER trg_payment_reference_number
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    -- Reference number follows the format PAY-YYYYMMDD-XXXX where XXXX is the sequence number
    :NEW.reference_number := 'PAY-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || 
                            LPAD(TO_CHAR(seq_payment_ref_num.NEXTVAL), 4, '0');
END;
/

-- Trigger to update order total amount when order items are added/modified
CREATE OR REPLACE TRIGGER trg_update_order_total
AFTER INSERT OR UPDATE OR DELETE ON order_items
FOR EACH ROW
DECLARE
    v_total NUMBER(10,2);
BEGIN
    IF DELETING THEN
        -- Recalculate total for the affected order
        SELECT NVL(SUM(quantity * unit_price), 0)
        INTO v_total
        FROM order_items
        WHERE order_id = :OLD.order_id;
        
        UPDATE orders
        SET total_amount = v_total
        WHERE order_id = :OLD.order_id;
    ELSE
        -- For INSERT and UPDATE operations
        SELECT NVL(SUM(quantity * unit_price), 0)
        INTO v_total
        FROM order_items
        WHERE order_id = :NEW.order_id;
        
        UPDATE orders
        SET total_amount = v_total
        WHERE order_id = :NEW.order_id;
    END IF;
END;
/