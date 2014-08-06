#!/usr/bin/python
#
#
#

import os
import re


if __name__ == '__main__':
    if os.name == 'nt':
        with open('_vimrc', 'w') as fp:
            fp.write('source $HOME/.vimrc', 'w')

    if os.path.exists('README.rst'):
        os.remove('README.rst')

    os.remove(__name__)
