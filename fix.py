#!/usr/bin/python
#
#
#

import os
import re
from subprocess import call


# This is only python for the cross-platformality.
# Screw Batch programming.

if __name__ == '__main__':
    if os.name == 'nt':
        with open('_vimrc', 'w') as fp:
            fp.write('source $HOME/.vimrc')

    if not os.path.exists('.vim/bundle'):
        os.makedirs('.vim/bundle')
        call(['git', 'clone', 'https://github.com/gmarik/Vundle.vim.git',
              '.vim/bundle'])

    os.remove(__file__)
