#!/bin/bash

# Install script for Josh Dick's dotfiles
# <https://github.com/joshdick/dotfiles>

# Uncomment the following line to delete all symlinks at the root of $HOME - useful for reinstalls
# find "$HOME" -maxdepth 1 -lname '*' -exec rm {} \;

SELF_PATH="$( cd "$( dirname "$0" )" && pwd )" # Path to the directory containing this script

# Create symlinks
for file in `find $SELF_PATH -maxdepth 1 -name \*.symlink`; do
  src_file=`basename "$file"`
  dest_file=`echo "$HOME/.$src_file" | sed "s/\.symlink$//g"`
  if [ -e $dest_file ]; then
    echo "$dest_file already exists; skipping it..."
  else
    ln -sv $SELF_PATH/$src_file $dest_file
  fi
done

# Initialize git submodules
START_PATH=$PWD
cd "$SELF_PATH"
git submodule init && git submodule update
cd "$START_PATH"
