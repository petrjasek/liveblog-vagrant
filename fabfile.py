import os
import glob
import shutil

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
        local('python3.2 %s -dump' % runtime)

def run():
    dump()
    with shell_env(PYTHONPATH=pythonpath):
        local('python3.2 %s' % runtime)

def clean():
    workspace = os.path.join(cwd, os.path.dirname(app), 'workspace')

    try:
        shutil.rmtree(workspace)
    except OSError:
        pass

    properties = glob.glob(os.path.join(os.path.dirname(workspace), '*.properties'))
    for propfile in properties:
        os.remove(propfile)
