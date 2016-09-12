import json
import jsonschema
from werkzeug.wrappers import Response

def index(index, request):
    if 'q' not in request.args:
        return Response('[]')

    try:
        query = json.loads(request.args['q'])
    except json.JSONDecodeError as e:
        return Response(str(e), status=400)

    # TODO
    #try:
    #    jsonschema.validate(query, _QUERY_SCHEMA)
    #except jsonschema.ValidationError:
    #    return None

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
