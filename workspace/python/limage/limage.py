#!/usr/bin/python3
#
# limage image translator
#


import logging
import sys

from argparse import ArgumentParser

# Careful, this overrides the Python module `parser`
import parser

#from ipdb import set_trace


if __name__ == '__main__':
    aparser = ArgumentParser(description='Limage interpreter')
    aparser.add_argument('file', nargs='?', help='input file')
    aparser.add_argument('-d', '--debug', action='count',
                         help='show debug output')
    aparser.add_argument('-v', '--version', action='count',
                         help='display version info and exit')
    aparser.add_argument('-t', '--tokens', action='count',
                         help='only print out tokens, do not evaluate '
                         'any expressions in the language')
    arguments = aparser.parse_args()

    if arguments.version:
        print('limage: v1.0')
        sys.exit(0)

    loglevel = 'DEBUG' if arguments.debug else 'WARNING'

    # initialize logger
    logging.basicConfig(format='limage: %(levelname)s%(message)s',
                        level=getattr(logging, loglevel))

    logging.addLevelName(logging.WARNING, 'warning: ')
    logging.addLevelName(logging.ERROR, 'error: ')
    logging.addLevelName(logging.DEBUG, 'debug: ')
    logging.addLevelName(logging.INFO, 'info: ')

    logging.debug('logging configured')
    logging.debug('arguments parsed:\n\t%s' % arguments)

    # if not given an input file, and told to parse...
    if not arguments.file:
        logging.error('no input file')
        sys.exit(-1)

    parser.parse(arguments.file,
                 evaluate=False if arguments.tokens else True)
