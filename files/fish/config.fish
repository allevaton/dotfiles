#
#   fish config
#

# variables {{{
# global path
set -e PATH
set -Ux PATH /usr/bin /usr/local/bin
# }}}

# aliases {{{
# A much easier ls statement
#alias ls="if [[ -f .hidden ]]; then while read l; do opts+=(--hide="$l"); done < .hidden; fi; ls --color=auto "${opts[@]}""
alias ls='ls -v --color=auto'

# Handy
alias l='ls'

# An easier more detailed list command
alias la='ls -lha'


# Ranger is nice, so shortcut it.
alias ra='ranger'

# Sudo fix
#alias sudo="sudo $@"

# Always love colors
alias tree='tree -C'

# Human readable
alias df='df -h'

# Just in case you forgot...
alias rn='mv'

# Colorful less
# `-R' is reading raw ASCII characters
alias less='less -r'

# Good stuff
alias vim='vim -p'
alias vimrc='vim ~/.vimrc'
alias gvim='gvim -p'
alias gvimrc='gvim ~/.vimrc'

# Better way to type `clear`
#alias c='clear'

# Getting annoying...
alias cp='cp -r'

# My useful trash command
alias rm='rm -i'
alias mv='mv -i'

# chmod u+x got annoying to type
alias x='chmod u+x'

# Easy stuff.
alias ifwd="ifconfig wlp3s0 down; netctl stop-all"
alias n='netctl'
alias ns='netctl start'

# Heh, duh... but really, it's better and easier
alias duh='du -hsc'

# Interesting... in case of accidents
# cd's into the previous directory
alias cdp="cd $OLDPWD"

# cd's into the parent directory
alias cdd='cd ..'

# No one really likes case sensitivity sometimes...
alias grep='grep --color=auto'
alias igrep='grep -i'

alias fgrep='fgrep --color=auto'
alias ifgrep='fgrep -i'

alias egrep='egrep --color=auto'
alias iegrep='egrep -i'

# So annoying...
alias find='sudo find'

# Much better
alias cdwo="cd $HOME/workspace"

# Colored and automatically elevated pacman? Hell yes.
alias pacman='sudo pacman --color auto'

# This alias is for going into my currently active project
# Note that this will change periodically.
alias activeproj='. activeproj'

# Hardly ever used, but still nice.
alias grub-mkconfig="grub-mkconfig -o /boot/grub/grub.cfg"

# A lot nicer
alias journal='journalctl'
alias j='journal'

# Goes with the pattern
alias sys='systemctl'

# Use vim as a pager
#alias less='vimpager'
# }}}


# fish prompt{{{
set fish_git_dirty_color red
set fish_git_not_dirty_color green

# prompt symbol
set prompt_sym ''

function parse_git_branch
    set -l branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
    set -l git_diff (git diff)

    if test -n "$git_diff"
        echo (set_color $fish_git_dirty_color)$branch(set_color normal)
    else
        echo (set_color $fish_git_not_dirty_color)$branch(set_color normal)
    end
end

if contains 'root' $USER
    set prompt_sym '#'
    set fish_color_cwd red
else
    set prompt_sym '$'
    set fish_color_cwd green
end

function get_host
    eval hostname|cut -d . -f 1
end

function fish_prompt
    if test -d .git
        printf '%s@%s %s%s%s (%s)%s ' (whoami) (hostname)\
            (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (parse_git_branch) (echo $prompt_sym)
    else
        printf '%s@%s %s%s%s%s ' (whoami) (hostname)\
            (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (echo $prompt_sym)
    end
end
#}}}
