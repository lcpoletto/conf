# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

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

# Put your fun stuff here.
export MAVEN_HOME="/home/lpoletto/dev/tools/apache-maven-3.3.9"
export GRADLE_HOME="/home/lpoletto/dev/tools/gradle-2.14"
export PATH="$PATH:/home/lpoletto/local/:$MAVEN_HOME/bin:$GRADLE_HOME/bin"
# Disable default virtual env prompt so I can use mine
export VIRTUAL_ENV_DISABLE_PROMPT=1

alias pythond='python -m pudb.run'

source /usr/bin/virtualenvwrapper.sh
source /etc/bash/bashrc.d/bash_completion.sh
