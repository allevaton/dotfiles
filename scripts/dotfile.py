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
                 add_func=None, ignore=None):
        """Creates the Dotfile object with the specified parameters.

        Keyword arguments:
        src -- str: the source destination of the file or directory. This is
                typically located in the src/ directory tree.
        dest -- str: the regular destination of this file/directory from src
        confirm -- bool: ask the user whether or not they want to copy this
        ask_location -- bool: ask the user whether or not they want to change
                the location of this dotfile
        ignore -- set: a set of files or folders to ignore in a directory
        """

        self.src = src
        self.dest = dest
        self.ignore = ignore

        self.confirm = confirm
        self.ask_location = ask_location

    def __str__(self):
        """Some magic for print handling, mainly
        """

        return self.src

    def copy(self, reverse=False):
        """Goes ahead and copies over the files with the specified file list

        Keyword arguments:

        ** TODO change this so it's NOT AN ARRAY

        lst -- array of Dotfiles: this is the list created from the main
                setup.py file.
        """

        # let's make sure we should be continuing anyways
        if self.confirm:
            if not input_confirm():
                return

        if not reverse:
            source = os.path.join(self.src_dir, self.src)
            shutil.copytree(source, self.dest, ignore=self.ignore)
        else:
            # we may need to join with pwd
            pass

    def input_path(self):
        """Takes the user's input for a path and checks if the location
        exists. If it doesn't, it will ask if it can create the location for
        you.

        Returns:
        True if the user allowed the program to create directories, or the
            directory existed already.
        False if the user denied to create a directory that didn't exist
        """

        while True:
            s = input('Enter a new path: ')

            if not os.path.exists(s):
                a = input('The path \"%s\" does not exist, want me to create'
                          ' it? [Y/n]' % (s))

                if a.lower() == 'y' or a == '':
                    os.mkdir(s)
                    return True
                else:
                    return False
            else:
                return True

    def input_confirm(self):
        """Confirms if the user wants to copy this file.
        Called based on the self.confirm attribute passed through the
        constructor

        Why doesn't this have a prompt?
        It serves basically one purpose, hence why it's named after
        the constructor argument.

        Returns:
        True if the user confirmed
        False if the user denied
        """

        while True:
            s = input('Are you sure you want to copy the file \"%s\"? [Y/n] '
                      % (self.src))

            if s.lower() == 'y' or s == '':
                return True
            else:
                return False
