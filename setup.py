#!/bin/python
#
#
#

import os

src = 'src'

file_list = {}

# Linux
if os.name == 'posix':
    file_list = {
        'vimrc': '~/.vimrc',
        'xinitrc': '~/.xinitrc',
        'vim': '~/.vim'
    }

# Windows
elif os.name == 'nt':
    file_list = {
        'vimrc': '~/_vimrc',
        'vim': '~/vimfiles'
    }
