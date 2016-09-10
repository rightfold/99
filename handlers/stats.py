def on_event(event):
    undocumented_stats.record_event(event)

    ε = undocumented_stats.events_per_second()
    φ = undocumented_stats.freq_per_level()
    print('events per second: {}'.format(ε))
    print('freq per level: {}'.format(φ))
