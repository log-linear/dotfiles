"""
Ensure .python_history is saved to $XDG_CACHE_HOME rather than $HOME

Adapted from https://docs.python.org/3/library/readline.html?highlight=readline#example
"""
import atexit
import os
import readline

histfile = os.environ.get('XDG_CACHE_HOME') + '/' + '.python_history'
try:
    readline.read_history_file(histfile)
    # default history len is -1 (infinite), which may grow unruly
    readline.set_history_length(1000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)
