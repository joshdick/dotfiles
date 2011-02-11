#!/bin/zsh
# ZSH environment for Josh Dick <http://joshdick.net>
# As far as I know, pretty much everything besides the stuff in the "ZSH-SPECIFIC SETTINGS" section should work in bash as well.

# *** ZSH-SPECIFIC SETTINGS ***

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob nomatch
unsetopt notify
bindkey -e #-v
zstyle :compinstall filename '/home/josh/.zshrc'
autoload -Uz compinit && compinit
autoload -U colors && colors #Enable colors in prompt

# Make various standard control keys work properly
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
# For rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# For non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# For freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# *** MISC ***

# When connecting via ssh, always [re]attach to a terminal manager
# Found at http://involution.com/2004/11/17/1-32/
if [ -f /usr/bin/tmux ]; then
  if [ "$SSH_TTY" != "" -a "$TERM" -a "$TERM" != "screen" -a "$TERM" != "dumb" ]; then
    pgrep tmux
    # $? is the exit code of pgrep; 0 means there was a result (tmux is already running)
    if [ $? -eq 0 ]; then
      tmux attach -d
    else
      tmux
    fi
  fi
fi

# *** PROMPT FORMATTING ***

# (double quotes matter!)
PS1="%{$reset_color%}%{%(!.%F{red}.%F{green})%}%n@%m%{%F{yellow}%}[%h]%{$bold_color%F{blue}%} %c %{%F{green}%}\$ %{$reset_color%}"

# *** ALIASES ***

# Colorize the ls command appropriately per-platform
alias ls='ls --color'
ls &> /dev/null
if [ $? -eq 1 ]; then
  alias ls='ls -G'
fi

alias lsd='ls -lah | grep "^d"'
alias grep='grep --color'
alias hgrep='history 1 | grep $1'
alias search='find . -name'
alias t='~/.todo/todo.sh'
alias scpresume='rsync --partial --progress --rsh=ssh'
alias servedir='python -m SimpleHTTPServer'
alias mirror='wget -H -r --level=1 -k -p $1'

# *** ENVIRONMENT ***

# Editor - See if vim lives around these parts, otherwise fall back to nano
HAVE_VIM=$(command -v vim)
if test -n "$HAVE_VIM"; then
  EDITOR=vim
  VISUAL=vim
else
  EDITOR=nano
  VISUAL=nano
fi
export EDITOR
export VISUAL

PERSONAL_BIN=~/.bin

if test -r $PERSONAL_BIN; then
  export PATH=$PATH:$PERSONAL_BIN
  # Set up z if it's available <https://github.com/rupa/z>
  if test -r $PERSONAL_BIN/z.sh; then
    . $PERSONAL_BIN/z.sh
    function precmd () {
      z --add "$(pwd -P)"
    }
  fi
fi

# Include any machine-specific configuration if it exists
test -r ~/.private_sh_env &&
. ~/.private_sh_env

# *** FUNCTIONS ***

c () { tar -pcjv -f ${1%/}.tar.bz2 ${1%/}; } # .tar.bz2 a directory or file, removing a trailing slash from the given argument if one is present
gz () { gzip -r -c -9 ${1%/} > ${1%/}.gz; } # gzip a file or directory using the best compression, without deleting the originals
searchin() { find . -type f -exec grep -l "${1%/}" {} \; } # Search for a given string inside every file inside the current directory, recursively.
# Performs a full system update in Debian-based and Arch Linux systems
update() {
  if [ -x /usr/bin/apt-get ]; then
    sudo apt-get update
    sudo apt-get upgrade
  elif [ -x /usr/bin/pacman ]; then
    sudo pacman -Syu
  else
    echo "Josh's update command only works on an Arch Linux or Debian system. Sorry."
  fi
}
# Pushes local SSH public key to another box - found at https://github.com/rtomayko/dotfiles/blob/rtomayko/.bashrc
push_ssh_cert() {
    local _host
    test -f ~/.ssh/id_dsa.pub || ssh-keygen -t dsa
    for _host in "$@";
    do
        echo $_host
        ssh $_host 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_dsa.pub
    done
}
