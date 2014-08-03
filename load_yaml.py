#!python
#
#
#

import os

from ipdb import set_trace

import yaml


with open('dotfiles_config.yml') as fp:
    config = yaml.load(fp.read())

set_trace()
