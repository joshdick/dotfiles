# Awesome platform-independent ls formatting
# Adapted from code found at <http://www.reddit.com/r/linux/comments/hejra/til_nifty_ls_option_for_displaying_directories/c1utfxb>
GLS_ARGS="--classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable --group-directories-first"
alias ls="ls $GLS_ARGS"
ls &> /dev/null
if [ $? -eq 1 ]; then # The environment ls isn't GNU ls; we're not on Linux
  # On OS X, use gls if it has been installed via Homebrew
  if hash gls &> /dev/null; then
    alias ls="gls $GLS_ARGS"
  else
    alias ls='ls -G' # If not, fall back to BSD ls
  fi
fi

# Some of these aliases were found at <https://github.com/zan5hin/dotfiles/blob/master/.zsh/aliases>

alias lsd='ls -lah | grep "^d"'
alias grep='grep --color'
alias hgrep='history 1 | grep $1'
alias scpresume='rsync --partial --progress --rsh=ssh'
alias mirror='wget -H -r --level=1 -k -p $1'
alias ip="curl icanhazip.com"
alias cpu='top -o cpu'
alias mem='top -o rsize' # memory

# Mac-specific aliases

alias f="open -a Finder ./"
alias lsappstore="mdfind kMDItemAppStoreHasReceipt=1"
alias flushdns="sudo killall -HUP mDNSResponder"

# Git aliases

alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gclean='find . -name ".git" -type d -exec echo "Cleaning {}..." \; -exec git --git-dir="{}" gc --aggressive --quiet \;'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff'
alias gdeletemerged='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias gds='git diff --staged'
alias gdt='git difftool'
alias gdtd='git difftool -d'
alias gdtds='git difftool -d --staged'
alias gdts='git difftool --staged'
alias gf='git fuzzy'
alias gfa='git fuzzy add'
alias gfco='git fuzzy checkout'
alias gfr='git fuzzy reset'
alias gkeywords='git log --pretty=format:'%s' | cut -d " " -f 1 | sort | uniq -c | sort -nr'
alias gl='git log-pretty'
alias glg='git log-hist'
alias glgi='git log-hist --simplify-by-decoration'
alias gli='git log-pretty --simplify-by-decoration'
alias gm='git merge'
alias gmf='git merge --ff'
alias gp='git push'
alias gprune='git remote prune origin'
alias gpu='git pull'
alias gpur='git pull --rebase'
alias gr='while [ ! -d .git ]; do cd ..; done'
alias gs='git status -sb'
alias gt='cd "$(git rev-parse --show-toplevel)"'
