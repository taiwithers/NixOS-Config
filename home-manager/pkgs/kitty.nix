{config, pkgs, app-themes, ...}:{
  programs.kitty = {
    enable = true;
    shellIntegration.enableBashIntegration = true;

    font = {
      name = "Intel One Mono";
      size = 10;
    };

    keybindings = {
      "kitty_mod+f5" = "load_config_file";
      "ctrl+shift+/" = "launch --location=split sh -c 'bat --style=plain --paging=always ~/.local/state/kitty-keybinds.txt'";

      # clipboard
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";

# scrolling
      "kitty_mod+home" = "scroll_home"; # scroll to top
      "kitty_mod+end" = "scroll_end"; # scroll to bottom
      "kitty_mod+up" = "scroll_to_prompt -1"; # scroll to previous prompt
      "kitty_mod+down" = "scroll_to_prompt 1"; # scroll to next prompt

# open in pager
      "kitty_mod+h" = "show_scrollback"; # show scrollback buffer in pager
      "kitty_mod+g" = "show_last_command_output"; # show output of last command in pager

# window (pane) & tab management
      "kitty_mod+n" = "launch --location=hsplit --cwd=current"; # new pane with same cwd
      "kitty_mod+m" = "launch --location=split --cwd=current"; # new pane with same cwd
      "kitty_mod+t" = "launch --cwd=current --type=tab"; # new tab with same cwd
      "kitty_mod+w" = "close_window";
      "kitty_mod+j" = "next_window"; 
      "kitty_mod+k" = "previous_window";
      "kitty_mod+r" = "start_resizing_window";
      "kitty_mod+s" = "focus_visible_window"; # swap pane focus with visual cue
      "ctrl+tab" = "next_tab";
      "ctrl+shift+tab" = "previous_tab";
      "kitty_mod+q" = "close_tab";

# fonts
      "kitty_mod+plus" = "change_font_size current +1.0";
      "kitty_mod+minus" = "change_font_size current -1.0";
    };

    settings = with app-themes.palettes.kitty; rec {
# keybindings
      kitty_mod = "ctrl+shift";
      clear_all_shortcuts = "yes"; # clear defaults
# appearance (excluding colours)
      tab_bar_edge = "top";
      background_opacity = "0.5";
      background_blur = 1;

# copy/paste behaviour
      copy_on_select = "clipboard";
      skip_trailing_spaces = "smart";

# other
      enable_audio_bell = "no";
      visual_bell_duration = "0.5";
      scrollback_pager = "bat";
# dynamic_background_opacity = "yes";
      notify_on_finish = "unfocused bell";

# colours
      background = "#${base00}";
      second_transparent_bg = background;
      foreground = "#${base07}";
      selection_background = foreground;
      selection_foreground = background;
      url_color = "#${base04}";
      cursor = "#${base07}";
      active_border_color = "#${base03}";
      inactive_border_color = "#${base01}";
      active_tab_background = background;
      active_tab_foreground = foreground;
      inactive_tab_background = "#${base01}";
      inactive_tab_foreground = "#${base04}";
      tab_bar_background = "#${base01}";
      wayland_titlebar_color = background;

# normal
      color0 = "#${base00}";
      color1 = "#${base08}";
      color2 = "#${base0B}";
      color3 = "#${base0A}";
      color4 = "#${base0D}";
      color5 = "#${base0E}";
      color6 = "#${base0C}";
      color7 = "#${base07}";

# bright
      color8 = "#${base03}";
      color9 = "#${base09}";
      color10 = "#${base01}";
      color11 = "#${base02}";
      color12 = "#${base04}";
      color13 = "#${base07}";
      color14 = "#${base0F}";
      color15 = "#${base07}";

# extended base16 colors
      color16 = "#${base09}";
      color17 = "#${base0F}";
      color18 = "#${base01}";
      color19 = "#${base02}";
      color20 = "#${base04}";
      color21 = "#${base05}";
    };
  };

  home.shellAliases = {
    icat = "kitten icat";  
  };

  home.activation.kitty-keybinds = config.lib.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.bat}/bin/bat ~/.config/kitty/kitty.conf | grep "map" | sed "s/^map //" | ${pkgs.gawk}/bin/awk '{$1 = sprintf("%-20s",$1)} 1' > ~/.local/state/kitty-keybinds.txt
  '';
}
