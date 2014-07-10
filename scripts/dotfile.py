#
# Dotfile object class
#

#import ipdb
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
                 add_func=None, pre_func=None, ignore=None):
        """Creates the Dotfile object with the specified parameters.

        Keyword arguments:
        src -- str: the source destination of the file or directory.
                This is typically located in the src/ directory tree.
        dest -- str: the regular destination of this file/directory from src
        confirm -- bool: ask the user whether or not they want to copy this
        ask_location -- bool: ask the user whether or not they want to change
                the location of this dotfile
        ignore -- set: a set of files or folders to ignore in a directory
        add_func -- function: a function to run after the files are copied
        pre_func -- function: a function to run before the files are copied

        Additional information:
        Passing None or empty string '' for src makes the program choose the
        name of the file in the dest parameter so there's no need for
        repeating of information.
        Passing None or empty string for both src AND dest, simply does not
        copy anything. The reason this may be beneficial is if you want to run
        a function after everything has been copied. So having an empty
        Dotfile entry at the end of the list with an add_func method can
        allow you to run a function after everything's been copied.

        """
        self.copy_nothing = False

        if src is None or src == '':
            if dest is None or dest is '':
                self.copy_nothing = True
                self.add_func = add_func
                return
            else:
                self.src = os.path.split(dest)[1]
        else:
            self.src = src

        self.dest = os.path.expanduser(dest)
        self.ignore = ignore

        self.confirm = confirm
        self.ask_location = ask_location
        self.add_func = add_func
        self.pre_func = pre_func

    def __str__(self):
        """Some magic for print handling, mainly

        """
        return self.src

    def copy(self, reverse=False):
        """Goes ahead and copies over the files with the specified file list

        Keyword arguments:
        reverse -- bool?: this is called automatically when the -c
            argument is supplied. It reverses the order of the source and
            destination parameters supplied by the user.

        """
        if self.copy_nothing:
            return self.add_func()

        # let's make sure we should be continuing anyways
        if self.confirm:
            if not self.input_confirm():
                return

        if self.pre_func is not None:
            self.pre_func()

        source = ''
        dest = ''
        new_name = ''

        if not reverse:
            source = os.path.join(src_dir, self.src)
            dest = self.dest
        else:
            source = self.dest
            dest = os.path.join(os.getcwd(), src_dir)
            new_name = self.src

            new_dir = os.path.join(dest, new_name)
            dest = new_dir

        print('Copying %s' % os.path.split(source)[1])
        self.copytree(source, dest, ignore=self.ignore)

        if self.add_func is not None:
            self.add_func()

    def copytree(self, src, dst, symlinks=False, ignore=None):
        try:
            names = os.listdir(src)
        except Exception:
            try:
                # try to copy the file
                shutil.copy2(src, dst)
            except Exception:
                # BUT! If it's copying to a directory that doesn't exist...
                # then make the directories
                # BUT NOT THE LAST ONE!
                # we don't want to make a directory instead of copying the
                # file.
                dst_dir = os.path.split(dst)[0]
                os.makedirs(dst_dir)

                # paste it to the new directory
                shutil.copy2(src, os.path.join(dst_dir, dst))
            return

        if ignore is not None:
            ignored_names = set(ignore)
        else:
            ignored_names = set()

        try:
            os.makedirs(dst)
        except Exception:
            pass

        errors = []
        for name in names:
            if name in ignored_names:
                continue

            srcname = os.path.join(src, name)
            dstname = os.path.join(dst, name)

            try:
                if symlinks and os.path.islink(srcname):
                    linkto = os.readlink(srcname)
                    os.symlink(linkto, dstname)
                elif os.path.isdir(srcname):
                    self.copytree(srcname, dstname, symlinks, ignore)
                else:
                    shutil.copy2(srcname, dst)
                    pass

            except (IOError, os.error) as why:
                errors.append((srcname, dstname, str(why)))
            # catch the Error from the recursive copytree so that we can
            # continue with other files
            except Exception as err:
                errors.extend(err.args[0])
        try:
            shutil.copystat(src, dst)
        except WindowsError:
            # can't copy file access times on Windows
            pass
        except OSError as why:
            errors.extend((src, dst, str(why)))

        if errors:
            raise Exception(errors)

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
                    os.makedirs(s)
                    return True
                else:
                    return False
            else:
                return True

    def input_confirm(self):
        """Confirms if the user wants to copy this file.
        Called based on the self.confirm attribute passed through the
        constructor

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
