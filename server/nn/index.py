from datetime import datetime
import itertools
from nn.event import Event, Level
import os.path
import psycopg2.extras
import subprocess
import unittest
from uuid import uuid4

class Index:
    def __init__(self, db):
        self.db = db
        self._setup()

    def _setup(self):
        self.db.autocommit = True
        with self.db.cursor() as cur:
            sql_path = os.path.dirname(__file__) + '/index.sql'
            with open(sql_path, 'r', encoding='utf8') as sql:
                cur.execute(sql.read())
        psycopg2.extras.register_hstore(self.db)

    def record_event(self, event):
        id = uuid4()
        with self.db.cursor() as cur:
            cur.execute('''
                INSERT INTO events (id, log, timestamp, host, level, fields)
                VALUES (%s, %s, %s, %s, %s, %s)
            ''', (
                str(id),
                event.log,
                event.timestamp,
                event.host,
                event.level.value,
                event.fields,
            ))
        return id

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
            return 'lower(host)'
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

class IndexTest(unittest.TestCase):
    def setUp(self):
        subprocess.run(['dropdb', '-U', 'postgres', '--if-exists', '99_nn_index_test'])
        subprocess.run(['createdb', '-U', 'postgres', '99_nn_index_test'])
        self.db = psycopg2.connect('dbname=99_nn_index_test user=postgres')
        self.index = Index(self.db)

    def _event_examples(self):
        tuples = itertools.product(
            ['', 'a', 'a b', 'a/b/c', 'a\nb', 'føo', 'ömg'],
            ['', 'localhost', 'localHost', '192.168.1.23', 'exαmple.com'],
            Level,
            [{}, {'': ''}, {'α': 'søk'}, {'baz': 'qux', 'foo': 'bar'}],
        )
        for log, host, level, fields in tuples:
            yield Event(log, datetime.now(), host, level, fields)

    def test_record_event(self):
        for event in self._event_examples():
            id = self.index.record_event(event)
            with self.db.cursor() as cur:
                cur.execute('''
                    SELECT log, timestamp, host, level, fields
                    FROM events
                    WHERE id = %s
                ''', (str(id),))
                row = cur.fetchone()
                self.assertIsNotNone(row)
                log, timestamp, host, level, fields = row
                self.assertEqual(log, event.log)
                self.assertEqual(timestamp.replace(tzinfo=None), event.timestamp)
                self.assertEqual(host, event.host)
                self.assertEqual(level, event.level.value)
                self.assertEqual(fields, event.fields)
