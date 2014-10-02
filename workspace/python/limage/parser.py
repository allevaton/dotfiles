#
#
#


import itertools
import logging
import os
import sys

from ipdb import set_trace
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
    # Variables are defined as VARIABLE, not OP_VARIABLE
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

stack = []

# a list of pixels (4-tuple) in the format:
#   (R, G, B, A)
PIXELS = []


def push(value):
    stack.append(value)


def pop():
    try:
        return stack.pop()
    except:
        return []


def peek():
    return stack[-1]


def next():
    try:
        return PIXELS[PC+1]
    except:
        return -1


def scope():
    '''This function cleans up the current scope, and goes
    as far backwards in the stack as possible, evaluating statements,
    such as arithmetic.
    '''
    # Go through the stack backwards
    for i in itertools.count(-1, step=-1):
        if len(stack) == 0:
            break

        if stack[i][0] == 'OP_ADD':
            if stack[i-1][0] == 'OP_EQUALS':
                # set the variable equal to this value
                VARIABLES[stack[i-2]][1] = stack[i][1]
                pop()
                pop()
                pop()
                break
            elif stack[i-1][0] == 'VARIABLE':
                # add to this variable
                VARIABLES[stack[i-1][1]] += stack[i][1]
                pop()
                pop()
                break
            else:
                logging.error('expected variable or equals, got %s' %
                              stack[i-1][0])


def parse(path, evaluate=True):
    '''Begins the parsing of the given pixels

    Keyword arguments:
    evaluate -- bool: whether or not we should actually evaluate the
                      program. If chosen not to, it will simply return
                      a simplified list of tokens read left to right
    '''
    global EVALUATE
    EVALUATE = evaluate

    if evaluate:
        logging.info('evaluating expressions')
    else:
        logging.info('not evaluating, getting tokens instead')

    _get_pixels(path)

    loop()


def translate(pixel):
    # Slow...
    code = ''
    reserved = 0
    for key in iter(RESERVED):
        for i, color in enumerate(key):
            if color == -1:
                reserved += 1
            elif color == pixel[i]:
                reserved += 1

        if reserved == 4:
            return RESERVED[key]

        reserved = 0
    else:
        # If it's not a registered color, it has to be a variable
        return 'VARIABLE'


# OPERATOR STATE CHAINING
def state_var():
    '''State for when a variable is called

    '''
    global PC

    pixel = PIXELS[PC]

    # If the variable isn't defined...
    if not pixel in VARIABLES:
        VARIABLES[pixel] = 0

    var = VARIABLES[pixel]

    push(['VARIABLE', pixel, var])

    # first, immediately check if the next op is a VARIABLE to print it out
    if translate(next()) == 'VARIABLE':
        if PIXELS[PC+1] == pixel:
            print(chr(var))
            PC += 1
            pop()
            return

    while True:
        n = translate(next())
        if n == 'OP_ADD':
            state_add()
            PC += 1
        else:
            scope()
            break

def state_add():
    '''State for when an addition operator is found

    '''
    global PC

    if peek()[0] == 'OP_ADD':
        # If there's an add on the stack, just add 1 to it
        v = pop()
        v[1] += 1
        push(v)
    else:
        push(['OP_ADD', 1])


def handle(op):
    # Figure out what this pixel is, then go handle it with the correct
    # method.
    if op == 'VARIABLE':
        if EVALUATE:
            state_var()
        else:
            TOKENS.append('Variable %s' % str(PIXELS[PC]))
    elif op == 'OP_ADD':
        if EVALUATE:
            state_add()
        else:
            TOKENS.append('Add 1')
    elif op == 'OP_SUB':
        if EVALUATE:
            state_sub()
        else:
            TOKENS.append('Subtract 1')
    else:
        logging.error('where did this op come from: %s' % op)


def loop():
    # Loop forever, we'll know when to end
    global PC

    while True:
        # Get the pixel for our current PC
        if PC == len(PIXELS):
            logging.info('finished loop')
            scope()
            break

        translated = translate(PIXELS[PC])
        logging.info('got translated expr %s' % translated)

        if translated == 'NOP':
            break

        # After we translate the pixel into an op code, we need to
        # handle it
        handle(translated)
        PC += 1

    print('Tokens:')
    for token in TOKENS:
        print('\t%s' % token)

    print('Variables:')
    for key, value in VARIABLES.items():
        print('\t%s: %s' % (key, value))


def _get_pixels(path):
    global PIXELS
    try:
        with Image.open(path) as im:
            logging.debug('found input file \'%s\'' % path)
            PIXELS = list(im.getdata())
    except IOError:
        logging.error('could not open input file \'%s\'' % path)
        sys.exit(2)
