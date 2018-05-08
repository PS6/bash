# .bashrc

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

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
export TITLEPS2=`hostname`
export TITLEPS3=`date '+%Y-%m-%d'`

export PS1="\[\e]0;`echo -n $TITLEPS2"["$TITLEPS3"]";uptime`\a\]${COLOR_WHITE}[\\u@\\h.\\l]${COLOR_LIGHT_GREEN}[\\t] ${COLOR_PURPLE}\\# ${COLOR_LIGHT_BLUE}\\w ${COLOR_NC}\\$ "

PATH=$PATH:/sbin:/usr/sbin
export PATH

set -o vi

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

alias b='cd -'
alias l='ls -alotr --color=auto $*'
alias ls='ls -a --color=auto $*'
alias lt='ls -at --color=auto $*'
alias lo='ls -a -otr -l -s -F -T 0 --color=yes $*'
alias dir='ls -a -otr -l -s -F -T 0 --color=yes $*'
alias j='jobs'
alias res='resize'
alias clear="echo -e '\e[2J\n\n'"
