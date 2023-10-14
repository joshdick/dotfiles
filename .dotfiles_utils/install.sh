#!/bin/sh
set -ue

heading() {
  printf "\e[1m\e[34m==>\e[39m %s\e[0m\n" "$1"
}

fatal() {
  echo 1>&2;
  echo "============" 1>&2;
  echo "Error: $1" 1>&2;
  exit 1
}

if ! hash git > /dev/null 2>&1; then
  fatal "This script requires \`git\`! Please install \`git\`, then try running this script again."
fi

if ! hash curl > /dev/null 2>&1; then
  fatal "This script requires \`curl\`! Please install \`curl\`, then try running this script again."
fi

# Sanity check for previous versions of the dotfiles installation;
# the existence of a $HOME/.config symlink will break yadm
if [ -L "$HOME/.config" ]; then
  fatal "$HOME/.config is a symlink! This symlink must be removed before installing dotfiles."
fi

echo
echo "This script will automatically install Josh Dick's dotfiles on your system."
echo "(See https://github.com/joshdick/dotfiles for more information.)"
echo
echo "The dotfiles will live in a self-contained git repository on your system,"
echo "managed by yadm: https://yadm.io"
echo
echo "If there are conflicting files that already exist in your home directory,"
echo "they won't be overwritten."
echo
echo "Press [ENTER] to proceed, or [CTRL+C] to cancel installation."
read -r

heading "Downloading a temporary copy of \`yadm\`..."

export YADM=/tmp/yadm

if ! curl -fsSL https://raw.githubusercontent.com/TheLocehiliosan/yadm/master/yadm > $YADM || [ ! -f $YADM ]; then
  fatal "There was a problem downloading \`yadm\`! Try running this script again."
fi

chmod +x $YADM

heading "\`yadm clone\`ing dotfiles..."

if ! $YADM clone --no-bootstrap https://github.com/joshdick/dotfiles.git; then
  fatal "There was a problem \`yadm clone\`ing the dotfiles repository!"
fi

printf "Use SSH remote for the dotfiles repository? [y/n] " >&2
read -r USE_SSH_REMOTE
if expr "$USE_SSH_REMOTE" : "^[yY]$" > /dev/null; then
  $YADM remote set-url origin git@github.com:joshdick/dotfiles.git
fi

heading "Initializing Git submodules via \`yadm\`..."
$YADM submodule update --recursive --checkout --remote --init

heading "Running \`yadm bootstrap\`..."

if ! $YADM bootstrap; then
  fatal "There was a problem running \`yadm bootstrap\`!"
fi

heading 'Cleaning up...'
rm $YADM

echo
echo "========================================="
echo
echo "The dotfiles were successfully installed!"
echo
echo "You may want to:"
echo
echo "  * run \`yadm status\` to check for conflicts with any existing dotfiles"
echo "  * restart your shell or manually run zsh"
