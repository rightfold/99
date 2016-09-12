from functools import partial
import nn.api.index
import nn.api.stats
import os.path
from werkzeug import routing
from werkzeug.exceptions import HTTPException
from werkzeug.wrappers import Request
from werkzeug.wsgi import SharedDataMiddleware

def make_wsgi(index, stats):
    routes = routing.Map([
        routing.Rule('/stats', endpoint=partial(nn.api.stats.index, stats)),
        routing.Rule('/index', endpoint=partial(nn.api.index.index, index))
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
        '/static': os.path.dirname(__file__) + '/../../../dashboard',
    })

    return wsgi
