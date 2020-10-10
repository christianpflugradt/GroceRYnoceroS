CREATE VIEW shopping_list_view AS
SELECT
    gl.list_id AS list_id,
    cs.shop_id AS shop_id,
    g.id AS grocery_id,
    g.name AS grocery,
    c.id AS category_id,
    c.name AS category
FROM groceries_in_lists gl
INNER JOIN groceries g ON gl.grocery_id = g.id
INNER JOIN groceries_in_categories gc ON g.id = gc.grocery_id
INNER JOIN categories c ON gc.category_id = c.id
INNER JOIN categories_in_shops cs ON c.id = cs.category_id
ORDER BY cs.shop_id, cs.priority, g.name