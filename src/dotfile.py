#
#
#

from subprocess import call, check_output

import os
import shutil
import sys

from ipdb import set_trace

import yaml


__all__ = ['pull', 'push']


def copytree(src, dst, symlinks=False, ignore=None):
    try:
        names = os.listdir(src)
    except:
        try:
            # try to copy the file
            shutil.copy2(src, dst)
        except:
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

    try:
        os.makedirs(dst)
    except:
        # Directory exists
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
                copytree(srcname, dstname, symlinks, ignore)

            else:
                shutil.copy2(srcname, dst)

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


def input_confirm(name):
    '''Confirms if the user wants to copy this file.

    Returns:
    True if the user confirmed
    False if the user denied

    '''
    while True:
        s = input('Are you sure you want to copy the file \"%s\"? [Y/n] '
                  % (name))

        if s.lower() == 'y' or s == '':
            return True
        else:
            return False


def load_config(path):
    # Let an exception fail it
    return yaml.load(open(path))


def safe_call(command):
    result = call(command)

    if result != 0:
        print('Command returned a non 0 status code:')
        print('\t%s' % ' '.join(command))
        print('Manual intervention is required.')
        sys.exit(result)
    else:
        return result


def pull(config_path, location, user_functions, do_pull, quiet):
    config = load_config(config_path)

    cwd = set(os.listdir('.'))

    if do_pull:
        if '.hg' in cwd:
            safe_call(['hg', 'pull'])

        elif '.git' in cwd:
            safe_call(['git', 'pull'])

        elif '.svn' in cwd:
            safe_call(['svn', 'up'])

    _copy(config, location, user_functions, quiet, reverse=False)


def push(config_path, location, user_functions, do_push, add_files,
         message, quiet):

    config = load_config(config_path)

    cwd = set(os.listdir('.'))

    if do_push:
        if '.hg' in cwd:
            if add_files:
                safe_call(['hg', 'add'])

            safe_call(['hg', 'commit', '-m', message])
            safe_call(['hg', 'push'])

        elif '.git' in cwd:
            if add_files:
                # could've used xargs, but Windows may not have it
                additional_files = check_output(['git', 'ls-files', '--others',
                                                 '--exclude-standard'])
                safe_call(['git', 'add', additional_files.split('\n')])

            safe_call(['git', 'commit', '-am', message])
            safe_call(['git', 'pull'])

        elif '.svn' in cwd:
            # TODO svn pushing support
            call(['svn', 'up'])

    _copy(config, location, user_functions, quiet, reverse=True)


def _copy(config, location, user_functions, quiet, reverse):
    files_dir = config.get('SaveToLocation')
    if files_dir is None:
        raise ValueError('SaveToLocation was not found in the config. '
                         'This is required.')
    else:
        if not os.path.exists(files_dir):
            os.makedirs(files_dir)

    if sys.version_info < (3, 0):
        dictionary = config.iteritems()
    else:
        dictionary = config.items()

    # TODO python3 compatibility
    for key, value in dictionary:
        if type(value) == dict:
            # if this dotfile has a location for the current system
            if location in value:
                # check to see any prepended functions
                if 'BeforeFunction' in value:
                    try:
                        getattr(user_functions,
                                value['BeforeFunction'])(value)
                    except:
                        pass

                # saved_loc = location in the SaveToLocation, specified in
                # the config
                # abspath, files_dir+specified SaveAs, or name of key
                saved_loc = os.path.abspath(
                            os.path.join(files_dir, value.get('SaveAs', key)))

                # fs_loc = location on the filesystem
                # abspath, expanduser, expandvars on the specified location
                fs_loc = os.path.abspath(os.path.expanduser(
                         os.path.expandvars(value[location])))

                ignore = set(value.get('Ignore', set()))

                do_copy = False

                # if they specify to confirm the copy
                if value.get('Confirm'):
                    # if they give you the okay
                    if input_confirm(key):
                        do_copy = True
                else:
                    do_copy = True

                if do_copy:
                    if reverse:
                        copytree(fs_loc, saved_loc, ignore=ignore)
                    else:
                        copytree(saved_loc, fs_loc, ignore=ignore)

                if not quiet:
                    print('Copied %s to %s' % (key, fs_loc))

                if 'AdditionalFunction' in value:
                    try:
                        getattr(user_functions,
                                value['AdditionalFunction'])(value)
                    except:
                        pass

    reminders = config.get('Reminders')
    if reminders:
        print(open('reminders.rst').read())
