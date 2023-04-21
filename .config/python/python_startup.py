"""
Python interactive mode configs
"""
import atexit
import os
import readline
import rlcompleter
import sys


def set_tab_complete():
    readline.parse_and_bind('tab: complete')


def set_python_history():
    """
    Set .python_history location
    """
    histfile = os.environ.get('XDG_CACHE_HOME') + '/' + '.python_history'
    if histfile in ('', None):
        histfile = '~/.cache/.python_history'

    try:
        readline.read_history_file(histfile)
        # default history len is -1 (infinite), which may grow unruly
        readline.set_history_length(1000)
    except FileNotFoundError:
        pass

    atexit.register(readline.write_history_file, histfile)


def set_autoindent():
    """
    contextual auto indent, taken from
    """

    def rl_autoindent():
        """Auto-indent upon typing a new line according to the contents of the
        previous line.  This function will be used as Readline's
        pre-input-hook."""

        hist_len = readline.get_current_history_length()
        last_input = readline.get_history_item(hist_len)
        try:
            last_indent_index = last_input.rindex("    ")
        except:
            last_indent = 0
        else:
            last_indent = int(last_indent_index / 4) + 1
        if len(last_input.strip()) > 1:
            if last_input.count("(") > last_input.count(")"):
                indent = ''.join(["    " for n in range(last_indent + 2)])
            elif last_input.count(")") > last_input.count("("):
                indent = ''.join(["    " for n in range(last_indent - 1)])
            elif last_input.count("[") > last_input.count("]"):
                indent = ''.join(["    " for n in range(last_indent + 2)])
            elif last_input.count("]") > last_input.count("["):
                indent = ''.join(["    " for n in range(last_indent - 1)])
            elif last_input.count("{") > last_input.count("}"):
                indent = ''.join(["    " for n in range(last_indent + 2)])
            elif last_input.count("}") > last_input.count("{"):
                indent = ''.join(["    " for n in range(last_indent - 1)])
            elif last_input[-1] == ":":
                indent = ''.join(["    " for n in range(last_indent + 1)])
            else:
                indent = ''.join(["    " for n in range(last_indent)])
        readline.insert_text(indent)

    readline.set_pre_input_hook(rl_autoindent)


# Run configs
from pprint import pprint  # auto-import pprint
import visidata as vd
set_tab_complete()
set_python_history()
set_autoindent()

# Use ipython, if available
import sys
try:
    from traitlets.config import Config
    import IPython

    os.environ['PYTHONSTARTUP'] = ''  # Prevent running this again
    c = Config()
    c.TerminalInteractiveShell.editing_mode = "vi"
    IPython.start_ipython(config=c)
    raise SystemExit

except ImportError:
    print("IPython is not available: falling back to standard prompt")

#===============================================================================
# Sources
#===============================================================================

# https://docs.python.org/3/library/readline.html?highlight=readline#example
# https://github.com/brandoninvergo/python-startup/blob/master/python-startup.py

