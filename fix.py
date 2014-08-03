#!/usr/bin/python
#
#
#

from __future__ import print_function

import os
import re
import sys

import yaml


def parse_config(file):
    try:
        config = yaml.load(fp.read())
    except:
        print('There was a problem reading the config file.')
        print('Ensure the file exists and the path is correct.')
        sys.exit(-1)

    _os = determine_os()

    if _os in config:
        pass


def determine_os():
    if os.name == 'posix':
        if 'D7' in os.environ['COMPUTERNAME']:
            return 'Work'
        else:
            return 'Windows'

    elif os.name == 'nt':
        return 'Linux'

    else:
        print('Not supported OS %s' % os.name)


if __name__ == '__main__':
    parse_config('dotfiles_config.yml')
