UPDATE inventory
SET quantity = quantity + :NEW.quantity
WHERE inventory_id = :NEW.inventory_id;