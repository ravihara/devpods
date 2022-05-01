# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# umask settings
umask 022

# Terminal settings for system debug related params
ulimit -c unlimited

# User specific build environment
PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"
LD_LIBRARY_PATH="/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH"
PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:/usr/lib64/pkgconfig:$PKG_CONFIG_PATH"

# For GNUPG v2.0
export GPG_TTY=$(tty)

# GCC toolkit settings
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Docker settings
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=0

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# 'starship' configuration
which starship 1>/dev/null 2>&1
if [ $? -eq 0 ]; then
  eval "$(starship init bash)"
fi

# aws-cli with bash autocomplete
which aws_completer 1>/dev/null 2>&1
if [ $? -eq 0 ]; then
  complete -C $(which aws_completer) aws
fi

# asdf-vm configuration
if [ -d "$HOME/.asdf" ]; then
  . $HOME/.asdf/asdf.sh
  . $HOME/.asdf/completions/asdf.bash

  [[ -n "$(ls $HOME/.asdf/installs/java/ 2>/dev/null)" ]] && . $HOME/.asdf/plugins/java/set-java-home.bash
fi

# User specific aliases and functions
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

## This MUST be the last one ##
[[ -n "$(command -v normalize_build_env 2>/dev/null)" ]] && normalize_build_env
