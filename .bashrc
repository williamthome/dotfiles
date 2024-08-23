# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## aliases

alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

## history

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

export HISTCONTROL=ignoredups:erasedups

## sudo

complete -cf sudo

## asdf

source "$HOME/.asdf/asdf.sh"
source "$HOME/.asdf/completions/asdf.bash"

## git

source "/usr/share/bash-completion/completions/git"
export GPG_TTY=$(tty) # verified commits

## erlang

export ERL_AFLAGS="-kernel shell_history enabled"
export MAKEFLAGS=-j8
export ERLC_USE_SERVER=true

## rebar3

if [[ ! -e "$HOME/git/erlang/rebar3" ]]; then
  # Ensure the directory exists
  mkdir -p "$HOME/git/erlang"
  # Clone the repository
  git clone https://github.com/erlang/rebar3.git "$HOME/git/erlang/rebar3"
  # Bootstrap, install and generate completion
  cd $HOME/git/erlang/rebar3
  ./bootstrap
  ./rebar3 local install
  ./rebar3 completion --file _build/default/completion.bash
  cd $HOME
fi

source "$HOME/git/erlang/rebar3/_build/default/completion.bash"
export PATH=$HOME/.cache/rebar3/bin:$PATH

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

# Only load Liquid Prompt in interactive shells, not from a script or from scp
if [[ $- = *i* ]]; then
  if [[ ! -e "$HOME/git/liquidprompt" ]]; then
    mkdir -p "$HOME/git/liquidprompt"
    git clone https://github.com/liquidprompt/liquidprompt.git "$HOME/git/liquidprompt/liquidprompt"
    git clone https://github.com/liquidprompt/liquidprompt-powerline.git "$HOME/git/liquidprompt/liquidprompt-powerline"
  fi

  source "$HOME/git/liquidprompt/liquidprompt/liquidprompt"
  source "$HOME/git/liquidprompt/liquidprompt-powerline/powerline.theme"
  lp_theme "powerline"
fi
