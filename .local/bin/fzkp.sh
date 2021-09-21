#!/bin/sh

##############################################################################
#
#  fzkp.sh
#  fzf for keepassxc-cli
#  Modified by Victor Faner 2021 from Steven Saus's kpf script to use rg and
#  wl-clipboard in place of fdfind and xsel. I run this via an alias in my
#  aliasrc file, fzkp, which sources the script. The advantage of sourcing vs
#  running it normally is that the keepass database and password are saved for 
#  the current client shell, making it easy to quickly re-accesss the database
#  without permanently storing your password as an environmental variable.
#
##############################################################################

if [ ! -f "${KPDB}" ];then 
    KPDB=$(rg kdbx "${HOME}" | fzf --no-hscroll -m --height 50%  --ansi --no-bold --border --header "Enter the path to the database")
fi 

if [ -z "${KPPW}" ];then
    echo "Please enter the password for the KeepassX database."
    read -s KPPW
fi

clear
export KPPW=${KPPW}
export KPDB=${KPDB}

if [ ! -z "${1}" ];then 
    echo "${KPPW}" | keepassxc-cli show -s "${KPDB}" "${1}" 2> /dev/null
    exit
else
    SCRIPTNAME=$(realpath "$0")
    KPVALUE=$(echo "${KPPW}" | keepassxc-cli ls --recursive --flatten "${KPDB}" | fzf --no-hscroll -m --ansi --no-bold --preview="$SCRIPTNAME {}" )
    echo "${KPPW}" | keepassxc-cli show -s "${KPDB}" "${KPVALUE}" -a password 2> /dev/null | wl-copy
    printf "\nThe password is copied to the clipboard.\n"
    printf "Username is %s\n"  "$(echo "${KPPW}" | keepassxc-cli show -s "${KPDB}" "${KPVALUE}" -a username 2> /dev/null)"
    printf "TOTP (if existing) is %s"  "$(echo "${KPPW}" | keepassxc-cli show -s "${KPDB}" "${KPVALUE}" --totp 2> /dev/null)"
fi
