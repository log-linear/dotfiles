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

while [ ! -f "${KPDB}" ]; do
  echo "Please enter a valid path to a KeePassX database."
  read KPDB
done

if [ -z "${KPPW}" ]; then
  echo "Please enter the password."
  read -s KPPW
fi

while [ "$(echo ${KPPW} | keepassxc-cli open ${KPDB} -q)" = "> " ]; do
  echo "Password Incorrect. Please re-enter the password for ${KPDB}"
  read -s KPPW
done

clear
export KPPW=${KPPW}
export KPDB=${KPDB}

if [ ! -z "${1}" ]; then 
  echo "${KPPW}" | keepassxc-cli show -s "${KPDB}" "${1}" 2> /dev/null
  exit
else
  SCRIPTNAME=$(realpath "$0")
  KPVALUE=$(echo "${KPPW}" | keepassxc-cli ls --recursive --flatten "${KPDB}" | fzf --no-hscroll -m --ansi --no-bold --preview="$SCRIPTNAME {}" )
  echo "${KPPW}" | keepassxc-cli show -s "${KPDB}" "${KPVALUE}" -a password 2> /dev/null | wl-copy
  printf "\nPassword has been copied to the clipboard.\n"
  printf "Username is %s\n"  "$(echo "${KPPW}" | keepassxc-cli show -s "${KPDB}" "${KPVALUE}" -a username 2> /dev/null)"
  printf "TOTP (if existing) is %s"  "$(echo "${KPPW}" | keepassxc-cli show -s "${KPDB}" "${KPVALUE}" --totp 2> /dev/null)"
fi

