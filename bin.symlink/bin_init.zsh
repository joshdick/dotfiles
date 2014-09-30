# The path to the directory containing this script
PERSONAL_BIN=~/.bin

# Add the personal bin to PATH
export PATH=$PATH:$PERSONAL_BIN

# Adds the given path (relative to personal bin) to PATH
function addToPATH() {
  export PATH=$PATH:$PERSONAL_BIN/$1
}

# Set up fasd <https://github.com/clvv/fasd>
addToPATH fasd
eval "$(fasd --init auto)"

# Set up resty <https://github.com/micha/resty>
. $PERSONAL_BIN/resty/resty

# set up formd
addToPATH formd

# Set up git-dude <https://github.com/sickill/git-dude>
addToPATH git-dude

# Set up git-cr <https://github.com/joshdick/git-cr>
addToPATH git-cr

# Set up hr <https://github.com/LuRsT/hr>
addToPATH hr

# Set up pytograph <https://github.com/joshdick/pytograph>
addToPATH pytograph

# Set up tmuxomatic <https://github.com/oxidane/tmuxomatic>
addToPATH tmuxomatic

# Set up fzf <https://github.com/junegunn/fzf>
alias fzf="$PERSONAL_BIN/fzf/fzf"
