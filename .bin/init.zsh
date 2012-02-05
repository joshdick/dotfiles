# The path to the directory containing this script
PERSONAL_BIN=~/.bin

# Add the personal bin to PATH
export PATH=$PATH:$PERSONAL_BIN

# Set up z <https://github.com/rupa/z>
. $PERSONAL_BIN/z/z.sh

# Set up resty <https://github.com/micha/resty>
. $PERSONAL_BIN/resty/resty

# Set up git-dude <https://github.com/sickill/git-dude>
export PATH=$PATH:$PERSONAL_BIN/git-dude

# Set up gcr <https://github.com/joshdick/gcr>
export PATH=$PATH:$PERSONAL_BIN/gcr

# Set up zsh-syntax-highlighting <https://github.com/zsh-users/zsh-syntax-highlighting>
source $PERSONAL_BIN/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Set up zsh-history-substring-search <https://github.com/zsh-users/zsh-history-substring-search>
source $PERSONAL_BIN/zsh-history-substring-search/zsh-history-substring-search.zsh
