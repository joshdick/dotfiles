# Test whether a given command exists
# Adapted from http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script/3931779#3931779
# NOTE: This function is duplicated in .zshrc so that it doesn't have to depend on this file,
# but this shouldn't cause any issues
command_exists() {
  hash "$1" &> /dev/null
}

# On Mac OS X, cd to the path of the front Finder window
# Found at <http://brettterpstra.com/2013/02/09/quick-tip-jumping-to-the-finder-location-in-terminal>
cdf() {
  target=$(osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
  if [ "$target" != "" ]; then
    cd "$target" || return; pwd
  else
    echo 'No Finder window found' >&2
  fi
}

# Show a cheatsheet from https://cht.sh
cheat() {
  curl "https://cht.sh/$1"
}

# On Mac OS X, copies the contents of a text file to the clipboard
# Found at <http://brettterpstra.com/2013/01/15/clip-text-file-a-handy-dumb-service>
clip() {
  type=$(file "$1" | grep -c text)
  if [ "$type" -gt 0 ]; then
    cat "$@" | pbcopy
    echo "Contents of $1 are in the clipboard."
  else
    echo "File \"$1\" is not plain text."
  fi
}

# Found at <http://www.askapache.com/linux/zen-terminal-escape-codes.html#3rd_Dimension_Broken_Bash>
colortest() {
  x=$(tput op) y=$(printf %$((COLUMNS-6))s)
  for i in {0..256}
  do
    o=00$i
    echo -e "${o:${#o}-3:3}" "$(tput setaf "$i";tput setab "$i")""${y// /=}""$x"
  done
}

# Packs $2-$n into $1 depending on $1's extension
# Found at <http://pastebin.com/CTra4QTF>
compress() {
  if [[ $# -lt 2 ]]; then
    echo -e "\n$0() usage:"
    echo -e "\t$0 archive_file_name file1 file2 ... fileN"
    echo -e "\tcreates archive of files 1-N\n"
  else
    DEST=$1
    shift
    case $DEST in
      *.tar.bz2) tar -cvjf "$DEST" "$@" ;;
      *.tar.gz)  tar -cvzf "$DEST" "$@" ;;
      *.zip)     zip -r "$DEST" "$@" ;;
      *)         echo "Unknown file type - $DEST" ;;
    esac
  fi
}

# Retrieve dictionary definitions of words.
# Adapted from code found at <http://onethingwell.org/post/25644890287/a-shell-function-to-define-words>
define() {
  if [[ $# -ge 2 ]]; then
    echo "$0: too many arguments" >&2
    return 1
  else
    curl "dict://dict.org/d:$1"
  fi
}

# Transfer files to a specific machine depending on the currenlty-active network
# by choosing the corresponding host in SSH configuration.
dispatch () {
  local _gateway
  if [[ -z "$1" ]]; then
    echo "No file(s) given to dispatch!"
    return 1
  fi
  if [ "$(uname)" = "Darwin" ]; then
    _gateway=$(route -n get default &> /dev/null | grep gateway | tr -d ' ' | cut -f 2 -d ':')
  else
    # Will implicitly default to Internet if we can't determine the gateway
    if command_exists route; then
      _gateway=$(route -n | grep UG | awk '{print $2}' | tr -d ' ')
    fi
  fi
  if [ "$_gateway" = "192.168.7.1" ]; then
    echo "Dispatching files via the local network (LAN)..."
    rsync -avz --partial --progress -e "ssh josh@192.168.7.4" "$@" ":~/Desktop/"
  else
    if [[ -z "$DISPATCH_SSH_PROXY_COMMAND" ]]; then
      echo "\$DISPATCH_SSH_PROXY_COMMAND is not set, not taking any action!"
      return 2
    fi
    echo "Dispatching files via the Internet..."
    # https://stackoverflow.com/a/16144454/278810
    scp -r -o "ProxyCommand $DISPATCH_SSH_PROXY_COMMAND nc %h %p" "$@" josh@hermes:~/Desktop/
  fi
}

# Extracts archives
# Found at <http://pastebin.com/CTra4QTF>
extract() {
  case $@ in
    *.tar.bz2) tar -xvjf "$@"  ;;
    *.tar.gz)  tar -xvzf "$@"  ;;
    *.bz2)     bunzip2 "$@"  ;;
    *.rar)     unrar x "$@"  ;;
    *.gz)      gunzip "$@" ;;
    *.tar)     tar xf "$@" ;;
    *.tbz2)    tar -xvjf "$@"  ;;
    *.tgz)     tar -xvzf "$@"  ;;
    *.zip)     unzip "$@"    ;;
    *.xpi)     unzip "$@"    ;;
    *.Z)       uncompress "$@" ;;
    *.7z)      7z x "$@" ;;
    *.ace)     unace e "$@"  ;;
    *.arj)     arj -y e "$@" ;;
    *)         echo "'$@' cannot be extracted via $0()" ;;
  esac
}

# Visual Studio Code-enabled replacement for `gdt` alias.
gdt() {
  # If running inside Visual Stuido Code, use it if diffing a single file (it doesn't support directory diffs.)
  if [[ $# -eq 1 ]] && [ -f "$1" ] && [[ "$TERM_PROGRAM" == "vscode" ]]; then
    git difftool --tool vscode "$@"
  else
    git difftool -d "$@"
  fi
}

# "Smart show" for Git. Show what I most likely want to see at any given time.
gss() {
  git status &> /dev/null
  inside_git_repo=$?
  if [[ $inside_git_repo -eq 0 ]]; then

    git diff --quiet
    has_unstaged_changes=$?

    git diff --quiet --cached
    has_staged_changes=$?

    if [[ $has_unstaged_changes -eq 1 ]]; then
      echo "Showing diff of unstaged changes..."
      git difftool -d
    elif [[ $has_staged_changes -eq 1 ]]; then
      echo "Showing diff of staged changes..."
      git difftool -d --staged
    else
      echo "Showing last commit..."
      git difftool -d HEAD~1 HEAD
    fi

  else
    echo "Error: \"$0\" can only be used inside a Git repository."
  fi
}

# Search shell history
hgrep() {
  history 1 | grep "$1"
}

# On macOS, shows which applications are using which ports.
# https://x.com/seldo/status/1823126087423099192
macportbinds() {
  sudo lsof -iTCP -sTCP:LISTEN -n -P | awk 'NR>1 {print $9, $1, $2}' | sed 's/.*://' | while read port process pid; do echo "Port $port: $(ps -p $pid -o command= | sed 's/^-//') (PID: $pid)"; done | sort -n
}

# Convert a web page to Markdown.
md() {
  if ! command_exists html2text; then
    echo "Error: html2text must be installed (via \"pip install html2text\") in order to use $0."
    return 1
  fi
  if [[ $# -ne 1 ]]; then
    echo -e "\n$0() usage:"
    echo -e "\t$0 [URL]"
    return 1
  fi
  printf "[Source](%s)\n" "$1"
  wget -qO - "$1" | iconv -t utf-8 | html2text -b 0
}

# Get real disk usage statistics on MacOS.
# Based on < https://gist.github.com/chockenberry/f278781a36ce217c82a0d280765c3622 >.
mdf() {
  if [ "$(uname)" != "Darwin" ]; then
    echo "Error: $0() only works on MacOS, use /bin/df" >&2
    return 1
  elif [ ! -z "$*" ]; then
    echo "Error: This is $0(), use /bin/df" >&2
    return 1
  fi

  protect=`mount | grep -v "read-only" | grep "protect" | cut -f 3 -w`
  nosuid=`mount | grep -v "read-only" | grep "nosuid" | cut -f 3 -w`

  /bin/df -PH $protect $nosuid | cut -f 2- -w
}

# Calculate a hash of all files in the current directory.
# Adapted from code found at <http://stackoverflow.com/a/1658554/278810>
md5dir() {
  if command_exists gmd5sum; then
    md5Command='gmd5sum' # Mac (coreutils via Homebrew)
  elif command_exists md5; then
    md5Command='md5 -q' # Mac (native)
  elif command_exists md5sum; then
    md5Command='md5sum' # Linux
  else
    echo "Error: No md5 program available!"
    return 1
  fi
  eval "find . -type f -exec $md5Command {} + | cut -d ' ' -f 1 | sort | $md5Command | cut -d ' ' -f 1"
}

mirror() {
  wget -H -r --level=1 -k -p "$1"
}

# Poor-man's pgrep, for use on OS X where pgrep isn't available
poorpgrep() {
  echo "Warning: using poor-man's pgrep. Consider installing the \"proctools\" package via Homebrew."
  ps ax | awk "/(^|[^)])$1/ { print \$1 }"
}

# Poor man's tree, for use on OS X where tree isn't available
poortree() {
  echo "Warning: using poor-man's tree. Consider installing the \"tree\" package via Homebrew."
  ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}

# Shows how long processes have been up.
# No arguments shows all processes, one argument greps for a particular process.
# Found at <http://hints.macworld.com/article.php?story=20121127064752309>
psup() {
  ps acxo etime,command | grep -- "$1"
}

# Pushes local SSH public key to another box
# Adapted from code found at <https://github.com/rtomayko/dotfiles/blob/rtomayko/.bashrc>
push_ssh_cert() {
  if [[ $# -eq 0 || $# -gt 3 ]]; then
    echo "Usage: push_ssh_cert host [port] [username]"
    return
  fi
  local _host=$1
  local _port=22
  local _user=$USER
  if [[ $# -ge 2 ]]; then
    _port=$2
  fi
  if [[ $# -eq 3 ]]; then
    _user=$3
  fi
  test -f ~/.ssh/id_*sa.pub || ssh-keygen -t rsa
  echo "Pushing public key to $_user@$_host:$_port..."
  ssh -p "$_port" "$_user"@"$_host" 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_*sa.pub
}

# Find and replace a string in all files recursively, starting from the current directory.
# Adapted from code found at <http://forums.devshed.com/unix-help-35/unix-find-and-replace-text-within-all-files-within-a-146179.html>
replacein() {
  find . -type f -print0 | xargs perl -pi -e "s/$1/$2/g"
}

# `ripgrep` with output formatted by `delta`
rgd() {
  rg --json $* | delta
}

# Search for files by name
# Case-insensitive and allows partial search
# If on Mac OS X, will prompt to open the file if there is a single result
search() {
  results=$(find . -iname "*$1*")
  echo "$results"
  if command_exists open; then
    resultLength=$(echo "$results" | wc -l | sed -e "s/^[ \t]*//")
    if [ "$resultLength" -eq 1 ]; then
      while true; do
        echo "One result found! Open it? (y/n)?"
        read -r yn
        case $yn in
          [Yy]* ) open "$results"; break;;
          [Nn]* ) break;;
          * ) echo "Please answer (Y/y)es or (N/n)o.";;
        esac
      done
    fi
  fi
}

# To search for a given string inside every file with the given filename
# (wildcards allowed) in the current directory, recursively:
#   $ searchin filename pattern
#
# To search for a given string inside every file inside the current directory, recursively:
#   $ searchin pattern
searchin() {
  if [ -n "$2" ]; then
    find . -name "$1" -type f -exec grep -l "$2" {} \;
  else
    find . -type f -exec grep -l "$1" {} \;
  fi
}

# Serves the current directory over HTTP, on an optionally-specified port
# If on Mac OS X, opens in the default browser
serve() {
  port=$1
  if [ $# -ne  1 ]; then
    port=8000
  fi
  if command_exists open; then
    open http://localhost:"$port"/
  fi
  python3 -m http.server "$port"
}

# Updates stuff!
# * Performs a system update on Debian-based and Arch Linux systems
# * Updates all dotfiles Git submodules (including Vim packages)
# * Updates Homebrew packages on OS X
# * Updates pip/gem/npm
update() {

  heading() {
     printf "\e[1m\e[34m==>\e[39m %s\e[0m\n" "$1"
  }

  # Implicitly prevents usage of unrelated macOS `apt`
  if uname | grep -qi darwin; then
    if command_exists brew; then
      heading "[homebrew] Updating packages..."
      brew update && brew upgrade && brew cleanup
    fi
  else
    if command_exists apk; then
      heading "[apk] Updating system packages..."
      sudo sh -c "apk -U upgrade"
    elif command_exists apt; then
      heading "[apt] Updating system packages..."
      sudo sh -c "apt update && apt upgrade && apt clean && apt autoremove"
    elif command_exists pacman; then
      heading "[pacman] Updating system packages..."
      sudo sh -c "pacman -Syu && pacman -Scc"
    fi
  fi

  if command_exists yadm; then
    heading "[yadm] Updating dotfiles..."
    # Run in a subshell so the user's working directory doesn't change
    (yadm pull && yadm submodule update --recursive --checkout --remote --init)
  fi

  heading "[fzf] Updating fzf binary..."
  "$HOME"/.bin/repos/fzf/install --bin

  # Perform vim-related updates since corresponding Git submodules
  # (Vim packages) may have been updated.
  heading "[vim] Updating Vim helptags..."
  vim '+helptags ALL' +qall
  if command_exists nvim; then
    heading "[vim] Updating Neovim treesitter parsers..."
    nvim -c 'TSUpdate | q'
  fi

  if command_exists npm; then
    heading "[npm] Updating global packages..."
    npm --location=global update
  fi

  if command_exists pip; then
    pip_location="$(which pip)"
    # Only attempt to update `pip` packages if uisng a non-system `pip`.
    if test "${pip_location#*/home/}" != "$pip_location"; then
      heading "[pip] Updating global packages..."
      # Found at <https://stackoverflow.com/a/3452888>; assumes pip >= 22.3.
      pip --disable-pip-version-check list --outdated --format=json | python -c "import json, sys; print('\n'.join([x['name'] for x in json.load(sys.stdin)]))" | xargs -n1 pip install -U
    fi
  fi

  if command_exists gem; then
    gem_location="$(which gem)"
    # Only attempt to update `gem` packages if uisng a non-system `gem`.
    if test "${gem_location#*/home/}" != "$gem_location"; then
      heading "[gem] Updating global packages..."
      gem update
    fi
  fi
}
