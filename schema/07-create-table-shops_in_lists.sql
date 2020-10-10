CREATE TABLE shops_in_lists (
    id INTEGER PRIMARY KEY,
    list_id INTEGER NOT NULL,
    shop_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP
)