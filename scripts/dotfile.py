#
# Dotfile object class
#

import os
import shutil

# This is the default directory to use when copying files.
# You can safely change this, as long as you reflect the same
# changes in the directory.
src_dir = 'src'


class Dotfile(object):
    """This class is an encapsulation of the dotfile setup utility for easily
    copying configs from this repo to the correct locations according to
    a given config. The reason this is object oriented instead of just a
    basic list system is so we can conditionally ask the user if this
    location is correct, or if they don't even want this config.
    """

    def __init__(self, src, dest, confirm=False, ask_location=False,
                 add_func=None, ignores=[]):
        """Creates the Dotfile object with the specified parameters.

        Keyword arguments:
        src -- str: the source destination of the file or directory. This is
                typically located in the src/ directory tree.
        dest -- str: the regular destination of this file/directory from src
        confirm -- bool: ask the user whether or not they want to copy this
        ask_location -- bool: ask the user whether or not they want to change
                the location of this dotfile
        ignores -- array: an array of files or folders to ignore in a
                directory
        """

        self.src = src
        self.dest = dest

        self.confirm = confirm
        self.ask_location = ask_location

    def __str__(self):
        return self.src

    def copy(self, lst):
        """Goes ahead and copies over the files with the specified file list

        Keyword arguments:
        lst -- array of Dotfiles: this is the list created from the main
                setup.py file.
        """

        source = ''

        if self.confirm:
            if not input_confirm():
                return

        source = os.path.join(self.src_dir, self.src)

        # start copying files

    def reverse_copy(self, lst):
        # copy from dest to src
        pass

    def input_path(self, prompt='a new path'):
        """Takes the user's input for a path and checks if the location
        exists. If it doesn't, it will ask if it can create the location for
        you.

        Keyword arguments:
        prompt -- str: allows the user to specify an option for the path,
                    just in case they don't want the default of:
                    "a new path"
                    Note that "Enter " is prepended to the prompt and a
                    colon (:) is appended to the prompt"""

        while True:
            s = input('Enter %s: ' % (prompt))

            if not os.path.exists(s):
                a = input('The path \"%s\" does not exist, want me to create'
                          'it? [Y/n]' % (s))

                if a.lower() == 'y' or a == '':
                    os.mkdir(s)
                    return True
                else:
                    return False
            else:
                return True

    def input_confirm(self):
        while True:
            s = input('Are you sure you want to copy the file \"%s\"? [Y/n] '
                      % (self.src))

            if s.lower() == 'y' or s == '':
                return True
            else:
                return False
