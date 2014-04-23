#!/bin/python
#
#
#

import os
from scripts.Dotfile import Dotfile

# directory where all the files TO COPY are located
file_list = []

# Linux
if os.name == 'posix':
    file_list = [
        Dotfile('vimrc', '~/.vimrc'),
        Dotfile('xinitrc', '~/.xinitrc'),
        Dotfile('vim', '~/.vim'),
        Dotfile('i3', '~/.i3', confirm=True),
    ]

# Windows
elif os.name == 'nt':
    # u = user profile string in Windows
    u = '%USERPROFILE'

    file_list = [
        Dotfile('vimrc', '%s/_vimrc' % u),
        Dotfile('vim', '%s/vimfiles' % u),
    ]
