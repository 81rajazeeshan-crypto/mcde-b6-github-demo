-- =====================================================
-- Section 5 — Subqueries (Tasks 29 to 35)
-- =====================================================

-- Task 29: Find all products whose list price is above the overall average list price.

SELECT 
    product_id, 
    product_name, 
    list_price
FROM production.products
WHERE list_price > (
    SELECT AVG(list_price) 
    FROM production.products
);

-- Task 30: Find customers who have never placed an order.

SELECT 
    customer_id, 
    first_name, 
    last_name, 
    email
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id 
    FROM sales.orders 
    WHERE customer_id IS NOT NULL
);

-- Task 31: List the most expensive product in each category.

SELECT 
    product_id, 
    product_name, 
    category_id, 
    list_price
FROM production.products p1
WHERE list_price = (
    SELECT MAX(list_price) 
    FROM production.products p2 
    WHERE p2.category_id = p1.category_id
);

-- Task 32: Find staff members who work in the store that generated the most revenue.

SELECT 
    staff_id, 
    first_name, 
    last_name, 
    store_id
FROM sales.staffs
WHERE store_id = (
    SELECT TOP 1 s.store_id
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN sales.stores s ON o.store_id = s.store_id
    GROUP BY s.store_id
    ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC
);

-- Task 33: Find orders where the total order value exceeds 5000.

SELECT 
    order_id, 
    total_order_value
FROM (
    SELECT 
        order_id, 
        SUM(quantity * list_price * (1 - discount)) AS total_order_value
    FROM sales.order_items
    GROUP BY order_id
) AS order_totals
WHERE total_order_value > 5000;

-- Task 34: List products that have never been ordered by any customer.

SELECT 
    product_id, 
    product_name
FROM production.products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id 
    FROM sales.order_items
);

-- Task 35: Find the customer who has spent the most money overall.

SELECT TOP 1 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;