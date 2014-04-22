#!/bin/python
#
#
#

import os

# directory where all the files TO COPY are located
src = 'src'

file_list = {}

# Linux
if os.name == 'posix':
    file_list = {
        'vimrc': '~/.vimrc',
        'xinitrc': '~/.xinitrc',
        'vim': '~/.vim',
        'i3': '~/.i3'
    }

# Windows
elif os.name == 'nt':
    file_list = {
        'vimrc': '~/_vimrc',
        'vim': '~/vimfiles'
    }
