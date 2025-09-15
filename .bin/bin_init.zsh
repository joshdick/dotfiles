# The folder containing this script.
# Fancy folder detection found at <http://stackoverflow.com/a/1820039/278810>.
SELF="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

# Add the folder containing this script to PATH.
export PATH="$SELF:$PATH"

# Set up z <https://github.com/rupa/z>.
. $SELF/repos/z/z.sh

# Set up pyautoenv <https://github.com/hsaunders1904/pyautoenv>.
. $SELF/repos/pyautoenv/pyautoenv.plugin.zsh

# Set up tmuxomatic <https://github.com/oxidane/tmuxomatic>
# (since symlinking it into ~/.bin confuses Python.)
alias tmuxomatic=~/.bin/repos/tmuxomatic/tmuxomatic
