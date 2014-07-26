#!/usr/bin/python
#
#
#

from argparse import ArgumentParser

import functions

from src import dotfile


parser = ArgumentParser()
parser.add_argument('-n', '--no-push', dest='push', action='count',
                    help='Do not push to the repository', default=1)
parser.add_argument('-a', '--no-add', dest='add', action='count',
                    help='Do not add additional files, only commit existing '
                    'files', default=1)
parser.add_argument('-m', '--message', action='store',
                    help='Specify a message to commit',
                    default='Updated dotfiles')
parser.add_argument('-q', '--quiet', action='count',
                    help='Do not print anything', default=False)
arguments = parser.parse_args()

# negate arguments to turn them off
arguments.push = True if arguments.push == 1 else False
arguments.add = True if arguments.add == 1 else False

dotfile.push('config.yml',
             location=functions.decide_location(),
             user_functions=functions,
             do_push=arguments.push,
             add_files=arguments.add,
             message=arguments.message,
             quiet=arguments.quiet)
