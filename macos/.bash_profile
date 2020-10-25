#
# ~/.bash_profile, copied from Arch Linux one
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

function aws-profile() {
    profiles=$(cat ~/.aws/config | grep '\[' | tr -d '[]' | cut -f 2 -d ' ')
    if [[ -z "$1" || "$profiles" != *"$1"* ]]; then
        echo -n "Available profiles:"
        echo $profiles | perl -pe "s/( |^)/\n  /g"
        unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE
        kubectl config use-context docker-desktop
    else
        export AWS_DEFAULT_PROFILE="$1"
        export AWS_PROFILE="$1"
        export AWS_EB_PROFILE="$1"
        aws-env
    fi
}

function aws-region() {
    export AWS_DEFAULT_REGION="$(aws configure get region)"
}

function aws-env() {
    aws-region

    # optimistically fetch values using `aws configure` cli
    id=$(aws configure get aws_access_key_id)
    secret=$(aws configure get aws_secret_access_key)
    token=""

    # if those values are empty, then try to fetch from cli cache
    if [ -z $id ]; then
        # make a call so that CLI will possibly prompt for MFA and do sts:AssumeRole
        account=$(aws sts get-caller-identity --profile ${AWS_DEFAULT_PROFILE} | jq -r '.Account')

        json=$(ls -t $HOME/.aws/cli/cache/*.json | xargs grep -l ${account} | head -1 | xargs cat)
        id=$(echo $json | jq -r '.Credentials.AccessKeyId')
        secret=$(echo $json | jq -r '.Credentials.SecretAccessKey')
        token=$(echo $json | jq -r '.Credentials.SessionToken')
    fi

    [ $id ] && export AWS_ACCESS_KEY_ID="$id"
    [ $secret ] && export AWS_SECRET_ACCESS_KEY="$secret"
    [ $token ] && export AWS_SESSION_TOKEN="$token" || unset AWS_SESSION_TOKEN
    # Hardcoded kubernetes cluster name below, should probably try a better way
    [ $token ] && aws eks update-kubeconfig --name k8s_shared --alias ${AWS_PROFILE}
}

function aws-current-profile() {
    [ $AWS_PROFILE ] && echo "[aws:$AWS_PROFILE] " || echo "[aws:default] "
}

function node-env() {
    cpwd=$(PWD)
    docker run -it --rm --entrypoint /bin/sh -p 0.0.0.0:3000:3000 -p 0.0.0.0:4000:4000 --name ${cpwd##*/} -v /var/run/docker.sock:/var/run/docker.sock -v ${cpwd}:/opt/${cpwd##*/} -w /opt/${cpwd##*/} node:12.13.0-alpine
}

git_branch() {
    local result=$(git branch --show-current --no-color 2>/dev/null)
    [ $result ] && echo " (git:$result)"
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


kubelogs() {
    pod=$(kubectl get pods | grep "$1" | grep -v mysql | grep -v redis | grep -v mongo | cut -f 1 -d ' ' | sed -n ${2}p)
    echo "Showing logs for $pod."
    kubectl logs $pod -f | grep --line-buffered "$3" | grep --line-buffered -v '/healthcheck' | grep --line-buffered -v '/ready' | grep --line-buffered -v '/.well-known' | grep --line-buffered -v 'Server ready at' | jq -R 'fromjson? | select(type == "object")'
}

kubecontext() {
    kubectl config set-context $(kubectl config current-context) --namespace="$1"
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

# Bash Completion V1:
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion bash)
fi

if command -v helm >/dev/null 2>&1; then
    source <(helm completion bash)
fi

#PS1+='\[\e[01;32m\]\u@\h'                  # user at host
PS1+="\[\e[00;35m\]\$(aws-current-profile)"
PS1+='\[\e[01;34m\]\w'                    # Current path
PS1+="\[\e[00;33m\]\$(git_branch)"
PS1+="\[\e[00;31m\]\$(git_status)"         # this function adds a trailing space
PS1+="\[\e[00;35m\]\$(virtualenv_prompt)"
PS1+='\[\e[01;34m\]\$\[\e[00m\] '          # dollar sign

export USR_PYTHON="$HOME/Library/Python/2.7"
export WORKON_HOME=$HOME/.virtualenvs
# Disable default virtual env prompt so I can use mine
export VIRTUAL_ENV_DISABLE_PROMPT=1
#source "$USR_PYTHON/bin/virtualenvwrapper.sh"

export GOPATH=$HOME/dev/gorkspace
export PATH="$PATH:$USR_PYTHON/bin:$HOME/.local:$GOPATH/bin"

alias ls="ls -G"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
alias ecr_login="aws ecr --region $AWS_REGION get-login --no-include-email | bash"
alias kubelocal="kubectl config use-context docker-desktop"
alias gounit="go test -cover -tags=unit -count=1 ./..."
alias gocover="go test -coverprofile /tmp/cover.out -tags=unit -count=1 ./... && go tool cover -func /tmp/cover.out | grep 'total:' | awk '\$1=\$1'"

[ -f $HOME/.bashrc_secure ] && . $HOME/.bashrc_secure
