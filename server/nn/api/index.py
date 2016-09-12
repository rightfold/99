import json
from werkzeug.wrappers import Response

def index(index, request):
    if 'q' not in request.args:
        return Response('[]')

    try:
        query = json.loads(request.args['q'])
    except json.JSONDecodeError as e:
        return Response(str(e), status=400)

    result = []
    for event in index.search_events(query):
        result.append({
            'log': event.log,
            'timestamp': event.timestamp.timestamp(),
            'host': event.host,
            'level': event.level.value,
            'fields': event.fields,
        })
    return Response(json.dumps(result))
