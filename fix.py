#!/usr/bin/python
#
#
#

from __future__ import print_function

import os
import re

try:
    from ipdb import set_trace
except:
    pass


if __name__ == '__main__':
    if os.name == 'nt':
        with open('~/_vimrc', 'w') as fp:
            fp.write('source ~/.vimrc', 'w')

    if os.path.exists('./doc'):
        os.remove('./doc')

    if os.path.exists('README.rst'):
        os.remove('./doc')

    os.remove(__name__)
