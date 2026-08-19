# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## crash-safe history

# Append each command to ~/.bash_history immediately, not just on clean shell
# exit, so a hard crash (frozen GPU driver, forced power-cycle) cannot swallow
# whatever ran right before it, the way it did on 2026-08-13.
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

## aliases

alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

## history

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Note: erasedups only dedupes bash's in-memory history list; the crash-safe
# `history -a` above appends incrementally, so a duplicate line already
# flushed to disk can still remain in $HISTFILE.
export HISTCONTROL=ignoredups:erasedups

## sudo

complete -cf sudo

## user bins (must exist before mise builds PATH on top)

# Only prepend when missing, so re-sourcing .bashrc doesn't pile up
# duplicate PATH entries. Reused below for rebar3's bin dir too.
_path_prepend() {
  [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"
}

for _dir in "$HOME/.local/bin" "$HOME/bin" "$HOME/.claude/local"; do
  _path_prepend "$_dir"
done
unset _dir

## mise

eval "$(mise activate bash)"

## git

_git_completion="/usr/share/bash-completion/completions/git"
[ -r "$_git_completion" ] && source "$_git_completion"
unset _git_completion

# Re-evaluated on every prompt (not just once here) so verified commits keep
# working after detaching/reattaching a tmux session in a different terminal
# -- a $(tty) cached at shell startup goes stale and breaks `git commit -S`.
PROMPT_COMMAND="export GPG_TTY=\$(tty)${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

## erlang

export ERL_AFLAGS="-kernel shell_history enabled"
export MAKEFLAGS="-j$(nproc)"
export ERLC_USE_SERVER=true

## rebar3

_rebar3_completion="$HOME/git/erlang/rebar3/_build/default/completion.bash"

# Guarded on the completion file itself, not just the clone directory, so a
# partial bootstrap/install failure gets retried next shell instead of
# permanently skipping this block.
if [[ ! -r "$_rebar3_completion" ]]; then
  mkdir -p "$HOME/git/erlang"
  [[ -d "$HOME/git/erlang/rebar3" ]] || git clone https://github.com/erlang/rebar3.git "$HOME/git/erlang/rebar3"
  (
    cd "$HOME/git/erlang/rebar3" &&
    ./bootstrap &&
    ./rebar3 local install &&
    ./rebar3 completion --file "$_rebar3_completion"
  )
fi

[ -r "$_rebar3_completion" ] && source "$_rebar3_completion"
unset _rebar3_completion

_path_prepend "$HOME/.cache/rebar3/bin"
unset -f _path_prepend

## color scheme

# enable color support of ls and also add handy aliases
if [ -x "/usr/bin/dircolors" ]; then
  test -r "$HOME/.dircolors" && eval "$(dircolors -b $HOME/.dircolors)" || eval "$(dircolors -b)"
  alias ls="ls --color=auto"
  alias dir="dir --color=auto"
  alias vdir="vdir --color=auto"
  alias grep="grep --color=auto"
  alias fgrep="fgrep --color=auto"
  alias egrep="egrep --color=auto"
fi

# colored GCC warnings and errors
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

## liquidprompt

mkdir -p "$HOME/git/liquidprompt"
[[ -d "$HOME/git/liquidprompt/liquidprompt" ]] || git clone https://github.com/liquidprompt/liquidprompt.git "$HOME/git/liquidprompt/liquidprompt"
[[ -d "$HOME/git/liquidprompt/liquidprompt-powerline" ]] || git clone https://github.com/liquidprompt/liquidprompt-powerline.git "$HOME/git/liquidprompt/liquidprompt-powerline"

[ -r "$HOME/git/liquidprompt/liquidprompt/liquidprompt" ] && source "$HOME/git/liquidprompt/liquidprompt/liquidprompt"
[ -r "$HOME/git/liquidprompt/liquidprompt-powerline/powerline.theme" ] && source "$HOME/git/liquidprompt/liquidprompt-powerline/powerline.theme"

if declare -F _lp_powerline_theme_prompt >/dev/null; then
  # Put the input cursor on its own line below the powerline bar instead of
  # right after it. Wraps the theme's prompt function rather than editing the
  # vendored file, so it survives `git pull` on liquidprompt-powerline.
  eval "$(echo "_lp_powerline_theme_prompt_orig ()"; declare -f _lp_powerline_theme_prompt | tail -n +2)"
  _lp_powerline_theme_prompt() {
      _lp_powerline_theme_prompt_orig
      PS1+=$'\n\$ '
  }
fi

declare -F lp_theme >/dev/null && lp_theme "powerline"
