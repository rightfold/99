import os.path
import psycopg2.extras
from uuid import uuid4

class Index:
    def __init__(self, db):
        self.db = db
        self._setup()

    def _setup(self):
        self.db.autocommit = True
        psycopg2.extras.register_hstore(self.db)
        with self.db.cursor() as cur:
            sql_path = os.path.dirname(__file__) + '/index.sql'
            with open(sql_path, 'r', encoding='utf8') as sql:
                cur.execute(sql.read())

    def record_event(self, event):
        with self.db.cursor() as cur:
            cur.execute('''
                INSERT INTO events (id, log, timestamp, host, level, fields)
                VALUES (%s, %s, %s, %s, %s, %s)
            ''', (
                str(uuid4()),
                event.log,
                event.timestamp,
                event.host,
                event.level.value,
                event.fields,
            ))
