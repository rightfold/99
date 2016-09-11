from collections import namedtuple
from enum import Enum

Event = namedtuple('Event', ['log', 'timestamp', 'host', 'level', 'fields'])

class Level(Enum):
    DEBUG    = 7
    INFO     = 6
    NOTICE   = 5
    WARNING  = 4
    ERROR    = 3
    CRITICAL = 2
    ALERT    = 1
