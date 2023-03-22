export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[0;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'
export COLOR_BOLD='\e[1m'
export COLOR_NOT_BOLD='\e[21m'
export COLOR_TIME='\e[8;30;42m'
# to get my last external IP ;)
export TITLEPS1=`hostname`
export TITLEPS2=`last | head -1 | awk '{print $3}'`
export TITLEPS3=`date '+%Y-%m-%d'`

export COLOR_SPECIAL='\e[4;37;44m'

export PS1="\[\e]0;`echo -n $TITLEPS1 : $TITLEPS2 "["$TITLEPS3"]" ;uptime`\a\]\[${COLOR_GREEN}\][\\u@\\h:\\w|\\l]\[${COLOR_BLUE}\][\\t]\[${COLOR_YELLOW}\] \\# \[${COLOR_CYAN}\](\\d) >>>\n\[${COLOR_BLUE}\]\\w \[${COLOR_NC}\]\\$ "

# http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html
# https://www.linux.com/learn/how-make-fancy-and-useful-bash-prompt-linux

PATH=$PATH:/sbin:/usr/sbin
export PATH

# EDITOR
set -o vi
git config --global core.editor "vim"
export GIT_EDITOR=vim

s(){
    case $# in
        0)      SAVEPATH="$PATH" su root -m -c 'exec bash';;
        *)      SAVEPATH="$PATH" su root -m -c "exec bash -c '$*'";;
    esac
}

title () {
  print "\033]1;$1\007\c"
  print "\033]2;$1\007\c"
}


#title `hostname`
# sudo timedatectl set-timezone CET

alias b='cd -'
alias l='ls -alotr --color=auto $*'
alias ls='ls -a --color=auto $*'
alias lt='ls -at --color=auto $*'
alias lo='ls -a -otr -l -s -F -T 0 --color=yes $*'
alias dir='ls -a -otr -l -s -F -T 0 --color=yes $*'
alias j='jobs'
alias res='resize'
alias clear="echo -e '\e[2J\n\n'"
alias please='sudo "$BASH" -c "$(history -p !!)"'
alias fix='reset; stty sane; tput rs1; clear; echo -e "\033c"'

# https://code.visualstudio.com/docs/remote/containers?WT.mc_id=javascript-14373-yolasors#_sharing-git-credentials-with-your-container

if [ -z "$SSH_AUTH_SOCK" ]; then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="`ps -ux | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
   if [ "$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> $HOME/.ssh/ssh-agent
   fi
   eval `cat $HOME/.ssh/ssh-agent`
fi
