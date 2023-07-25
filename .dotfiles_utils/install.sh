#!/bin/zsh
set -ue

function fatal() {
  echo 1>&2;
  echo "============" 1>&2;
  echo "Error: $1" 1>&2;
  exit 1
}

if ! hash git &> /dev/null; then
  fatal "This script requires git! Please install git, then try running this script again."
fi

if ! hash curl &> /dev/null; then
  fatal "This script requires curl! Please install curl, then try running this script again."
fi

# Sanity check for previous versions of the dotfiles installation;
# the existence of a $HOME/.config symlink will break yadm
if [ -L "$HOME/.config" ]; then
  fatal '$HOME/.config is a symlink! This symlink must be removed before installing dotfiles.'
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
read

echo 'Downloading a temporary copy of `yadm`...'

export YADM=/tmp/yadm

curl -fsSL https://raw.githubusercontent.com/TheLocehiliosan/yadm/master/yadm > $YADM

if [ $? -ne 0 ] || [ ! -f $YADM ]; then
  fatal 'There was a problem downloading `yadm`! Try running this script again.'
fi

chmod +x $YADM

echo '`yadm clone`ing dotfiles...'

$YADM clone --no-bootstrap https://github.com/joshdick/dotfiles.git

if [ $? -ne 0 ]; then
  fatal 'There was a problem `yadm clone`ing the dotfiles repository!'
fi

read -p "Use SSH remote for the dotfiles repository? [y/n] " -e USE_SSH_REMOTE
if [[ $USE_SSH_REMOTE =~ ^[Yy]$ ]]; then
  $YADM remote set-url origin git@github.com:joshdick/dotfiles.git
fi

echo 'Initializing Git submodules via `yadm`...'
$YADM submodule update --recursive --checkout --remote --init

echo 'Running `yadm bootstrap`...'
$YADM bootstrap

if [ $? -ne 0 ]; then
  fatal 'There was a problem running `yadm bootstrap`!'
fi

echo "Sourcing .zshrc..."
. $HOME/.zshrc

if [ $? -ne 0 ]; then
  fatal 'There was a problem sourcing .zshrc!'
fi

echo 'Cleaning up...'
rm $YADM

echo
echo "========================================="
echo
echo "The dotfiles were successfully installed!"
echo
echo 'You may want to run `yadm status` to check for conflicts with any existing dotfiles.'
