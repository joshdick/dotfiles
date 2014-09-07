# The path to the directory containing this script
PERSONAL_BIN=~/.bin

# Add the personal bin to PATH
export PATH=$PATH:$PERSONAL_BIN

# Set up fasd <https://github.com/clvv/fasd>
export PATH=$PATH:$PERSONAL_BIN/fasd
eval "$(fasd --init auto)"

# Set up resty <https://github.com/micha/resty>
. $PERSONAL_BIN/resty/resty

# set up formd
export PATH=$PATH:$PERSONAL_BIN/formd

# Set up git-dude <https://github.com/sickill/git-dude>
export PATH=$PATH:$PERSONAL_BIN/git-dude

# Set up git-cr <https://github.com/joshdick/git-cr>
export PATH=$PATH:$PERSONAL_BIN/git-cr

# Set up pytograph <https://github.com/joshdick/pytograph>
export PATH=$PATH:$PERSONAL_BIN/pytograph

# Set up tmuxomatic <https://github.com/oxidane/tmuxomatic>
export PATH=$PATH:$PERSONAL_BIN/tmuxomatic

# Set up cdd <https://github.com/jestor/cdd>
alias cdd="$PERSONAL_BIN/cdd/cdd.sh"

# Set up fzf <https://github.com/junegunn/fzf>
alias fzf="$PERSONAL_BIN/fzf/fzf"
