#!/bin/python
#
#
#

import argparse
import ipdb
import os
import sys

from subprocess import call, check_output
from scripts.dotfile import Dotfile


def add_vim():
    """This is run after the ~/.vim folder is copied

    TODO Just think how nicely this would look if it was object oriented.
    No more need to go re-search the vim directory
    """

    user = os.path.expanduser('~')
    vim = ''

    if os.name == 'posix':
        vim = os.path.join(user, '.vim')
    elif os.name == 'nt':
        vim = os.path.join(user, 'vimfiles')

    vim_path = os.path.join(vim, 'bundle/vundle')
    if not os.path.exists(vim_path):
        try:
            os.makedirs(vim_path)
            out = check_output('git')
            call('git clone https://github.com/gmarik/Vundle.vim.git %s' % vim,
                 shell=True)
        except FileNotFoundError:
            print('You don\'t seem to have git installed')
            print('Don\'t forget to clone vundle from')
            print('https://github.com/gmarik/Vundle.vim')


def get_list():
    """THIS IS THE FUNCTION YOU WANT TO EDIT

    The Dotfile class takes a few parameters
    First is a path string to what you want to name the file in the
        src/ directory. If left blank, it will take the name of the
        original.
    The second parameter is the actual location of the dotfile to copy.
        This can be a directory or file. It will know how to handle either.

    For option parameters check scripts/dotfile.py
    """
    file_list = []

    # Linux
    if os.name == 'posix':
        file_list = [
            Dotfile('', '~/.vimrc', add_func=add_vim)
            #Dotfile('vim', '~/.vim', ignore={'bundle', 'tags', 'view'}),
            #Dotfile('xinitrc', '~/.xinitrc'),
            #Dotfile('l/fonts.conf', '~/.fonts.conf'),
            #Dotfile('i3', '~/.i3', confirm=True),
        ]

    # Windows
    elif os.name == 'nt':
        file_list = [
            Dotfile('vimrc', '~/_vimrc'),
            Dotfile('vim', '~/vimfiles'),
        ]

    return file_list

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Copies dotfiles',
                                     prog='dotfiles')

    parser.add_argument('-c', '--copy', help='copy arguments from '
                        'your computer to the src/ directory for easy'
                        ' uploading', action='count')
    arguments = parser.parse_args()

    # If we're this far, we'll need the list anyways
    file_list = get_list()

    for df in file_list:
        # this is where copying logic goes
        df.copy(reverse=arguments.copy is not None)
