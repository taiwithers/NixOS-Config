{config, ...}: {
  # activate ble.sh
  # programs.bash.bashrcExtra = ''
  #   source "$(blesh-share)"/ble.sh --rcfile=${config.xdg.configHome}/blerc
  #   [[ ''${BLE_VERSION-}  ]] && ble-attach
  # '';

  # xdg.configFile."${config.xdg.configHome}/blerc".text = ''
  # bleopt pager=bat
  # bleopt editor=vim
  # '';

  # style strings (not case sensitive)
  # bold, italic, underline, dimmed, inverted, blink, hidden, strikethrough, <color>, fg:<color>, bg:<color>, none
  # colors: black, red, green, blue, yellow, pruple, cyan, white, bright-<any of previous>, #hexcode, 0-255 ANSI code

  programs.starship.enable = true;
  programs.starship.settings = {
    format = "$username$hostname$battery$conda$custom$directory$git_branch$git_state$git_metrics$jobs$nix_shell$status$sudo$character";
    right_format = "$time";

    continuation_prompt = "> ";

    # modules
    battery = {
      disabled = false;
      format = "[$symbol$percentage]($style)";
      display = [
        {
          threshold = 50;
          style = "bold green";
        }
        {
          threshold = 30;
          style = "bold yellow";
        }
        {
          threshold = 10;
          style = "bold red";
        }
      ];
    };

    character = {
      disabled = false;
      # enter text prompt, shows output of last command
      format = "$symbol ";
      success_symbol = "[❯](bold green)";
      error_symbol = "[❯](bold red)";
    };

    cmd_duration = {
      disabled = false;
      min_time = 500;
      format = "took [$duration]($style) ";
      style = "white";
      show_notifications = true;
      min_time_to_notify = 60;
    };

    conda = {
      disabled = false;
      style = "dimmed green";
      format = "[$symbol$environment]($style)";
      ignore_base = true;
      symbol = "\\ue73c";
    };

    directory = {
      disabled = false;
      format = "[$path ]($style)[$read_only]($read_only_style)";
      style = "bold cyan";
      home_symbol = "~";

      truncation_length = 3;
      truncate_to_repo = true;
      truncation_symbol = ".../";

      # read_only = ""; # copy/pasting emoji into sublime doesn't work too well
      read_only_style = "red";
    };

    git_branch = {
      disabled = false;
      format = "on [$symbol$branch(:$remote_branch)]($style) ";
      style = "purple";
      ignore_branches = ["master" "main"];
    };

    git_state = {
      disabled = false;
      style = "bold yellow";
      format = "\([$state( $progress_current/$progress_total)]($style)\) ";
    };

    git_metrics = {
      disabled = false;
      added_style = "bold green"; # style for number of added lines
      deleted_style = "bold red"; # style for number of deleted lines
      only_nonzero_diffs = true;
      format = "([+$added]($added_style) )([-$deleted]($deleted_style) )";
      ignore_submodules = true; # ignore changes to submodules
    };

    git_status = {
      disabled = false;
      format = "([\[$all_status$ahead_behind\]]($style) )";
      style = "bold red";
      ignore_submodules = true;
      conflicted = "x";
      ahead = "⇡$count";
      behind = "⇣$count";
      diverged = "⇕⇡$ahead_count⇣$behind_count";
      up_to_date = "";
      untracked = "?";
      stashed = "$";
      modified = "!";
      staged = "+";
      renamed = "»";
      deleted = "✘";
    };

    hostname = {
      disabled = false;
      ssh_only = true;
      ssh_symbol = "\udb82\udcb9 ";
      trim_at = "";
      format = "[$ssh_symbol$hostname]($style) in ";
      style = "bold dimmed green";
    };

    jobs = {
      disabled = false;
      symbol_threshold = 1;
      number_threshold = 2;
      format = "[$symbol$number]($style) ";
      symbol = "✦";
      style = "bold blue";
    };

    nix_shell = {
      disabled = false;
      format = "via [$symbol$state( \($name\))]($style) ";
      symbol = "\udb81\udf17";
      style = "bold blue";
    };

    status = {
      disabled = false;
      format = "[$status \($common_meaning\)]($style) ";
      map_symbol = false;
      style = "bold red";
    };

    sudo = {
      disabled = false;
      format = "as root($style)";
      style = "bold blue";
    };

    time = {
      disabled = false;
      format = "[$time]($style)";
      time_format = "%-H:%M%p";
      style = "bold yellow";
    };

    username = {
      disabled = false;
      format = "[$user]($style) in ";
    };
  };
}
