alias ..='cd ..'
alias bashrc='$EDITOR ~/.bashrc && source ~/.bashrc'
alias bash_aliases='$EDITOR ~/.config/.bash_aliases && source ~/.bash_aliases'
alias aliases='$EDITOR ~/.config/.bash_aliases && source ~/.config/.bash_aliases'
alias profile='$EDITOR ~/.profile && source ~/.profile'
alias cp='cp -v'
alias mv='mv -iv'
alias rm='rm -I'
alias df='df -h'
alias du='du -h'
alias ls='ls -l'
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'
alias R='R --no-save --no-restore-data'
alias r='R --no-save --no-restore-data'
alias open='xdg-open'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# System specific commands
alias vivo='sudo python ~/bin/vivosmart/send_command.py'
alias tuir='conda activate tuir && tuir && conda deactivate'
alias scc='~/bin/sc-controller-0.4.7/run.sh'
