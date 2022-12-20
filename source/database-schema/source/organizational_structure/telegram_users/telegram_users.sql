CREATE TABLE users (
    user_per_rowid  INT NOT NULL
                    REFERENCES people (rowid),
    user_id         INT NOT NULL
);