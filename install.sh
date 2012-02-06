#!/bin/sh

# Install script for Josh Dick's dotfiles
# <https://github.com/joshdick/dotfiles>

SELF=`readlink -f $0` # Path to this script
SELF_PATH=`dirname $SELF` # Path to the directory containing this script

for file in `find $SELF_PATH -maxdepth 1 -name \*.symlink`; do
  src_file=`basename "$file"`
  dest_file=`echo "$HOME/.$src_file" | sed "s/\.symlink$//g"`
  if [ -e $dest_file ]; then
    echo "$dest_file already exists; skipping it..."
  else
    ln -sv $SELF_PATH/$src_file $dest_file
  fi
done
