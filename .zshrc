# Josh Dick's .zshrc <https://joshdick.net>

# *** MISC ***

# Clear out and reset PATH in case .zshrc is sourced multiple times in one session (while making changes)
# Do this before anything else so that this file can override any default settings that may be in /etc/profile
export PATH=$(env -i bash --login --norc -c 'echo $PATH')

# Test whether a given command exists
# Adapted from <http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script/3931779#3931779>
function command_exists() {
  command -v "$1" &> /dev/null
}

# *** ZSH-SPECIFIC SETTINGS ***

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep nomatch prompt_subst correct inc_append_history interactivecomments share_history
unsetopt notify
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit && compinit
autoload -U colors && \colors # Enable colors in prompt, ensuring `colors` alias is not used

# *** ZSH KEYBOARD SETTINGS ***

# Adapted from <http://zshwiki.org/home/zle/bindkeys#reading_terminfo<Paste>>

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="$terminfo[khome]"
key[End]="$terminfo[kend]"
key[Insert]="$terminfo[kich1]"
key[Backspace]="$terminfo[kbs]"
key[Delete]="$terminfo[kdch1]"
key[Up]="$terminfo[kcuu1]"
key[Down]="$terminfo[kcud1]"
key[Left]="$terminfo[kcub1]"
key[Right]="$terminfo[kcuf1]"
key[PageUp]="$terminfo[kpp]"
key[PageDown]="$terminfo[knp]"

# setup key accordingly
[[ -n "$key[Home]"      ]] && bindkey -- "$key[Home]"      beginning-of-line
[[ -n "$key[End]"       ]] && bindkey -- "$key[End]"       end-of-line
[[ -n "$key[Insert]"    ]] && bindkey -- "$key[Insert]"    overwrite-mode
[[ -n "$key[Backspace]" ]] && bindkey -- "$key[Backspace]" backward-delete-char
[[ -n "$key[Delete]"    ]] && bindkey -- "$key[Delete]"    delete-char
[[ -n "$key[Up]"        ]] && bindkey -- "$key[Up]"        up-line-or-history
[[ -n "$key[Down]"      ]] && bindkey -- "$key[Down]"      down-line-or-history
[[ -n "$key[Left]"      ]] && bindkey -- "$key[Left]"      backward-char
[[ -n "$key[Right]"     ]] && bindkey -- "$key[Right]"     forward-char
[[ -n "$key[PageUp]"    ]] && bindkey -- "$key[PageUp]"    history-beginning-search-backward
[[ -n "$key[PageDown]"  ]] && bindkey -- "$key[PageDown]"  history-beginning-search-forward

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        echoti smkx
    }
    function zle-line-finish () {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# *** PROMPT FORMATTING ***

# Echoes a username/host string when connected over SSH (empty otherwise)
ssh_info() {
  [[ "$SSH_CONNECTION" != '' ]] && echo "%(!.%{$fg[red]%}.%{$fg[yellow]%})%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:" || echo ""
}

# Echoes information about Git repository status when inside a Git repository
git_info() {

  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  # Git branch/tag, or name-rev if on detached head
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  local AHEAD="%{$fg[red]%}⇡NUM%{$reset_color%}"
  local BEHIND="%{$fg[cyan]%}⇣NUM%{$reset_color%}"
  local MERGING="%{$fg[magenta]%}⚡︎%{$reset_color%}"
  local UNTRACKED="%{$fg[red]%}●%{$reset_color%}"
  local MODIFIED="%{$fg[yellow]%}●%{$reset_color%}"
  local STAGED="%{$fg[green]%}●%{$reset_color%}"

  local -a DIVERGENCES
  local -a FLAGS

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    FLAGS+=( "$MERGING" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
  GIT_INFO+=( "%{$fg[cyan]%}±" )
  [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
  GIT_INFO+=( "%{$fg[cyan]%}$GIT_LOCATION%{$reset_color%}" )
  echo "${(j: :)GIT_INFO}"

}

# Use ❯ as the non-root prompt character; # for root
# Change the prompt character color if the last command had a nonzero exit code
PS1="
\$(ssh_info)%{$fg[magenta]%}%~%u \$(git_info)
%(?.%{$fg[blue]%}.%{$fg[red]%})%(!.#.❯)%{$reset_color%} "

# *** HOMEBREW ***

if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  HOMEBREW_PREFIX="$(brew --prefix)"
fi

if command_exists brew; then
  # Assume Git was installed via Homebrew, and that the Git configuration below
  # should use Homebrew-provided locations instead of the defaults below
  GIT_BASH_COMPLETION_SOURCE="$HOMEBREW_PREFIX/etc/bash_completion.d/git-completion.bash"
  GIT_ZSH_COMPLETION_SOURCE="$HOMEBREW_PREFIX/share/zsh/site-functions/_git"
  GIT_DIFF_HIGHLIGHT_PATH="$HOMEBREW_PREFIX/share/git-core/contrib/diff-highlight"
else
  # Locations of the Git completion files for Arch Linux as of Git 1.8.1
  GIT_BASH_COMPLETION_SOURCE=/usr/share/git/completion/git-completion.bash
  GIT_ZSH_COMPLETION_SOURCE=/usr/share/git/completion/git-completion.zsh
  GIT_DIFF_HIGHLIGHT_PATH=~/.bin/diff-highlight-script
fi

# Set up diff-highlight
export PATH="$GIT_DIFF_HIGHLIGHT_PATH:$PATH"

# *** ZSH PLUGINS ***

# <https://github.com/zsh-users/zsh-syntax-highlighting>
. ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# <https://github.com/zsh-users/zsh-history-substring-search>
. ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# Bind up and down keys for zsh-history-substring-search
[[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" history-substring-search-up
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" history-substring-search-down

# <https://github.com/atuinsh/atuin>
if command_exists atuin; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# <https://github.com/junegunn/fzf>
. ~/.fzf.zsh
# Configure fzf to use `rg` or `ag` if available instead of `find`,
# since both are faster than `find` and have better filtering (.gitignore, node_modules, etc.)
# For use with fzf's Vim plugin(s).
if command_exists rg; then
  export FZF_DEFAULT_COMMAND='rg --smart-case --files --follow --no-ignore-vcs --hidden --glob "!{node_modules/*,.git/*}"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
elif command_exists ag; then
  export FZF_DEFAULT_COMMAND='ag -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Catppuccin Mocha theme for fzf, with transparent background
# <https://github.com/catppuccin/fzf>
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:-1,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# *** FUNCTIONS AND ALIASES ***

. ~/.zsh/functions.zsh
. ~/.zsh/aliases.zsh

# *** ENVIRONMENT ***

# Include any machine-specific configuration if it exists
test -e ~/.localrc && . ~/.localrc

# Editor - See if vim lives around these parts, otherwise fall back to nano
if command_exists nvim && [[ ! $(nvim --version | grep "NVIM v") =~ "0.7" ]]; then
  export EDITOR=nvim
  export VISUAL=nvim
elif command_exists vim; then
  export EDITOR=vim
  export VISUAL=vim
else
  export EDITOR=nano
  export VISUAL=nano
fi

export GIT_EDITOR="$HOME/.bin/git_editor"
export PAGER=less

# gpg-agent
if command_exists gpgconf; then
  export GPG_TTY=$(tty)
  unset SSH_AGENT_PID
  if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  fi
fi

# Emulate pgrep if missing (likely running macOS)
if ! command_exists pgrep; then
  alias pgrep=poorgrep
fi

# Emulate tree if missing (likely running macOS)
if ! command_exists tree; then
  alias tree=poortree
fi

# LSCOLORS - Default except for normal directories (first character) to replace hard-to-read blue
# For details, see manpage for ls
export LSCOLORS=Gxfxcxdxbxegedabagacad

# Attempt to set up Git completion for zsh as documented inside git-completion.zsh
if [ -r "$GIT_BASH_COMPLETION_SOURCE" ] && [ -r "$GIT_ZSH_COMPLETION_SOURCE" ]; then
  zstyle ':completion:*:*:git:*' script $GIT_BASH_COMPLETION_SOURCE
  # If it doesn't already exist, create a symlink to the zsh completion file as ~/.zsh/completion/_git.
  # If the file was copied via sync_home and isn't actually a symlink, it will be replaced with a symlink.
  [ ! -h ~/.zsh/completion/_git ] && mkdir -p ~/.zsh/completion && rm -f ~/.zsh/completion/_git && ln -s $GIT_ZSH_COMPLETION_SOURCE ~/.zsh/completion/_git
  # Add the ~/.zsh/completion directory to fpath so zsh can find it.
  fpath=(~/.zsh/completion $fpath)
fi

# <https://github.com/nodenv/nodenv>
# Initialize nodenv if it's installed (it may be installed via Homebrew)
NODENV_BIN_DIR="$HOME/.nodenv/bin"
test -d "$NODENV_BIN_DIR" && export PATH="$NODENV_BIN_DIR:$PATH"
if command_exists nodenv; then
  eval "$(nodenv init -)"
fi

# <https://github.com/rbenv/rbenv>
# Initialize rbenv if it's installed (it may be installed via Homebrew)
RBENV_BIN_DIR="$HOME/.rbenv/bin"
test -d "$RBENV_BIN_DIR" && export PATH="$RBENV_BIN_DIR:$PATH"
if command_exists rbenv; then
  eval "$(rbenv init -)"
fi

# Initialize a default Python virtualenv if one is configured in ~/.localrc
# (VIRTUALENV_ACTIVATOR should point to ./bin/activate)
if [ -n "$VIRTUALENV_ACTIVATOR" -a -r "$VIRTUALENV_ACTIVATOR" ]; then
  VIRTUAL_ENV_DISABLE_PROMPT=1 . "$VIRTUALENV_ACTIVATOR"
fi

# Initialize the "personal bin"
. ~/.bin/bin_init.zsh

# When connecting via ssh, always [re]attach to a terminal manager
# Adapted from code found at <http://involution.com/2004/11/17/1-32/> (now offline)
if command_exists tmux && [ -z $TMUX ]; then
  if [ "$SSH_TTY" != "" -a "$TERM" -a "$TERM" != "screen" -a "$TERM" != "dumb" ]; then
    pgrep tmux
    # $? is the exit code of pgrep; 0 means there was a result (tmux is already running)
    if [ $? -eq 0 ]; then
      tmux -u attach -d
    else
      tmux -u
    fi
  fi
fi

# ALL GLORY TO THE HYPNOTOAD
if command_exists cowsay && command_exists fortune; then
  fortune | cowsay -f ~/.hypnotoad.cow -W 60
fi
