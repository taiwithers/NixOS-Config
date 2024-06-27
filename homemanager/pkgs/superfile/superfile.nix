{
  config,
  app-themes,
  ...
}: let
  spfDir = "${config.xdg.configHome}/superfile";
  chroma-highlighting-theme = "vulcan";
  # base16-snazzy, catppuccin-mocha, gruvbox, monokai, vulcan
  # https://github.com/alecthomas/chroma/tree/master/styles
in {
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

  xdg.configFile."${spfDir}/theme/base16.toml".text = with app-themes.palettes.superfile; ''
    code_syntax_highlight = "${chroma-highlighting-theme}"

    # ========= Border =========
    file_panel_border = "#${base02}"
    sidebar_border = "#${base00}"
    footer_border = "#${base02}"

    # ========= Border Active =========
    file_panel_border_active = "#${base07}"
    sidebar_border_active = "#${base08}"
    footer_border_active = "#${base0B}"
    modal_border_active = "#${base0F}"

    # ========= Background (bg) =========
    full_screen_bg = "#${base00}"
    file_panel_bg = "#${base00}"
    sidebar_bg = "#${base00}"
    footer_bg = "#${base00}"
    modal_bg = "#${base00}"

    # ========= Foreground (fg) =========
    full_screen_fg = "#${base05}"
    file_panel_fg = "#${base05}"
    sidebar_fg = "#${base05}"
    footer_fg = "#${base05}"
    modal_fg = "#${base05}"

    # ========= Special Color =========
    cursor = "#${base0C}"
    correct = "#${base0C}"
    error = "#${base08}"
    hint = "#${base05}"
    cancel = "#${base0A}"
    # Gradient color can only have two color!
    gradient_color = ["#${base0D}", "#${base0E}"]

    # ========= File Panel Special Items =========
    file_panel_top_directory_icon = "#${base0B}"
    file_panel_top_path = "#${base0D}"
    file_panel_item_selected_fg = "#${base0F}"
    file_panel_item_selected_bg = "#${base01}"

    # ========= Sidebar Special Items =========
    sidebar_title = "#${base0F}"
    sidebar_item_selected_fg = "#${base0F}"
    sidebar_item_selected_bg = "#${base00}"
    sidebar_divider = "#${base04}"

    # ========= Modal Special Items =========
    modal_cancel_fg = "#${base06}"
    modal_cancel_bg = "#${base0A}"

    modal_confirm_fg = "#${base06}"
    modal_confirm_bg = "#${base03}"

    # ========= Help Menu =========
    help_menu_hotkey = "#${base0C}"
    help_menu_title = "#${base0A}"
  '';
}
