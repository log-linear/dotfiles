# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
  fi
fi

# if running zsh
if [ -n "$ZSH_VERSION" ]; then
  # include .zshrc if it exists
  if [ -f "$HOME/.config/zsh/.zshrc" ]; then
  . "$HOME/.config/zsh/.zshrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

# Include cargo/bin
if [ -d "$HOME/.local/share/cargo/bin" ] ; then
  PATH="$HOME/.local/share/cargo/bin:$PATH"
fi

# Defaults
export TERMINAL="alacritty"
export EDITOR="nvim"
export BROWSER="firefox"
export TERMINAL_COMMAND="$TERMINAL -e"  # Use footclient with sway-launcher-desktop
export LANG="en_US.UTF-8"
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="--reverse --color=bg+:#F9F5D6,hl+:#903F71,fg+:#3C3836,hl:#903F71 --preview 'preview {}'"
export BAT_THEME="gruvbox-light"
export DFT_BACKGROUND="light"

# $HOME cleanup
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/inputrc"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/default"
export KODI_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/kodi"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/password-store"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
export ANDROID_AVD_HOME="$XDG_DATA_HOME/android/"
export ANDROID_EMULATOR_HOME="$XDG_DATA_HOME/android/"
export ADB_VENDOR_KEY="$XDG_CONFIG_HOME/android"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/ansible/ansible.cfg"
export UNISON="${XDG_DATA_HOME:-$HOME/.local/share}/unison"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export LESSHISTFILE=-
export R_ENVIRON="$XDG_CONFIG_HOME/R/.Renviron"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME/python-eggs"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/python_startup.py"
export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
export CONDA_ROOT="$XDG_DATA_HOME/miniconda3/"
export CONDARC="$XDG_CONFIG_HOME/conda/.condarc"
export CONDA_ENVS_PATH="$XDG_DATA_HOME/conda/envs"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/.java"
export _JAVA_AWT_WM_NONREPARENTING=1
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/notmuchrc"
export NMBGIT="$XDG_DATA_HOME/notmuch/nmbug"
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export VPYTHON_VIRTUALENV_ROOT="$XDG_DATA_HOME/vpython_root"
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export RUFF_CACHE_DIR=$XDG_CACHE_HOME/ruff

# auto-start sway
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  export MOZ_DBUS_REMOTE=1
  export MOZ_ENABLE_WAYLAND=1
  export BEMENU_BACKEND="wayland"
  export XDG_CURRENT_DESKTOP="hyprland"
  export XDG_SESSION_TYPE="wayland"
  eval "$(gnome-keyring-daemon --start)"
  export SSH_AUTH_SOCK
  exec Hyprland
fi

# if running wsl
if uname -r | grep WSL -; then
  # Manually add Windows paths here. Helps with zsh performance 
  # when setting `appendWindowsPath = False` in `/etc/wsl.conf`
  PATH="/mnt/c/Windows:$PATH"
  PATH="/mnt/c/Windows/System32:$PATH"
  # Workaround for tunneling WSL through a VPN. See https://github.com/sakai135/wsl-vpnkit
  wsl.exe -d wsl-vpnkit --cd /app service wsl-vpnkit status >/dev/null || wsl.exe -d wsl-vpnkit --cd /app service wsl-vpnkit start
fi

# Work-related startup configs
if [ -f "$HOME/work.sh" ]; then
  source "$HOME/work.sh"
fi

# Shell init logic for pyenv
export PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH" || eval "$(pyenv init -)"
