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
if [ -f /usr/bin/tmux ] && [ -z $TMUX ]; then
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
  export EDITOR=vim
  export VISUAL=vim
else
  export EDITOR=nano
  export VISUAL=nano
fi

# LSCOLORS - Default except for normal directories (first character) to replace hard-to-read blue.
# For details, see manpage for ls.
export LSCOLORS=Gxfxcxdxbxegedabagacad

# If we're on Mac OS X and installed Git with git-osx-installer,
# add it to PATH so that we don't use any older versions of Git
# that ship with XCode.
GIT_BIN=/usr/local/git/bin
if test -r $GIT_BIN; then
  export PATH=$GIT_BIN:$PATH
fi

# Add a "personal bin" directory to PATH if it exists
PERSONAL_BIN=~/.bin
if test -r $PERSONAL_BIN; then
  export PATH=$PATH:$PERSONAL_BIN
  # Set up z if it's available <https://github.com/rupa/z>
  if test -r $PERSONAL_BIN/z/z.sh; then
    . $PERSONAL_BIN/z/z.sh
    function precmd () {
      z --add "$(pwd -P)"
    }
  fi
fi

# Include any machine-specific configuration if it exists
test -r ~/.private_sh_env &&
. ~/.private_sh_env

# *** FUNCTIONS ***

# To search for a given string inside every file with the given filename
# (wildcards allowed) in the current directory, recursively:
#   $ searchin filename pattern
#
# To search for a given string inside every file inside the current directory, recursively:¬
#   $ searchin pattern
searchin() {
  if [ -n "$2" ]; then
    find . -name "$1" -type f -exec grep -l "$2" {} \;
  else
    find . -type f -exec grep -l "$1" {} \;
  fi
}

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
        ssh $_host 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_dsa.pub
    done
}

# Extracts archives - found at http://pastebin.com/CTra4QTF
function extract() {
   case $@ in
       *.tar.bz2) tar -xvjf "$@"  ;;
       *.tar.gz)  tar -xvzf "$@"  ;;
       *.bz2)     bunzip2 "$@"  ;;
       *.rar)     unrar x "$@"  ;;
       *.gz)      gunzip "$@" ;;
       *.tar)     tar xf "$@" ;;
       *.tbz2)    tar -xvjf "$@"  ;;
       *.tgz)     tar -xvzf "$@"  ;;
       *.zip)     unzip "$@"    ;;
       *.xpi)     unzip "$@"    ;;
       *.Z)       uncompress "$@" ;;
       *.7z)      7z x "$@" ;;
       *.ace)     unace e "$@"  ;;
       *.arj)     arj -y e "$@" ;;
       *)         echo "'$@' cannot be extracted via $0()" ;;
   esac
}

# Packs $2-$n into $1 depending on $1's extension - found at http://pastebin.com/CTra4QTF
function compress() {
   if [ $# -lt 2 ] ; then
      echo -e "\n$0() usage:"
      echo -e "\t$0 archive_file_name file1 file2 ... fileN"
      echo -e "\tcreates archive of files 1-N\n"
   else
     DEST=$1
     shift

     case $DEST in
       *.tar.bz2) tar -cvjf $DEST "$@" ;;
       *.tar.gz)  tar -cvzf $DEST "$@" ;;
       *.zip)     zip -r $DEST "$@" ;;
       *)         echo "Unknown file type - $DEST" ;;
     esac
   fi
}
