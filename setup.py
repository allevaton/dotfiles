import os
from pathlib import Path
from subprocess import call, check_call


def git_update(directory_parts):
    call(['git', '-C', os.path.join(home, *directory_parts, 'pull')])

home = str(Path.home())

if not os.path.exists(os.path.join(home, '.oh-my-zsh')):
    print('oh-my-zsh not present,, installing...')
    call(['sh', '-c', '"$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'])
else:
    print('updating oh-my-zsh...')
    call(['git', '-C', os.path.join(home, '.oh-my-zsh'), 'pull'])

