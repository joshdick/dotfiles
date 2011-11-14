#!/bin/zsh
# ZSH environment for Josh Dick <http://joshdick.net>
# As far as I know, pretty much everything besides the stuff in the "ZSH-SPECIFIC SETTINGS" section should work in bash as well.

# *** ZSH-SPECIFIC SETTINGS ***

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob nomatch prompt_subst
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
      tmux -u attach -d
    else
      tmux -u
    fi
  fi
fi

# *** PROMPT FORMATTING ***

# bash/generic PS1 fallback.
# (double quotes matter!)
PS1="%{$reset_color%}%{%(!.%F{red}.%F{green})%}%n@%m%{%F{yellow}%}[%h]%{$bold_color%F{blue}%} %c %{%F{green}%}\$ %{$reset_color%}"

# Native zsh prompt - based on "juanhurtado" zsh theme from oh-my-zsh
PROMPT="
%{$fg_bold[green]%}%n@%m%{$fg[white]%}:%{$fg[yellow]%}%~%u%{$reset_color%}
%{$fg[blue]%}>%{$reset_color%} "
RPROMPT="%{$fg_bold[green]%}[%{$fg[yellow]%}%h%{$fg_bold[green]%}] | [%{$fg[yellow]%}%?%{$fg_bold[green]%}]%{$reset_color%}"

# *** FUNCTIONS ***

# Test whether a given command exists
# Adapted from http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script/3931779#3931779
command_exists () {
  hash "$1" &> /dev/null
}

# To search for a given string inside every file with the given filename
# (wildcards allowed) in the current directory, recursively:
#   $ searchin filename pattern
#
# To search for a given string inside every file inside the current directory, recursively:
#   $ searchin pattern
searchin() {
  if [ -n "$2" ]; then
    find . -name "$1" -type f -exec grep -l "$2" {} \;
  else
    find . -type f -exec grep -l "$1" {} \;
  fi
}

# Performs a system update on Debian-based and Arch Linux systems, updates Homebrew packages on OS X, updates all Git submodules
update() {
  if command_exists apt-get; then
    echo "Updating packages via apt-get..."
    sudo apt-get update
    sudo apt-get upgrade
  elif command_exists pacman; then
    echo "Upadting packages via pacman..."
    sudo pacman -Syu
  fi

  # If the home directory is a Git repo, update all submodules.
  if command_exists git && test -r ~/.git; then
    echo "Updating git submodules..."
    pushd -q
    cd ~
    # Found at http://stackoverflow.com/questions/1030169/git-easy-way-pull-latest-of-all-submodules
    git submodule foreach 'git checkout master &> /dev/null; git checkout . &> /dev/null; git fetch origin && git merge origin/master'
    popd -q
  fi

  if command_exists brew; then
    echo "Updating/upgrading/cleaning up Homebrew packages..."
    brew update && brew upgrade && brew cleanup
  fi
}

# Pushes local SSH public key to another box
# Found at https://github.com/rtomayko/dotfiles/blob/rtomayko/.bashrc
push_ssh_cert() {
    local _host
    test -f ~/.ssh/id_dsa.pub || ssh-keygen -t dsa
    for _host in "$@";
    do
        echo $_host
        ssh $_host 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_dsa.pub
    done
}

# Extracts archives
# Found at http://pastebin.com/CTra4QTF
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

# Packs $2-$n into $1 depending on $1's extension
# Found at http://pastebin.com/CTra4QTF
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

# Poor-man's pgrep, for use on OS X where pgrep isn't available.
function psgrep() {
  echo "Warning: using poor-man's pgrep. Consider installing the 'proctools' package via Homebrew."
  ps ax | awk "/(^|[^)])$1/ { print \$1 }"
}

# *** ALIASES ***

# Awesome platform-independent ls formatting
# Originally found at http://www.reddit.com/r/linux/comments/hejra/til_nifty_ls_option_for_displaying_directories/c1utfxb
GLS_ARGS="--classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable --group-directories-first"
alias ls="ls $GLS_ARGS"
ls &> /dev/null
if [ $? -eq 1 ]; then # The environment ls isn't GNU ls; we're not on Linux
  # On Mac, use gls if it has been installed via Homebrew
  if command_exists gls; then
    alias ls="gls $GLS_ARGS"
  else
    alias ls='ls -G' # If not, fall back to BSD ls
  fi
fi

alias lsd='ls -lah | grep "^d"'
alias grep='grep --color'
alias hgrep='history 1 | grep $1'
alias search='find . -name'
alias scpresume='rsync --partial --progress --rsh=ssh'
alias servedir='python -m SimpleHTTPServer'
alias mirror='wget -H -r --level=1 -k -p $1'

# *** ENVIRONMENT ***

# Editor - See if vim lives around these parts, otherwise fall back to nano
if command_exists vim; then
  export EDITOR=vim
  export VISUAL=vim
else
  export EDITOR=nano
  export VISUAL=nano
fi

# Emulate pgrep if we're on OS X
if ! command_exists pgrep; then
  alias pgrep=psgrep
fi

# Use grc (Generic Colouriser) if it's available
if command_exists grc; then
  source `brew --prefix`/etc/grc.bashrc
fi

# LSCOLORS - Default except for normal directories (first character) to replace hard-to-read blue.
# For details, see manpage for ls.
export LSCOLORS=Gxfxcxdxbxegedabagacad

# If we're on OS X and using Homebrew package manager, add Homebrew binary directories to PATH
HOMEBREW_BIN=/usr/local/bin
HOMEBREW_SBIN=/usr/local/sbin
if test -r $HOMEBREW_BIN; then
  export PATH=$HOMEBREW_BIN:$PATH
fi
if test -r $HOMEBREW_SBIN; then
  export PATH=$HOMEBREW_SBIN:$PATH
fi

# Add a "personal bin" directory to PATH if it exists
PERSONAL_BIN=~/.bin
if test -r $PERSONAL_BIN; then

  export PATH=$PATH:$PERSONAL_BIN

  # Set up z if it's available <https://github.com/rupa/z>
  if test -r $PERSONAL_BIN/z/z.sh; then
    . $PERSONAL_BIN/z/z.sh
    function precmd () {
      _z --add "$(pwd -P)"
    }
  fi

  # Set up vimpager if it's available <https://github.com/rkitover/vimpager>
  if test -r $PERSONAL_BIN/vimpager/vimpager; then
    export PAGER=$PERSONAL_BIN/vimpager/vimpager
  fi

  # Set up resty if it's available <https://github.com/micha/resty>
  if test -r $PERSONAL_BIN/resty/resty; then
    . $PERSONAL_BIN/resty/resty
  fi

fi

# Include any machine-specific configuration if it exists
test -r ~/.private_sh_env &&
. ~/.private_sh_env

# Additional zsh goodies
if test -r $PERSONAL_BIN/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; then
  source $PERSONAL_BIN/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if test -r $PERSONAL_BIN/zsh-history-substring-search/zsh-history-substring-search.zsh; then
  source $PERSONAL_BIN/zsh-history-substring-search/zsh-history-substring-search.zsh
fi
