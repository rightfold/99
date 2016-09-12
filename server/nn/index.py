from nn.event import Event, Level
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

    def search_events(self, query):
        sql, args = _compile_query(query)
        with self.db.cursor() as cur:
            cur.execute(sql, args)
            for log, timestamp, host, level, fields in cur:
                yield Event(log, timestamp, host, Level(level), fields)

def _compile_query(query):
    # TODO: validation
    def go(query, args):
        if query == 'host':
            return 'host'
        elif query[0] == 'field':
            args.append(query[1])
            return 'fields -> %s'
        elif query[0] == 'and':
            if len(query) == 1:
                return 'true'
            return 'AND'.join('(' + go(q, args) + ')' for q in query[1:])
        elif query[0] == 'or':
            if len(query) == 1:
                return 'false'
            return 'OR'.join('(' + go(q, args) + ')' for q in query[1:])
        elif query[0] == 'eq':
            return '(' + go(query[1], args) + ')=(' + go(query[2], args) + ')'
        elif query[0] == 'string':
            args.append(query[1])
            return '%s'
    sql = '''
        SELECT log, timestamp, host, level, fields
        FROM events
        WHERE
    '''
    args = []
    sql += go(query, args)
    return sql, args
