#!python
#
#
#

from argparse import ArgumentParser

import functions

from src import dotfile


parser = ArgumentParser()
parser.add_argument('-n', '--no-pull', dest='pull', action='count',
                    help='Do not pull from the repository', default=1)
parser.add_argument('-q', '--quiet', action='count',
                    help='Do not print anything', default=False)
arguments = parser.parse_args()

# if the -n argument was passed...
arguments.pull = True if arguments.pull == 1 else False

dotfile.pull('config.yml',
             location=functions.decide_location(),
             user_functions=functions,
             do_pull=arguments.pull,
             quiet=arguments.quiet)
