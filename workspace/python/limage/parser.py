#
#
#


import logging
import os
import sys

from PIL import Image


# The -1 in some values means it doesn't care what the value is.
# This is defined in the getop() function
RESERVED = {
    (-1, -1, -1, 0): 'NOP',
    (0, 0, 0, -1): 'OP_NEGATE',
    (0, 0, 255, -1): 'OP_EQUALS',
    (0, 255, 0, -1): 'OP_ADD',
    (255, 0, 0, -1): 'OP_SUB',
    (0, 255, 255, -1): 'OP_MULT'
}

# Do we want to evaluate the expressions, or just print tokens?
EVALUATE = True

# Only used if EVALUATE is set to False
TOKENS = []

# Variables defined in the input program
# These should be in the format:
#   (R, G, B, A): VALUE
VARIABLES = {}

# Program counter; where we currently are
PC = 0

STACK = []

# a list of pixels (4-tuple) in the format:
#   (R, G, B, A)
PIXELS = []


def parse(path, evaluate=True):
    '''Begins the parsing of the given pixels

    Keyword arguments:
    evaluate -- bool: whether or not we should actually evaluate the
                      program. If chosen not to, it will simply return
                      a simplified list of tokens read left to right
    '''
    EVALUATE = evaluate

    if evaluate:
        logging.info('evaluating expressions')
    else:
        logging.info('not evaluating, getting tokens instead')

    PIXELS = _get_pixels(path)


def _get_pixels(path):
    try:
        with Image.open(path) as im:
            logging.debug('found input file \'%s\'' % path)
            return list(im.getdata())
    except IOError:
        logging.error('could not open input file \'%s\'' % path)
        sys.exit(2)
