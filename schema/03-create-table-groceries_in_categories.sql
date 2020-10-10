CREATE TABLE groceries_in_categories (
    id INTEGER PRIMARY KEY,
    grocery_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP
)