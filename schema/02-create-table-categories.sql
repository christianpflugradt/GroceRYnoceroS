CREATE TABLE categories (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL COLLATE NOCASE,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP
)