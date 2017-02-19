#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

git_branch() {
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

git_status() {
    local status="$(git status --porcelain 2>/dev/null)"
    if [[ -n $status ]]; then
        echo '+ '
    else
        echo ' '
    fi
}

virtualenv_prompt() {
    [[ -n "$VIRTUAL_ENV" ]] && echo "[${VIRTUAL_ENV##*/}] "
}

# Change the window title of X terminals 
case ${TERM} in
    [aEkx]term*|rxvt*|gnome*|konsole*|interix)
        PS1='\[\033]0;\u@\h:\W\007\]'
        ;;
    screen*)
        PS1='\[\033k\u@\h:\W\033\\\]'
        ;;
    *)
        unset PS1
        ;;
esac

PS1+='\[\e[01;32m\]\u@\h' # user at host
PS1+="\[\e[00;33m\]\$(git_branch)"
PS1+="\[\e[00;31m\]\$(git_status)" # this function adds a trailing space
PS1+='\[\e[01;34m\]\w ' # Current path
PS1+="\[\e[00;35m\]\$(virtualenv_prompt)"
PS1+='\[\e[01;34m\]\$\[\e[00m\] ' # dollar sign

# Disable default virtual env prompt so I can use mine
export VIRTUAL_ENV_DISABLE_PROMPT=1
# source /usr/bin/virtualenvwrapper.sh

alias ls='ls --color=auto'
