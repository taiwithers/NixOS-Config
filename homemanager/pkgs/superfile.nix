{
  config,
  pkgs,
  app-themes,
  ...
}: let
  spfDir = "${config.xdg.configHome}/superfile";
  chroma-highlighting-theme = "vulcan";
in
  # base16-snazzy, catppuccin-mocha, gruvbox, monokai, vulcan
  # https://github.com/alecthomas/chroma/tree/master/styles
  {
    home.packages = [pkgs.superfile];
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

    xdg.configFile."${spfDir}/config.toml".text =
      # TOML
      ''
        # More details are at https://superfile.netlify.app/configure/superfile-config/

        auto_check_update = true
        cd_on_quit = true # additional configuration necessary, see docs
        default_directory = '.'
        default_open_file_preview = true
        file_size_use_si = false

        # ================   Style =================
        theme = 'base16'
        nerdfont = true
        transparent_background = false # only works when your terminal background is transparent

        # File preview width allow '0' (this mean same as file panel),'x' x must be less than 10 and greater than 1 (This means that the width of the file preview will be one xth of the total width.)
        file_preview_width = 0

        # The length of the sidebar. If you don't want to display the sidebar, you can input 0 directly. If you want to display the value, please place it in the range of 3-20.
        sidebar_width = 20

        # Border style
        border_top = '━'
        border_bottom = '━'
        border_left = '┃'
        border_right = '┃'
        border_top_left = '┏'
        border_top_right = '┓'
        border_bottom_left = '┗'
        border_bottom_right = '┛'
        border_middle_left = '┣'
        border_middle_right = '┫'

        # ==========PLUGINS========== #

        # Show more detailed metadata, please install exiftool before enabling this plugin!
        metadata = false
        # Enable MD5 checksum generation for files
        enable_md5_checksum = false
      '';

    xdg.configFile."${spfDir}/hotkeys.toml".text =
      # TOML
      ''
        # =================================================================================================
        # Global hotkeys (cannot conflict with other hotkeys)
        confirm = ['enter', 'space']
        quit = ['q', 'esc']
        # movement
        list_up = ['up', 'k']
        list_down = ['down', 'j']
        # file panel control
        create_new_file_panel = ['n', \'\']
        close_file_panel = ['w', \'\']
        next_file_panel = ['tab', \'\']
        previous_file_panel = ['shift+tab', \'\']
        toggle_file_preview_panel = ['f', \'\']
        # change focus
        focus_on_process_bar = ['P', \'\']
        focus_on_sidebar = ['S', \'\']
        focus_on_metadata = ['M', \'\']
        # create file/directory and rename
        file_panel_item_create = ['c', \'\']
        file_panel_item_rename = ['r', \'\']
        # file operations
        copy_items = ['ctrl+c', 'y']
        cut_items = ['ctrl+x', 'x']
        paste_items = ['ctrl+v', 'p']
        delete_items = ['ctrl+d', 'delete', 'd']
        # compress and extract
        extract_file = ['ctrl+e', \'\']
        compress_file = ['ctrl+a', \'\']
        # editor
        open_file_with_editor = ['e', \'\']
        open_current_directory_with_editor = ['E', \'\']
        # other
        pinned_directory = ['ctrl+p', \'\']
        toggle_dot_file = ['.', \'\']
        change_panel_mode = ['v', \'\']
        open_help_menu = ['?', \'\']
        open_command_line = [':', \'\']

        # =================================================================================================
        # Typing hotkeys (can conflict with all hotkeys)
        confirm_typing = ['enter', \'\']
        cancel_typing = ['ctrl+c', 'esc']

        # =================================================================================================
        # Normal mode hotkeys (can conflict with other modes, cannot conflict with global hotkeys)
        parent_directory = ['h', 'left', "backspace"]
        search_bar = ['/', 'ctrl+f']

        # =================================================================================================
        # Select mode hotkeys (can conflict with other modes, cannot conflict with global hotkeys)
        file_panel_select_mode_items_select_down = ['shift+down', 'J']
        file_panel_select_mode_items_select_up = ['shift+up', 'K']
        file_panel_select_all_items = ['A', \'\']
      '';

    xdg.configFile."${spfDir}/theme/base16.toml".text = with app-themes.palettes.superfile;
    # TOML
      ''
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
