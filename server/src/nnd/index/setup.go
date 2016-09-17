package index

const setupScript = `
  CREATE EXTENSION IF NOT EXISTS hstore;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

  CREATE TABLE IF NOT EXISTS events (
      id          uuid            NOT NULL,
      log         text            NOT NULL,
      timestamp   timestamptz     NOT NULL,
      host        text            NOT NULL,
      level       int             NOT NULL,
      fields      hstore          NOT NULL,
      PRIMARY KEY (id),
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
`
