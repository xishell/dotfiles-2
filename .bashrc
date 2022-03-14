# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

source ~/kube-ps1.sh

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
PATH="$PATH:$HOME/maven/bin:$HOME/gradle/bin"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
export SYSTEMD_PAGER=

# User specific aliases and functions

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

RESET="\[\033[0m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[01;32m\]"
BLUE="\[\033[01;36m\]"
YELLOW="\[\033[0;33m\]"
 
PS_LINE=`printf -- '- %.0s' {1..200}`
function parse_git_branch {

  echo -ne "\033]0;${PWD}\007" #set title of prompt
  PS_BRANCH=''
  PS_FILL=${PS_LINE:0:$COLUMNS}
  if [ -d .svn ]; then
    PS_BRANCH="(svn r$(svn info|awk '/Revision/{print $2}'))"
    return
  elif [ -f _FOSSIL_ -o -f .fslckout ]; then
    PS_BRANCH="(fossil $(fossil status|awk '/tags/{print $2}')) "
    return
  fi
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  #PS_BRANCH="(git ${ref#refs/heads/}) "
  PS_BRANCH="(${ref#refs/heads/}) "
}
PROMPT_COMMAND=parse_git_branch
PS_INFO="$GREEN\u@\h$RESET:$BLUE\w"
PS_GIT="$YELLOW\$PS_BRANCH"
KUBE_PS1_CTX_COLOR=yellow
KUBE_PS1_NS_COLOR=yellow
#PS_TIME="\[\033[\$()G\] $RED[\t]"
export PS1="\[\033[0G\]${PS_INFO} ${PS_GIT}$(kube_ps1) \n${RESET}\$ "
export SUDO_PS1="\[\033[0G\]${PS_INFO} ${PS_GIT}\n${RESET}# "

export CLICOLOR=1

export LSCOLORS=GxFxCxDxBxegedabagaced

alias gs='git status '
alias ga='git add .'
alias gb='git branch '
alias gc='git commit'
alias gma='git commit -am'
alias gd='git diff'
alias gp='git push'
alias gco='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias ac='ac = !git add . && git commit -am'
alias acp='ac = !git add . && git commit -am "updated" && git push'
alias gp='git pull'
alias gst='git stash'
alias gcom='git checkout master'
alias gcor='git checkout release'
alias gl='git log'
alias glg='git log --graph --oneline --decorate --all'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'
alias gst='git stash'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gstd='git stash drop'
alias gcl='git clone'
alias gpp='git pull && git push'
alias got='git '
alias get='git '
alias gpom='git pull origin master'
alias gpor='git pull origin release'
alias gfom='git fetch upstream master'
alias gfp='git fetch upstream master && git push'
alias gpum='git pull upstream master'
alias gpur='git pull upstream release'

alias fmvn='mvn clean package -DskipTests -Dspotbugs.skip=true -Dcheckstyle.skip=true -Djacoco.skip=true'

alias gbo='gradle bootrun'
alias gbi='gradle build install'
alias gcbi='gradle clean build install'
alias gb='gradle build'
alias gc='gradle clean'
alias gi='gradle install'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ll="ls -l"
alias la="ls -a"
alias grep='grep --color=auto'
alias k='kubectl'

alias prettyjson='python -m json.tool'

function perf {
  curl -o /dev/null -s -w "%{time_connect} + %{time_starttransfer} = %{time_total}\n" "$1"
}

# HSTR configuration - add this to ~/.bashrc
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor       # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
# ensure synchronization between bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

function java11() {
sdk use java 11.0.12-open
 
}

function java8() {
  sdk use java 8.0.302-open
}

export ANDROID_HOME=/home/madhur/Android/Sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/platform-tools/bin:$PATHexport PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/tools/bin:$PATHexport PATH=$ANDROID_HOME/build-tools/32.0.0:$PATH
export PATH=$ANDROID_HOME/build-tools/32.0.0/bin:$PATH
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export KUBECONFIG=~/.kube/config:~/.kube/eks-pt

export PATH=$ANDROID_HOME/bundle-tool:$PATH
#PS1='[\u@\h \W $(kube_ps1)]\$ '
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"


export ANDROID_HOME=/home/madhur/Android/Sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/platform-tools/bin:$PATHexport PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/tools/bin:$PATHexport PATH=$ANDROID_HOME/build-tools/32.0.0:$PATH
export PATH=$ANDROID_HOME/build-tools/32.0.0/bin:$PATH

export KUBECONFIG=~/.kube/config:~/.kube/eks-pt

export PATH=$ANDROID_HOME/bundle-tool:$PATH

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

export NODE_ENV=development
export GLOBAL_AGENT_HTTP_PROXY=http://127.0.0.1:8888
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH=/usr/bin:$PATH:/usr/local/go/bin:/home/madhur/.cargo/bin
. "$HOME/.cargo/env"

export PATH=/home/madhur/etcd:/usr/local/vitess/bin:${PATH}
