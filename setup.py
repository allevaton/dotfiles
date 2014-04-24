#!/bin/python
#
#
#

import argparse
import os
import sys

from scripts.dotfile import Dotfile


def get_list():
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

    return file_list

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Copies dotfiles',
                                     prog='dotfiles')

    copy = ''
    parser.add_argument('-c', '--copy', help='copy arguments from '
                        'your computer to the repository', action='count')
    arguments = parser.parse_args()

    # if copy argument found
    if arguments.copy is not None:
        pass

    for df in get_list():
        print(df)
