{
  config,
  theme-config,
  ...
}: let
  spfDir = "${config.xdg.configHome}/superfile";
  colours = theme-config.app-themes.superfile;
  chroma-highlighting-theme = "vulcan";
  # base16-snazzy, catppuccin-mocha, gruvbox, monokai, vulcan
  # https://github.com/alecthomas/chroma/tree/master/styles
in {
  # home.shellAliases."spf" = "superfile";
  programs.bash.bashrcExtra = ''
    spf() {
        os=$(uname -s)

        # Linux
        if [[ "$os" == "Linux" ]]; then
            export SPF_LAST_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/superfile/lastdir"
        fi

        # macOS
        if [[ "$os" == "Darwin" ]]; then
            export SPF_LAST_DIR="$HOME/Library/Application Support/superfile/lastdir"
        fi

        command superfile "$@"

        [ ! -f "$SPF_LAST_DIR" ] || {
            . "$SPF_LAST_DIR"
            rm -f -- "$SPF_LAST_DIR" > /dev/null
        }
    }
  '';

  xdg.configFile."${spfDir}/config.toml".source = ./config.toml;
  xdg.configFile."${spfDir}/hotkeys.toml".source = ./hotkeys.toml;
}
