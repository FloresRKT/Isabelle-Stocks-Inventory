-- Example view showing products with their inventory details
CREATE OR REPLACE VIEW vw_product_inventory AS
SELECT 
    p.product_id, 
    p.name, 
    p.product_type,
    i.inventory_id,
    i.color, 
    i.product_size, 
    i.price,
    i.quantity
FROM products p
JOIN inventory i ON p.product_id = i.product_id
WHERE p.is_active = 1;

