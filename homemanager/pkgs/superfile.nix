{
  config,
  theme-config,
  ...
}: let
  spfDir = "${config.xdg.configHome}/superfile";
in {
  home.shellAliases."spf" = "superfile";
  # main config file
  xdg.configFile."${spfDir}/config.toml".text = ''
    # More details are at https://superfile.netlify.app/configure/superfile-config/

    auto_check_update = true
    cd_on_quit = false
    default_directory = '.'
    default_open_file_preview = true
    file_size_use_si = false

    # ================   Style =================
    theme = 'catpuccin'
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
}
