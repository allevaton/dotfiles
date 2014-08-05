#!/usr/bin/python
#
#
#

from __future__ import print_function

from copy import copy
from subprocess import check_output

import os
import re
import sys

try:
    from ipdb import set_trace
except:
    pass

import yaml


def parse_config(file):
    try:
        with open(file) as fp:
            config = yaml.load(fp.read())
    except:
        print('There was a problem reading the config file.')
        print('Ensure the file exists and the path is correct.')
        sys.exit(-1)

    _os = determine_os()

    if _os in config:
        os_conf = config[_os]

        file_list = ls()

        if os_conf.get('KeepAll', True):
            delete_list = []
        else:
            delete_list = copy(file_list)

        # file key
        for fkey, fvalue in os_conf.iteritems():
            found_file = ''

            # is this a regex string?
            if fkey[0] == '/':
                # compile from the second char to the end to ignore
                # the '/'
                reg = re.compile(fkey[1:])

                for f in file_list:
                    set_trace()
                    if reg.match(f):
                        found_file = f
                        break
            else:
                for f in file_list:
                    if fkey == f:
                        found_file = f
                        break

            set_trace()
            if found_file:
                # Do we want to keep it?
                keep = fvalue.get('Keep', True)

                if keep:
                    if found_file in delete_list:
                        delete_list.remove(found_file)
                else:
                    if found_file not in delete_list:
                        delete_list.append(found_file)

        # end for
        for f in delete_list:
            os.remove(f)


def determine_os():
    if os.name == 'nt':
        if 'D7' in os.environ['COMPUTERNAME']:
            return 'Work'
        else:
            return 'Windows'

    elif os.name == 'posix':
        return 'Linux'

    else:
        print('Not supported OS: %s' % os.name)


def ls():
    curdir = os.listdir(os.path.dirname(__file__))

    if '.git' in curdir:
        return check_output(['git', 'ls-files']).strip().split('\n')

    elif '.hg' in curdir:
        out = check_output(['hg', 'status', '--all']).strip()
        return [f[2:] for f in out.split('\n')]

    else:
        print('Unsupported DVCS')
        sys.exit(-1)


if __name__ == '__main__':
    parse_config('dotfiles_config.yml')
