#!python
#
#
#

import os
import re


# This is only python for the cross-platformality.
# Screw Batch programming.

if __name__ == '__main__':
    if os.name == 'nt':
        with open('_vimrc', 'w') as fp:
            fp.write('source $HOME/.vimrc')

    os.remove(__file__)
