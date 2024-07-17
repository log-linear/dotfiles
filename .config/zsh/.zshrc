#================================== Plug-ins ===================================
# Zinit plugin manager: https://github.com/zdharma-continuum/zinit
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit light Aloxaf/fzf-tab  # Run `build-fzf-tab-module` after install to speed things up
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' fzf-min-height 50
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview $realpath'
zstyle ':fzf-tab:complete:-command-:*' fzf-preview
zstyle ':fzf-tab:complete:*:options' fzf-preview 
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
zstyle ':fzf-tab:*' switch-group ',' '.'

zinit load jeffreytse/zsh-vi-mode
zinit load zdharma/fast-syntax-highlighting
zinit load zsh-users/zsh-history-substring-search
zinit load wfxr/forgit

# bind UP and DOWN arrow keys to history substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
zinit load zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

unalias zi

#================================== Options ====================================
setopt correct           # Auto correct mistakes
setopt extendedglob      # Allow using regex with *
setopt nocaseglob        # Case insensitive globbing
setopt rcexpandparam     # Array expension with parameters
setopt nocheckjobs       # Don't warn about running processes when exiting
setopt numericglobsort   # Sort filenames numerically when it makes sense
setopt nobeep            # No beep
setopt appendhistory     # Immediately append history instead of overwriting
setopt histignorealldups # If a new command is a duplicate, remove the older one
setopt autocd            # if only directory path is entered, cd there.
disable r                # Disable zsh built-in command `r`
stty -ixon               # Disable ctrl+s ctrl+q terminal input disabling

# Completion
autoload -U compinit colors zcalc
compinit -d ${XDG_CACHE_HOME}/.zcompdump

# Tab completion settings
zstyle ':completion:*' menu select  # Completion menu selection
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitivity
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colored completion
zstyle ':completion:*' rehash true  # automatically find new $PATH executables

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
HISTFILE=~/.cache/history
HISTSIZE=1000
SAVEHIST=500
WORDCHARS=${WORDCHARS//\/[&.;]} # Ignore certain characters for word parsing

#================================ Keybindings ==================================
bindkey -e
bindkey '^[[7~' beginning-of-line          # Home key
bindkey '^[[H' beginning-of-line           # Home key
if [[ "${terminfo[khome]}" != "" ]]; then  # [Home] - Go to beginning of line
  bindkey "${terminfo[khome]}" beginning-of-line
fi
bindkey '^[[8~' end-of-line                # End key
bindkey '^[[F' end-of-line                 # End key
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line  # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                    # Insert key
bindkey '^[[3~' delete-char                       # Delete key
bindkey '^[[C'  forward-char                      # Right key
bindkey '^[[D'  backward-char                     # Left key
bindkey '^[[5~' history-beginning-search-backward # Page up key
bindkey '^[[6~' history-beginning-search-forward  # Page down key
bindkey '^b' backward-char
bindkey '^f' forward-char

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word
bindkey '^[Od' backward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Menu completion navigation
bindkey '^[[Z' reverse-menu-complete # Shift+tab undo last action
bindkey '^n' menu-complete           # Shift+tab undo last action
bindkey '^p' reverse-menu-complete   # Shift+tab undo last action

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

#================================== Theming ====================================
colors
setopt prompt_subst                                # enable prompt substition
echo $USER@$HOST  $(uname -srm) $(lsb_release -rs) # prompt greeting msg

# Color man pages
export MANPAGER="less -R --use-color -Dd+r -Du+b"

PROMPT='%B%{$fg[cyan]%}%(4~|%-1~/.../%2~|%~)%u%b >%{$fg[cyan]%}>%B%(?.%{$fg[cyan]%}.%{$fg[red]%})>%{$reset_color%}%b '

#----------------------------- vi-mode indicators ------------------------------
vim_ins_mode="%{$fg_bold[cyan]%}[I]%{$reset_color%}"
vim_nor_mode="%{$fg_bold[yellow]%}[N]%{$reset_color%}"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  # Show mode [N|I] in prompt
  vim_mode="${${KEYMAP/vicmd/${vim_nor_mode}}/(main|viins)/${vim_ins_mode}}"

  # Block for Normal, beam for Insert mode
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif 
    [[ ${KEYMAP} == main ]] ||
    [[ ${KEYMAP} == viins ]] ||
    [[ ${KEYMAP} = '' ]] ||
    [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish

echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Handle sending ^C
function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
} 
PROMPT='${vim_mode} %B%{$fg[cyan]%}%(4~|%-1~/.../%2~|%~)%u%b >%{$fg[cyan]%}>%B%(?.%{$fg[cyan]%}.%{$fg[red]%})>%{$reset_color%}%b '

#----------------------------- Right side prompt -------------------------------
# - shows status of git when in git repository (code adapted from 
# https://joshdick.net/2017/06/08/my_git_prompt_for_zsh_revisited.html)
# - shows exit status of previous command (if previous command finished with 
# an error)
# - is invisible, if neither is the case

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}="                          # =        - clean repo
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"         # A"NUM"   - ahead by "NUM" commits
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"       # B"NUM"   - behind by "NUM" commits
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}!%{$reset_color%}" # !        - merge conflict
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}~%{$reset_color%}"   # red ~    - untracked files
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}~%{$reset_color%}" # yellow ~ - tracked files modified
GIT_PROMPT_STAGED="%{$fg_bold[green]%}~%{$reset_color%}"    # green ~  - staged changes present = ready for "git push"

parse_git_branch() {
  # Show Git branch/tag, or name-rev if on detached head
  ( git symbolic-ref -q HEAD || \
      git name-rev --name-only --no-undefined --always HEAD ) 2> /dev/null
}

parse_git_state() {
  # Show different symbols as appropriate for various Git repository states
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""
  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi
  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi
  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi
  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi
  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi
  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}

git_prompt_string() {
  local git_where="$(parse_git_branch)"
  # If inside a Git repository, print its branch and state
  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
  # If not inside the Git repo, print exit codes of last command (only if it failed)
  [ ! -n "$git_where" ] && echo "%{$fg[red]%} %(?..[%?])"
}

RPROMPT='$(git_prompt_string)'

#================================= Functions ===================================

# Allow foot to open new terminals in the same directory
function osc7 {
    setopt localoptions extendedglob
    input=( ${(s::)PWD} )
    uri=${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%${(l:2::0:)$(([##16]#match))}}
    print -n "\e]7;file://${HOSTNAME}${uri}\e\\"
}
add-zsh-hook -Uz chpwd osc7

#============================= External programs ===============================
# Smart cd replacement
eval "$(zoxide init zsh)"

# Source conda init, if available
if [ -f "$HOME/.local/bin/conda_init" ] && command -v; then
  source "$HOME/.local/bin/conda_init"
fi

# keychain
if command -v keychain; then
  eval "$(keychain --eval --quiet id_ed25519 id_rsa ~/.keys/my_custom_key)"
fi

# fzf
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
  source /usr/share/fzf/key-bindings.zsh
else
  source $PREFIX/share/fzf/key-bindings.zsh
fi

if [ -f /usr/share/fzf/completion.zsh ]; then
  source /usr/share/fzf/completion.zsh
else
  source $PREFIX/share/fzf/completion.zsh
fi
export FZF_CTRL_T_COMMAND="fd"
export FZF_CTRL_T_OPTIONS=$FZF_DEFAULT_OPTS
export FZF_COMPLETION_TRIGGER=''
export FZF_COMPLETION_TRIGGER=''
export FZF_COMPLETION_OPTS="--preview 'preview {}'"
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion

# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd -u --follow f . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd -u --follow --type d . "$1"
}

# Shell init logic for pyenv
export PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH" || eval "$(pyenv init -)"

#================================== Aliases ====================================
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc" ]; then
  source "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc"
fi
 
