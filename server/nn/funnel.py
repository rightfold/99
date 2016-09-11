"""Server that receives incoming events and dispatches them."""
from datetime import datetime
import gevent
import json
import jsonschema
from nn.event import Event, Level
from socket import socket
from struct import unpack
import unittest

def listen(address, dispatch):
    """Accept connections and serve them."""
    sock = socket()
    sock.bind(address)
    sock.listen()
    while True:
        conn = sock.accept()
        gevent.spawn(serve, conn[0], dispatch)

def serve(sock, dispatch):
    """Serve a single client."""
    while True:
        packet_len_buf = sock.recv(2)
        if len(packet_len_buf) != 2:
            break
        packet_len, = unpack('!H', packet_len_buf)

        packet_buf = sock.recv(packet_len)
        if len(packet_buf) != packet_len:
            break
        event = _parse_event(packet_buf)
        if event is None:
            break
        dispatch(event)

_EVENT_SCHEMA = {
    'type': 'object',
    'required': ['log', 'timestamp', 'host', 'level', 'fields'],
    'properties': {
        'log': {'type': 'string'},
        'timestamp': {'type': 'number'},
        'host': {'type': 'string'},
        'level': {
            'type': 'integer',
            'minimum': 1,
            'maximum': 7,
        },
        'fields': {
            'type': 'object',
            'additionalProperties': {'type': 'string'},
        },
    },
}

def _parse_event(packet):
    """Parse a packet into an event."""
    try:
        decoded_packet = packet.decode()
    except UnicodeDecodeError:
        return None

    try:
        parsed_packet = json.loads(decoded_packet)
    except json.JSONDecodeError:
        return None

    try:
        jsonschema.validate(parsed_packet, _EVENT_SCHEMA)
    except jsonschema.ValidationError:
        return None

    log = parsed_packet['log']
    timestamp = datetime.fromtimestamp(parsed_packet['timestamp'])
    host = parsed_packet['host']
    level = Level(parsed_packet['level'])
    fields = parsed_packet['fields']
    return Event(log, timestamp, host, level, fields)

class TestParseEvent(unittest.TestCase):
    def test_bad_json(self):
        self.assertIsNone(_parse_event(b'foo'))

    def test_missing_fields(self):
        self.assertIsNone(_parse_event(b'{"timestamp": 0, "host": "", "level": 1, "fields": {}}'))
        self.assertIsNone(_parse_event(b'{"log": "", "host": "", "level": 1, "fields": {}}'))
        self.assertIsNone(_parse_event(b'{"log": "", "timestamp": 0, "level": 1, "fields": {}}'))
        self.assertIsNone(_parse_event(b'{"log": "", "timestamp": 0, "host": "", "fields": {}}'))
        self.assertIsNone(_parse_event(b'{"log": "", "timestamp": 0, "host": "", "level": 1}'))

    def test_bad_types(self):
        self.assertIsNone(_parse_event(b'{"log": 0, "timestamp": 0, "host": "", "level": 1, "fields": {}}'))
        self.assertIsNone(_parse_event(b'{"log": "", "timestamp": "", "host": "", "level": 1, "fields": {}}'))
        self.assertIsNone(_parse_event(b'{"log": "", "timestamp": 0, "host": 1, "level": 1, "fields": {}}'))
        self.assertIsNone(_parse_event(b'{"log": "", "timestamp": 0, "host": "", "level": "", "fields": {}}'))
        self.assertIsNone(_parse_event(b'{"log": "", "timestamp": 0, "host": "", "level": 1, "fields": ""}'))
        self.assertIsNone(_parse_event(b'{"log": "", "timestamp": 0, "host": "", "level": 1, "fields": {"k": 1}}'))

    def test_bad_level(self):
        self.assertIsNone(_parse_event(b'{"log": "", "timestamp": 0, "host": "", "level": 0, "fields": {}}'))
        self.assertIsNone(_parse_event(b'{"log": "", "timestamp": 0, "host": "", "level": 8, "fields": {}}'))

    def test_ok(self):
        event = _parse_event(b'{"log": "foo", "timestamp": 1473517717, "host": "localhost", "level": 3, "fields": {"k1": "v1", "k2": "v2"}}')
        self.assertEqual(event.log, 'foo')
        self.assertEqual(event.timestamp, datetime.fromtimestamp(1473517717))
        self.assertEqual(event.host, 'localhost')
        self.assertEqual(event.level, Level.ERROR)
        self.assertEqual(event.fields, {'k1': 'v1', 'k2': 'v2'})
