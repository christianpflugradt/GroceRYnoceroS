CREATE VIEW shopping_list_view AS
SELECT
    gl.list_id AS list_id,
    gl.shop_id AS shop_id,
    s.name AS shop,
    g.id AS grocery_id,
    g.name AS grocery,
    c.id AS category_id,
    c.name AS category
FROM groceries_in_lists gl
INNER JOIN groceries g ON gl.grocery_id = g.id
INNER JOIN groceries_in_categories gc ON g.id = gc.grocery_id
INNER JOIN categories c ON gc.category_id = c.id
INNER JOIN categories_in_shops cs ON c.id = cs.category_id AND gl.shop_id = cs.shop_id
INNER JOIN shops s ON gl.shop_id = s.id
ORDER BY gl.shop_id, cs.priority, g.name