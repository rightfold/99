from functools import partial
from nn.api.stats import get_stats
import os.path
from werkzeug import routing
from werkzeug.exceptions import HTTPException
from werkzeug.wrappers import Request
from werkzeug.wsgi import SharedDataMiddleware

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
