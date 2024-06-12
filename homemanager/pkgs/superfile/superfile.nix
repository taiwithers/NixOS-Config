{
  config,
  theme-config,
  ...
}: let
  spfDir = "${config.xdg.configHome}/superfile";
  colours = theme-config.app-themes.superfile;
  chroma-highlighting-theme = "average";
  # api
  # https://github.com/alecthomas/chroma/tree/master/styles
in {
  home.shellAliases."spf" = "superfile";

  xdg.configFile."${spfDir}/config.toml".source = ./config.toml;
  xdg.configFile."${spfDir}/hotkeys.toml".source = ./hotkeys.toml;
  xdg.configFile."${spfDir}/theme/base16.toml".text = ''

    # If you want to make sidebar border display just set it same as sidebar background color

    # Code syntax highlight theme (you can go to https://github.com/alecthomas/chroma/blob/master/styles to find one you like)
    code_syntax_highlight = "${chroma-highlighting-theme}"

    # ========= Border =========
    file_panel_border = "#${colours.base02}"
    sidebar_border = "#${colours.base00}"
    footer_border = "#${colours.base02}"

    # ========= Border Active =========
    file_panel_border_active = "#${colours.base07}"
    sidebar_border_active = "#${colours.base08}"
    footer_border_active = "#${colours.base0B}"
    modal_border_active = "#${colours.base0F}"

    # ========= Background (bg) =========
    full_screen_bg = "#${colours.base00}"
    file_panel_bg = "#${colours.base00}"
    sidebar_bg = "#${colours.base00}"
    footer_bg = "#${colours.base00}"
    modal_bg = "#${colours.base00}"

    # ========= Foreground (fg) =========
    full_screen_fg = "#${colours.base06}"
    file_panel_fg = "#${colours.base06}"
    sidebar_fg = "#${colours.base06}"
    footer_fg = "#${colours.base06}"
    modal_fg = "#${colours.base06}"

    # ========= Special Color =========
    cursor = "#${colours.base0C}"
    correct = "#${colours.base0C}"
    error = "#${colours.base08}"
    hint = "#${colours.base05}"
    cancel = "#${colours.base0A}"
    # Gradient color can only have two color!
    gradient_color = ["#${colours.base0D}", "#${colours.base0E}"]

    # ========= File Panel Special Items =========
    file_panel_top_directory_icon = "#${colours.base0B}"
    file_panel_top_path = "#${colours.base0D}"
    file_panel_item_selected_fg = "#${colours.base0F}"
    file_panel_item_selected_bg = "#${colours.base01}"

    # ========= Sidebar Special Items =========
    sidebar_title = "#${colours.base0F}"
    sidebar_item_selected_fg = "#${colours.base0F}"
    sidebar_item_selected_bg = "#${colours.base00}"
    sidebar_divider = "#${colours.base04}"

    # ========= Modal Special Items =========
    modal_cancel_fg = "#${colours.base06}"
    modal_cancel_bg = "#${colours.base0A}"

    modal_confirm_fg = "#${colours.base06}"
    modal_confirm_bg = "#${colours.base03}"

    # ========= Help Menu =========
    help_menu_hotkey = "#${colours.base0C}"
    help_menu_title = "#${colours.base0A}"
  '';
}