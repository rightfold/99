from collections import defaultdict, deque
from datetime import datetime, timedelta
from nn.event import Event, Level
import time
import unittest

class Stats:
    """Keep track of various statistics on recent events.

    Statistics about old events are discarded. The definition of "recent" must
    be given as an argument to ``__init__``.
    """
    def __init__(self, recent):
        self.recent = recent
        self.recent_events = deque()

    def record_event(self, event):
        """Record statistics about an event."""
        now = datetime.now()
        self.recent_events.append((now, event))

    def _erase_old_events(self):
        """Erase statistics about old events."""
        now = datetime.now()
        while (bool(self.recent_events)
                and now - self.recent_events[0][0] > self.recent):
            self.recent_events.popleft()

    def events_per_second(self):
        """How many events were recorded per second?"""
        self._erase_old_events()
        return len(self.recent_events) / self.recent.total_seconds()

    def freq_per_level(self):
        """How many events were recorded per level?"""
        self._erase_old_events()
        freqs = defaultdict(int)
        for event in self.recent_events:
            freqs[event[1].level] += 1
        return freqs

class StatsTest(unittest.TestCase):
    def test_events_per_second(self):
        stats = Stats(timedelta(seconds=0.5))
        for i in range(5):
            event = Event('foo', datetime.now(), 'localhost', Level.INFO, {})
            stats.record_event(event)
            time.sleep(0.1)
        self.assertEqual(stats.events_per_second(), 8.0)
        time.sleep(0.5)
        self.assertEqual(stats.events_per_second(), 0.0)

    def test_freq_per_level(self):
        stats = Stats(timedelta(seconds=0.5))
        for level in Level:
            for i in range(level.value * 2):
                event = Event('foo', datetime.now(), 'localhost', level, {})
                stats.record_event(event)
        f = stats.freq_per_level()
        for level in Level:
            self.assertEqual(f[level], level.value * 2)
