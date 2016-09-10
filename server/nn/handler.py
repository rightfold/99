"""A handler is a program that is executed for each incoming event.

To define a handler, simply write a Python script that defines a global unary
function named ``on_event``. This function takes an event as argument and
performs some side-effects when called.

Please beware that any exceptions thrown by the handler will be ignored. Please
be aware that the standard library has been monkey patched by gevent.
"""
import sys

def load_handler(file):
    """Load a handler from a file."""
    with open(file, 'rb') as file_io:
        src = file_io.read()
    scope = {}
    _catch(lambda: exec(src, scope))
    return lambda e: _catch(lambda: scope['on_event'](e))

def _catch(thunk):
    """Catch any exceptions thrown by ``thunk``."""
    try:
        return thunk()
    except Exception as e:
        print(e, file=sys.stderr)
        return None
