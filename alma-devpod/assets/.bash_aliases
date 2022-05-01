################################
#### Generic system aliases ####
################################

# safety aliases
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# try to use 'colormake' for 'make'
which colormake 1>/dev/null 2>&1
if [ $? -eq 0 ]; then
  alias make='colormake'
  alias mk='colormake'
fi
