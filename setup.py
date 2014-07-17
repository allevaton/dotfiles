#!/bin/python
#
#
#

import argparse
import os

from subprocess import call, check_output
from scripts.dotfile import Dotfile


def add_vim(dotfile):
    """This is run after the ~/.vim folder is copied

    """
    bundle_path = os.path.join(dotfile.dest, 'bundle', 'Vundle.vim')
    if not os.path.exists(bundle_path):
        try:
            os.makedirs(bundle_path)
            call('git clone https://github.com/gmarik/Vundle.vim.git %s' % vim,
                 shell=True)
        except Exception:
            print('You don\'t seem to have git installed...')
            print('Don\'t forget to clone vundle from')
            print('https://github.com/gmarik/Vundle.vim')


def reminders(dotfile):
    pass


def remove_all_i3(dotfile):
    """Removes all the files from i3 before copying, just in case I had
    something in there before that I no longer want.

    """
    for d in os.listdir(os.path.expanduser('~/.i3/')):
        os.remove(d)


def get_list():
    """THIS IS THE FUNCTION YOU WANT TO EDIT

    The Dotfile class takes a few parameters
    First is a path string to what you want to name the file in the
        src/ directory. If left blank, it will take the name of the
        original.
    The second parameter is the actual location of the dotfile to copy.
        This can be a directory or file. It will know how to handle either.

    For optional parameters check scripts/dotfile.py

    """
    vim_ignore = {'bundle', 'tags', 'view'}
    # Linux
    if os.name == 'posix':
        file_list = [
            Dotfile('vimrc', '~/.vimrc', add_func=add_vim),
            Dotfile('vim', '~/.vim', ignore=vim_ignore),
            Dotfile('xinitrc', '~/.xinitrc'),
            Dotfile('fonts.conf', '~/.fonts.conf'),
            Dotfile('i3', '~/.i3', confirm=True),
            Dotfile('fish', '~/.config/fish', confirm=True,
                    ignore={'fish_history', 'fish_read_history'}),
            Dotfile(None, None, add_func=reminders)
        ]

    # Windows
    elif os.name == 'nt':
        # work computer
        if '-D7' in os.environ['COMPUTERNAME']:
            file_list = [
                Dotfile('vimrc', r'M:\_vimrc'),
                Dotfile('vim', r'M:\vimfiles', ignore=vim_ignore,
                        add_func=add_vim),
            ]
        else:
            file_list = [
                Dotfile('vimrc', r'~/_vimrc'),
                Dotfile('vim', r'~/vimfiles', ignore=vim_ignore,
                        add_func=add_vim)
            ]

    if file_list:
        return file_list
    else:
        raise OSError('Not supported on "%s"' % os.name)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Copies dotfiles',
                                     prog='dotfiles')
    parser.add_argument('-c', '--copy', help='copy arguments from '
                        'your computer to the src/ directory for easy'
                        ' uploading', action='count')
    arguments = parser.parse_args()

    # df = dotfile
    for df in get_list():
        # this is where copying logic goes
        df.copy(reverse=arguments.copy is not None)
