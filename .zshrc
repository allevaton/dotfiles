#
# ~/.zshrc
#
autoload -U colors && colors
autoload -U promptinit && promptinit
PURE_PROMPT_SYMBOL='$'
prompt pure

#PROMPT="%(!.%F{red}.%F{blue})%n%f@%m %1~%(!.#.\$) "
#PROMPT="\[\e[1;34m\]\u\[\e[m\]@\h \W\$ "

# Load the old bash profile for environmental variables.
emulate sh -c '. ~/.profile'

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt appendhistory autocd extendedglob nomatch
setopt HIST_IGNORE_DUPS
unsetopt beep
bindkey -e

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
# zstyle :compinstall filename '/home/nick/.zshrc'

# PLUGINS {{{

autoload -Uz compinit
compinit

function loadplugin
{
    if [ -e "$1" ]
    then
        source "$1"
    else
        echo "Plugin not loaded: $1"
    fi
}

#loadplugin '/usr/share/doc/pkgfile/command-not-found.zsh'

loadplugin '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

# corrections
setopt correct_all

# don't kill child processes
setopt NO_HUP
# }}}

# Getting some keys to work {{{
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

bindkey "${terminfo[kent]}" accept-line

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
# }}}

# aliases {{{

#alias ls='if [[ -f .hidden ]]; then while read l; do opts+=(--hide="$l"); done < .hidden; fi; ls --color=auto "${opts[@]}"'
alias ls='ls -vhG'

# Handy
alias l='ls'
alias ll='ls -l'

# An easier more detailed list command
alias la='ls -lha'

# Ranger is nice, so shortcut it.
alias ra='. ranger'

# Git shortcuts
alias g='git'
alias ga='git add'
alias gap='git add --patch'
alias gs='git status'
alias gd='git diff'
alias gr='git reset'
alias grh='git reset --hard @'
alias grb='git rebase'
alias gb='git branch -vv'
alias gc='git checkout'
alias gp='git push'
alias gu='git pull'
alias go='git commit'
alias gm='git merge'
alias gf='git fetch --all'
alias gl='git log --graph --decorate'
alias gt='git stash save'
alias gh='git show'
alias gtl='git stash list'

# git reset soft (resets 1 commit), also shows the commit it just reset
grs () {
    git show
    git reset --soft @~1
}

# git stash apply, takes one number, which automatically configures it into
# the stash@{NUM}
gitstash_base () {
    func=$1

    num=0
    if [ -n "$2" ]
    then
        num=$2
        shift
    fi
    shift

    echo "git stash $func stash@{$num} $@\n"
    git stash $func stash@\{$num\} $@
}

gta () {
    gitstash_base apply $@
}

# git stash show, does the same as gta above
gts () {
    gitstash_base show $@
}

gtd () {
    gitstash_base drop $@
}

gtp () {
    gitstash_base pop $@
}

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

# cd's into the parent directory
alias cdd='cd ..'
alias pd='pushd'
alias dp='popd'

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
alias cdwo='cd $HOME/work'

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



