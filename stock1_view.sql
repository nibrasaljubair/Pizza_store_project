CREATE VIEW stock1 as 
SELECT
    s1.item_name AS item_name,
    s1.ing_name AS ing_name,
    s1.ing_id AS ing_id,
    s1.ing_weight AS ing_weight,
    s1.ing_price AS ing_price,
    s1.order_quantity AS order_quantity,
    s1.recipe_quantity AS recipe_quantity,
    (s1.order_quantity * s1.recipe_quantity) AS ordered_weight,
    (s1.ing_price / s1.ing_weight) AS unit_cost,
    (
        (s1.order_quantity * s1.recipe_quantity) * (s1.ing_price / s1.ing_weight)
    ) AS ingredient_cost
FROM
    (
    SELECT
        o.item_id AS item_id,
        i.sku AS sku,
        i.item_name AS item_name,
        r.ing_id AS ing_id,
        ing.ing_name AS ing_name,
        ing.ing_weight AS ing_weight,
        ing.ing_price AS ing_price,
        SUM(o.quantity) AS order_quantity,
        r.quantity AS recipe_quantity
    FROM
        orders o
        LEFT JOIN item i ON (o.item_id = i.item_id)
        LEFT JOIN recipe r ON (i.sku = r.recipe_id)
        LEFT JOIN ingredient ing ON (ing.ing_id = r.ing_id)
    GROUP BY
        o.item_id,
        i.sku,
        i.item_name,
        r.ing_id,
        r.quantity,
        ing.ing_weight,
        ing.ing_price
    ) s1
