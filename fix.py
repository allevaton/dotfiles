#!/usr/bin/python
#
#
#

import os
import re


if __name__ == '__main__':
    if os.name == 'nt':
        with open('_vimrc', 'w') as fp:
            fp.write('source $HOME/.vimrc')

    os.remove(__file__)
