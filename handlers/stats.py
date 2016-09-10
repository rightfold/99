from collections import defaultdict, deque
from datetime import datetime, timedelta

recent = timedelta(seconds=10)
recent_events = deque()

def record_event(now, event):
    recent_events.append((now, event))

def erase_old_events(now):
    while (bool(recent_events)
            and now - recent_events[0][0] > recent):
        recent_events.popleft()

def events_per_second():
    return len(recent_events) / recent.total_seconds()

def freq_per_level():
    freqs = defaultdict(int)
    for event in recent_events:
        freqs[event[1].level] += 1
    return freqs

def on_event(event):
    now = datetime.now()
    record_event(now, event)
    erase_old_events(now)
    ε = events_per_second()
    φ = freq_per_level()
    print('events per second: {}'.format(ε))
    print('freq per level: {}'.format(φ))
