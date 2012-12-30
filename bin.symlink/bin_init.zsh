# The path to the directory containing this script
PERSONAL_BIN=~/.bin

# Add the personal bin to PATH
export PATH=$PATH:$PERSONAL_BIN

# Set up git prompt
. $PERSONAL_BIN/git_prompt/git_prompt.zsh

# Set up z <https://github.com/rupa/z>
. $PERSONAL_BIN/z/z.sh

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

# Set up zsh-syntax-highlighting <https://github.com/zsh-users/zsh-syntax-highlighting>
source $PERSONAL_BIN/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Set up zsh-history-substring-search <https://github.com/zsh-users/zsh-history-substring-search>
source $PERSONAL_BIN/zsh-history-substring-search/zsh-history-substring-search.zsh

# Set up cdd <https://github.com/jestor/cdd>
alias cdd="$PERSONAL_BIN/cdd/cdd.sh"
