__nix_bin="~/.nix-profile/bin"
if ! [[ "$PATH" =~ "$__nix_bin" ]]; then
    export PATH="$__nix_bin:$PATH"
fi
unset __nix_bin

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

# start ssh agent
# eval "$(ssh-agent -s)"