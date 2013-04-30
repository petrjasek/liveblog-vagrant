import os
import glob

from fabric.api import *
from fabric.context_managers import shell_env

cwd = os.path.dirname(os.path.realpath(__file__))
app = glob.glob(os.path.join('[Ss]uperdesk', 'distribution', 'application.py')).pop()
runtime = os.path.join(cwd, app)

plugins = [os.path.dirname(x) for x in glob.glob(os.path.join(cwd, '*', '*', '*', 'setup.py'))]
paths = ':'.join(plugins)
pythonpath = '${PYTHONPATH}:%s' % paths

def dump():
    with shell_env(PYTHONPATH=pythonpath):
        local('python3 %s -dump' % runtime)

def run():
    dump()
    with shell_env(PYTHONPATH=pythonpath):
        local('python3 %s' % runtime)
