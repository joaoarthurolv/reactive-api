-- Initial migration placeholder.
-- Replace with your real schema (tables, indexes, etc.).
CREATE TABLE IF NOT EXISTS health_check (
    id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
