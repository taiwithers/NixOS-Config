{
  config,
  pkgs,
  ...
}: {
  home.shellAliases = {
    "htop" = "echo 'Did you mean btm?'";
    "bbtm" = "btm --basic --hide_avg_cpu";
  };
  home.packages = [pkgs.bottom];
  programs.bottom.enable = true;
  xdg.configFile."${config.xdg.configHome}/bottom/bottom.toml".text = let
    simplelayout = ''
      [[row]]
       ratio=1
       [[row.child]]
        type="cpu"
        ratio=7
       [[row.child]]
        type="mem"
        ratio = 3
      [[row]]
       ratio=1
       type="proc"
       default = true
    '';

    fancylayout = ''
      [[row]]
       ratio=1
       [[row.child]]
        type="cpu"
        ratio=7
       [[row.child]]
        type="temp"
        ratio = 3
      [[row]]
         ratio=3
         [[row.child]]
           ratio=1
           [[row.child.child]]
             type="mem"
           [[row.child.child]]
             type="net"
         [[row.child]]
           ratio=2
           type="proc"
           default = true
    '';
  in
    # TOML
    ''
        # This group of options represents a command-line flag/option.  Flags explicitly
      # added when running (ie: btm -a) will override this config file if an option
      # is also set here.

      [flags]
      hide_avg_cpu = false # Whether to hide the average cpu entry.
      dot_marker = false # Whether to use dot markers rather than braille.
      rate = "1s" # The update rate of the application.
      left_legend = false # Whether to put the CPU legend to the left.
      current_usage = false # Whether to set CPU% on a process to be based on the total CPU or just current usage.
      unnormalized_cpu = false # Whether to set CPU% on a process to be based on the total CPU or per-core CPU% (not divided by the number of cpus).
      group_processes = false # Whether to group processes with the same name together by default.
      case_sensitive = false # Whether to make process searching case sensitive by default.
      whole_word = false # Whether to make process searching look for matching the entire word by default.
      regex = false # Whether to make process searching use regex by default.
      temperature_type = "celsius"
      default_time_value = "60s" # The default time interval (in milliseconds).
      time_delta = 15000 # The time delta on each zoom in/out action (in milliseconds).
      hide_time = false # Hides the time scale.
      default_widget_type = "proc" # Override layout default widget
      default_widget_count = 1
      expanded_on_startup = false # Expand selected widget upon starting the app
      basic = false # Use basic mode
      use_old_network_legend = false # Use the old network legend style
      hide_table_gap = false # Remove space in tables
      battery = false # Show the battery widgets
      disable_click = false # Disable mouse clicks
      color = "default" # Built-in themes.  Valid values are "default", "default-light", "gruvbox", "gruvbox-light", "nord", "nord-light"
      mem_as_value = false # Show memory values in the processes widget as values by default
      tree = true # Show tree mode by default in the processes widget.
      show_table_scroll_position = false # Shows an indicator in table widgets tracking where in the list you are.
      process_command = false # Show processes as their commands by default in the process widget.
      network_use_binary_prefix = false # Displays the network widget with binary prefixes.
      network_use_bytes = false # Displays the network widget using bytes.
      network_use_log = false # Displays the network widget with a log scale.
      disable_advanced_kill = false # Hides advanced options to stop a process on Unix-like systems.
      enable_gpu_memory = false # Shows GPU(s) memory
      enable_cache_memory = false # Shows cache and buffer memory
      retention = "10m" # How much data is stored at once in terms of time.

      # These are flags around the process widget.

      [processes]
      columns = ["PID", "Name", "CPU%", "Mem%", "User", "State"]

      # These are all the components that support custom theming.  Note that colour support will depend on terminal support.
      [colors] # Uncomment if you want to use custom colors
      table_header_color="Blue" # Represents the colour of table headers (processes, CPU, disks, temperature).
      widget_title_color="Gray" # Represents the colour of the label each widget has.
      avg_cpu_color="Red" # Represents the average CPU color.
      cpu_core_colors=["Magenta", "Yellow", "Cyan", "Green", "Blue", "Red", "LightCyan", "LightBlue", "LightRed"] # Represents the colour the core will use in the CPU legend and graph.
      ram_color="Magenta" # Represents the colour RAM will use in the memory legend and graph.
      swap_color="Yellow" # Represents the colour SWAP will use in the memory legend and graph.
      arc_color="Cyan" # Represents the colour ARC will use in the memory legend and graph.
      gpu_core_colors=["Green", "Blue", "Red", "Cyan", "Green", "Blue", "Red"] # Represents the colour the GPU will use in the memory legend and graph.
      rx_color="Cyan" # Represents the colour rx will use in the network legend and graph.
      tx_color="Green" # Represents the colour tx will use in the network legend and graph.
      border_color="Gray" # Represents the colour of the border of unselected widgets.
      highlighted_border_color="Blue" # Represents the colour of the border of selected widgets.
      text_color="Gray" # Represents the colour of most text.
      selected_text_color="Black" # Represents the colour of text that is selected.
      selected_bg_color="Blue" # Represents the background colour of text that is selected.
      graph_color="Gray" # Represents the colour of the lines and text of the graph.
      # Represents the colours of the battery based on charge
      high_battery_color="green"
      medium_battery_color="yellow"
      low_battery_color="red"

      # Layout - layouts follow a pattern like this:
      # [[row]] represents a row in the application.
      # [[row.child]] represents either a widget or a column.
      # [[row.child.child]] represents a widget.

      # All widgets must have the type value set to one of ["cpu", "mem", "proc", "net", "temp", "disk", "empty"].
      # All layout components have a ratio value - if this is not set, then it defaults to 1.
      # The default widget layout:
      ${fancylayout}

      # Filters - you can hide specific temperature sensors, network interfaces, and disks using filters.  This is admittedly
      # a bit hard to use as of now, and there is a planned in-app interface for managing this in the future:
      #[disk_filter]
      #is_list_ignored = true
      #list = ["/dev/sda\\d+", "/dev/nvme0n1p2"]
      #regex = true
      #case_sensitive = false
      #whole_word = false

      #[mount_filter]
      #is_list_ignored = true
      #list = ["/mnt/.*", "/boot"]
      #regex = true
      #case_sensitive = false
      #whole_word = false

      #[temp_filter]
      #is_list_ignored = true
      #list = ["cpu", "wifi"]
      #regex = false
      #case_sensitive = false
      #whole_word = false

      #[net_filter]
      #is_list_ignored = true
      #list = ["virbr0.*"]
      #regex = true
      #case_sensitive = false
      #whole_word = false

    '';
}
