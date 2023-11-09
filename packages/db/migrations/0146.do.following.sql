-- Type: DO
-- Name: following
-- Description: Create tables for following feature

BEGIN;

ALTER TABLE omnivore.subscriptions
    ADD COLUMN is_public boolean,
    ADD COLUMN auto_add_to_library boolean;

ALTER TABLE omnivore.library_item
    ADD COLUMN hidden_at timestamptz,
    ADD COLUMN added_to_following_at timestamptz,
    ADD COLUMN added_to_following_by text,
    ADD COLUMN links jsonb,
    ADD COLUMN preview_content text,
    ADD COLUMN preview_content_type text,
    ADD COLUMN added_to_following_from text,
    ADD COLUMN added_to_library_at timestamptz DEFAULT current_timestamp;

CREATE POLICY library_item_admin_policy on omnivore.library_item
    FOR ALL
    TO omnivore_admin
    USING (true);

CREATE TABLE omnivore.feed (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
    title text NOT NULL,
    url text NOT NULL,
    author text,
    description text,
    image text,
    created_at timestamptz NOT NULL DEFAULT current_timestamp,
    updated_at timestamptz NOT NULL DEFAULT current_timestamp,
    published_at timestamptz,
    UNIQUE(url)
);

CREATE INDEX feed_title_idx ON omnivore.feed(title);

CREATE TRIGGER update_feed_modtime BEFORE UPDATE ON omnivore.feed FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

GRANT SELECT, INSERT, UPDATE ON omnivore.feed TO omnivore_user;

COMMIT;
