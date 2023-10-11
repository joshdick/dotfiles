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

if hash bat &> /dev/null; then
  alias cat='bat'
fi

# Some of these aliases were found at <https://github.com/zan5hin/dotfiles/blob/master/.zsh/aliases>

alias colors='msgcat --color=test'
alias cpu='top -o cpu'
alias grep='grep --color'
alias ip="curl icanhazip.com"
alias lsd='ls -lah | grep "^d"'
alias lsescaped='ls -1 | sed "s/\ /\\\ /g" | tr "\n" " " | cat - <(echo)'
alias mem='top -o rsize' # memory
alias please='sudo $(fc -ln -1)' # or sudo $(history -p !!) for bash
alias rg="rg --smart-case --follow --hidden --glob '!.git'" # Make ripgrep always search hidden directories; <found at https://github.com/BurntSushi/ripgrep/issues/623#issuecomment-659909044>
alias rsyncresume='rsync -r --partial --progress --rsh=ssh -e "ssh -p 22"'
alias ssh='TERM=xterm-256color ssh'
alias wipe='echo -en "\033c\033[3J"'

# Mac-specific aliases

alias f="open -a Finder ./"
alias lsappstore="mdfind kMDItemAppStoreHasReceipt=1"
alias flushdns="sudo killall -HUP mDNSResponder"
# Imports Safari tab group contents into Anybox. Accepts clipboard contents of right-clicking on a tab group -> "Copy Links"
alias tabs2anybox="pbpaste | grep '^https*:\/\/' | xargs -I % open 'anybox://save?text=%'"
# For when ocspd is being dumb - https://majid.info/blog/ocspd-crashes/
alias ugh="sudo -s 'kill -9 $(pgrep ocspd); rm -rf /private/var/db/crls/*; rm -rf /private/var/db/crls/.fl*'"

# Git aliases

alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gclean='find . -name ".git" -type d -exec echo "Cleaning {}..." \; -exec git --git-dir="{}" gc --aggressive --quiet \;'
alias grclean="git branch -r --merged | grep origin | grep -v '>' | grep -v master | xargs -L1 | awk '{sub(/origin\//,\"\");print}' | xargs git push origin --delete"
alias gcm='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff'
alias gdeletemerged='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias gds='git diff --staged'
#alias gdt='git difftool -d' # see functions.zsh
alias gdtf='git difftool'
alias gdts='git difftool -d --staged'
alias gdtsf='git difftool --staged'
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
alias gp='git pull'
alias gpr='git pull --rebase'
alias gprune='git remote prune origin'
alias gpu='git push'
alias gr='cd "$(git rev-parse --show-superproject-working-tree --show-toplevel | head -n1)"'
alias gs='git status -sb'
alias gst='git showtool'
alias gt='cd "$(git rev-parse --show-toplevel)"'
