import json
from nn.event import Level
from werkzeug.wrappers import Response

def index(stats, request):
    ε = stats.events_per_second()
    f = stats.freq_per_level()
    json_stats = {
        'eventsPerSecond': ε,
        'debugRate':    f[Level.DEBUG],
        'infoRate':     f[Level.INFO],
        'noticeRate':   f[Level.NOTICE],
        'warningRate':  f[Level.WARNING],
        'errorRate':    f[Level.ERROR],
        'criticalRate': f[Level.CRITICAL],
        'alertRate':    f[Level.ALERT],
    }
    return Response(json.dumps(json_stats))
