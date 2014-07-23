#
#
#

import os

import yaml


__all__ = ['load_config']


def load_config(path):
    # Let an exception fail it
    return yaml.load(open(path))


def sc_pull():
    pass
