# base-files version 4.2-4

# ~/.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

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
source /usr/bin/virtualenvwrapper.sh

alias ls="ls --color"
