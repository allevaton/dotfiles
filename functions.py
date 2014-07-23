#
#
#

import os


def decide_location():
    if os.name == 'posix':
        return 'LocationLinux'

    elif os.name == 'nt':
        if '-D7' in os.environ['COMPUTERNAME']:
            return 'LocationWork'
        else:
            return 'LocationWin'
    else:
        return None


def vimrc(dotfile):
    print('cats')
