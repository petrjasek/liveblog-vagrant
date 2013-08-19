import os
import glob
import shutil

from fabric.api import *
from fabric.context_managers import shell_env

cwd = os.path.dirname(os.path.realpath(__file__))
app = glob.glob(os.path.join('[Ss]uperdesk', 'distribution', 'application.py')).pop()
runtime = os.path.join(cwd, app)
workspace = os.path.join(cwd, os.path.dirname(app), 'workspace')

plugins = [os.path.dirname(x) for x in glob.glob(os.path.join(cwd, '*', '*', '*', 'setup.py')) if 'inter' not in x]
paths = ':'.join(plugins)
pythonpath = '${PYTHONPATH}:%s' % paths

def dump():
    with shell_env(PYTHONPATH=pythonpath):
        local('python3.2 %s -dump' % runtime)

def run():
    dump()
    with shell_env(PYTHONPATH=pythonpath):
        local('python3.2 %s' % runtime)

def clean_workspace():
    try:
        shutil.rmtree(workspace)
    except OSError:
        pass

def clean_properties():
    properties = [
        os.path.join(os.path.dirname(workspace), 'application.properties'),
        os.path.join(os.path.dirname(workspace), 'distribution.properties'),
    ]

    for propfile in properties:
        try:
            os.remove(propfile)
        except OSError:
            pass

def clean():
    clean_workspace()
    clean_properties()
