#
# ~/.bashrc
#

# This is what the general appearance of the prompt looks like
#export PS1="\[\e[1;34m\u\e[0m@\h \W\]\$ "

export PS1="\[\e[1;34m\]\u\[\e[m\]@\h \W\$ "

# TODO: $PATH

# aliases {{{

# A much easier ls statement
#alias ls='if [[ -f .hidden ]]; then while read l; do opts+=(--hide="$l"); done < .hidden; fi; ls --color=auto "${opts[@]}"'
alias ls='ls -vh --color=auto'

# Handy
alias l='ls'
alias ll='ls -l'

# An easier more detailed list command
alias la='ls -lha'

# Ranger is nice, so shortcut it.
alias ra='. ranger'

# Sudo fix
#alias sudo="sudo $@"

# Always love colors
alias tree='tree -C'

# Human readable
alias df='df -h'

# Just in case you forgot...
alias rn='mv'

# Good stuff
alias vim='vim'
alias vimrc='vim ~/.vimrc'
alias gvim='gvim'
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
alias ifwd='ifconfig wlp3s0 down && netctl stop-all'
alias n='netctl'
alias ns='netctl start'

# Heh, duh... but really, it's better and easier
alias duh='du -hsc'

# Interesting... in case of accidents
# cd's into the previous directory
alias cdp='cd $OLDPWD'

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
alias cdwo='cd $HOME/workspace'

# Colored and automatically elevated pacman? Hell yes.
alias pacman='sudo pacman --color auto'

# Hardly ever used, but still nice.
#alias grub-mkconfig="grub-mkconfig -o /boot/grub/grub.cfg"

# A lot nicer
alias journal='journalctl'
alias j='journal'

# Goes with the pattern
alias sys='systemctl'

# Use vim as a pager
alias less='less -R'

# }}}
##
#
# Function redefinitions go here.
#
# I like colored manual pages.
#
# Colored man pages
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;38;5;74m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[38;33;246m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[04;38;5;146m'

