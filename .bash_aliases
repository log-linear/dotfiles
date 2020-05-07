alias ..='cd ..'
alias bashrc='$EDITOR ~/.bashrc && source ~/.bashrc'
alias bash_aliases='$EDITOR ~/.bash_aliases && source ~/.bash_aliases'
alias aliases='$EDITOR ~/.bash_aliases && source ~/.bash_aliases'
alias profile='$EDITOR ~/.profile && source ~/.profile'
alias rm='rm -I'
alias df='df -h'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias R='R --no-save --no-restore-data'
alias python=python3
alias pycharm='pycharm-professional'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'