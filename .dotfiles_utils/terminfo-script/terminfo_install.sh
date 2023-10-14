#!/bin/bash
set -ue

# Installs necessary terminfo definitions for tmux and iTerm2

fatal() {
  echo 1>&2;
  echo "============" 1>&2;
  echo "Error: $1" 1>&2;
  exit 1
}

if ! hash tic &> /dev/null; then
  fatal "This script requires \`tic\`! Please install \`tic\` (probably via \`ncurses\`?), then try running this script again."
fi

if ! hash curl &> /dev/null; then
  fatal "This script requires \`curl\`! Please install \`curl\`, then try running this script again."
fi

# Path to this script
SELF_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# Based on < https://apple.stackexchange.com/questions/249307/tic-doesnt-read-from-stdin-and-segfaults-when-adding-terminfo-to-support-italic#comment309243_249307 >
mkdir -p ~/.terminfo
export TERMINFO=~/.terminfo
curl https://invisible-island.net/datafiles/current/terminfo.src.gz | gunzip > "$TERMINFO/terminfo.src"
tic -x -e tmux "$TERMINFO/terminfo.src"
tic -x -e tmux-256color "$TERMINFO/terminfo.src"
tic -x -e xterm-256color "$TERMINFO/terminfo.src"

tic -x "$SELF_PATH/terminfo/iterm2.terminfo"
