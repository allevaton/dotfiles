#!/usr/bin/python
#
#
#

import os

from subprocess import call, check_output

# This is only python for the cross-platformality.
# Screw Batch programming.

if __name__ == '__main__':
    if os.name == 'nt':
        with open('_vimrc', 'w') as fp:
            fp.write('source $HOME/.vimrc')

    if check_call(['git', '--version']):
        if not os.path.exists('.vim/bundle'):
            os.makedirs('.vim/bundle')
            call(['git', 'clone', 'https://github.com/gmarik/Vundle.vim.git',
                  '.vim/bundle'])

        call(['git', 'config', 'status.showuntrackedfiles', 'no'])
        call(['git', 'config', 'fetch.recurseSubmodules', 'true'])

    # Remove the current file
    os.remove(__file__)
