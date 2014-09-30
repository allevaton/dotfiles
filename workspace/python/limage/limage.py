#!/usr/bin/python3
#
# limage image translator.
#


import logging
import os
import sys

from argparse import ArgumentParser

from ipdb import set_trace
from PIL import Image


if __name__ == '__main__':
    parser = ArgumentParser(description='Limage interpreter')
    parser.add_argument('file', nargs='?', help='input file')
    parser.add_argument('-d', '--debug', action='count',
                        help='show debug output')
    parser.add_argument('-v', '--version', action='count',
                        help='display version info and exit')
    arguments = parser.parse_args()

    if arguments.version:
        print('limage: v1.0')
        sys.exit()

    # initialize logger
    logging.basicConfig(format='limage: %(levelname)s: %(message)s',
                        filename='limage.log', filemode='w',
                        level=logging.INFO)

    if arguments.debug:
        logging.basicConfig(level=logging.DEBUG)

    # if not given an input file, and told to parse...
    if not arguments.file:
        logging.error('no input file')
        sys.exit(-1)

    set_trace()

    im = Image.open('./test/4.png')

    pixels = list(im.getdata())
