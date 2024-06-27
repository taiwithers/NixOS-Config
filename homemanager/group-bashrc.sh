# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# ...and home-manager and myself
__conda_setup="$('${homeDirectory}/.conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
condabin="${homeDirectory}/.conda/bin"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${homeDirectory}/.conda/etc/profile.d/conda.sh" ]; then
    . "${homeDirectory}/.conda/etc/profile.d/conda.sh"
    else
        if ! [[ $PATH =~ "$condabin" ]]; then
        export PATH="$PATH:$condabin"
    fi
    fi
fi
unset __conda_setup
unset condabin
# <<< conda initialize <<<

# mamba
mamba activate qstar
export MAMBA_NO_BANNER=1

# gaia
shopt -u expand_aliases
export STARLINK_DIR=~/star-2021A
source $STARLINK_DIR/etc/profile
shopt -s expand_aliases

# add texlive to path
export PATH=/home/twithers/opt/texlive/2023/bin/x86_64-linux:$PATH
export GPG_TTY=/dev/pts/0

# xdg dirs
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

# clean up ~
export HISTFILE="${XDG_STATE_HOME}"/bash_history
mkdir -p "$(dirname $HISTFILE)"
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export KERAS_HOME="${XDG_STATE_HOME}/keras"
export SQLITE_HISTORY="$XDG_CACHE_HOME"/sqlite_history
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
export USERXSESSIONRC="$XDG_CACHE_HOME/X11/xsessionrc"

# cod completion
source <(cod init $$ bash)
