from functools import partial
import json
from nn.event import Level
import os.path
from werkzeug import routing
from werkzeug.exceptions import HTTPException
from werkzeug.wrappers import Request, Response
from werkzeug.wsgi import SharedDataMiddleware

def get_stats(stats, request):
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

def make_wsgi(stats):
    routes = routing.Map([
        routing.Rule('/stats', endpoint=partial(get_stats, stats)),
    ])

    @Request.application
    def wsgi(request):
        adapter = routes.bind_to_environ(request.environ)
        try:
            endpoint, values = adapter.match()
            return endpoint(request, **values)
        except HTTPException as e:
            return e

    wsgi = SharedDataMiddleware(wsgi, {
        '/static': os.path.dirname(__file__) + '/../../dashboard',
    })

    return wsgi
