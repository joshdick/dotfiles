#!/bin/bash

# Install script for Josh Dick's dotfiles
# <https://github.com/joshdick/dotfiles>

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
pushd
cd $SELF_PATH
git submodule init && git submodule update
popd
