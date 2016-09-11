CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE IF NOT EXISTS logs (
    name char(64) NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE IF NOT EXISTS events (
    id          uuid            NOT NULL,
    log         char(64)        NOT NULL,
    timestamp   timestamptz     NOT NULL,
    host        text            NOT NULL,
    level       int             NOT NULL,
    fields      hstore          NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (log)
        REFERENCES logs(name)
        ON DELETE CASCADE,
    CHECK (level BETWEEN 1 AND 7)
);

CREATE INDEX IF NOT EXISTS events__log
    ON events
    (log);

CREATE INDEX IF NOT EXISTS events__timestamp
    ON events
    (timestamp);

CREATE INDEX IF NOT EXISTS events__host
    ON events
    (lower(host));

CREATE INDEX IF NOT EXISTS events__level
    ON events
    (level);

CREATE INDEX IF NOT EXISTS events__fields
    ON events
    USING gin
    (fields);
