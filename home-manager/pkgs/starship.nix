{pkgs, ...}: {
  # style strings (not case sensitive)
  # bold, italic, underline, dimmed, inverted, blink, hidden, strikethrough, <color>, fg:<color>, bg:<color>, none
  # colors: black, red, green, blue, yellow, purple, cyan, white, bright-<any of previous>,; #hexcode, 0-255 ANSI code

  programs.starship = {
    enable = true;
    enableBashIntegration = false; # do this manually with bashrcExtra since the bash integration assumes the location of .nix-profile
    enableZshIntegration = false;
    settings = {
      format =
        "$"
        + builtins.concatStringsSep "$" [
          "username"
          "hostname"
          "conda"
          "directory"
          "git_branch"
          "git_state"
          "git_metrics"
          "jobs"
          "nix_shell"
          "character"
        ];

      right_format =
        "$"
        + builtins.concatStringsSep "$" [
          "status"
          "shell"
          "battery"
          "time"
        ];

      continuation_prompt = " ❯ ";

      command_timeout = 1000;

      # modules, in alphabetical order
      battery = {
        disabled = false;
        format = "| [$symbol$percentage]($style)";
        display = [
          {
            threshold = 60;
            charging_symbol = "󰂉";
            discharging_symbol = "󰁿";
            style = "green";
          }
          {
            threshold = 40;
            charging_symbol = "󰂇";
            discharging_symbol = "󰁻";
            style = "yellow";
          }
          {
            threshold = 10;
            charging_symbol = "󰢜";
            discharging_symbol = "󰂃";
            style = "bold red";
          }
        ];
      };

      character = {
        disabled = false;
        format = "$symbol ";
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold green)";
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
        style = "bright-green";
        format = ''\[[$symbol $environment]($style)\] '';
        ignore_base = false;
        symbol = "";
      };
      directory = {
        disabled = false;
        format = "[$path ]($style)[$read_only]($read_only_style)";
        home_symbol = "~";
        truncation_length = 3;
        truncate_to_repo = true;
        truncation_symbol = ".../";
        read_only_style = "red";
      };
      git_branch = {
        disabled = false;
        format = "on [$symbol $branch(:$remote_branch) ]($style)";
        symbol = "";
        style = "bright-purple";
        ignore_branches = [
          "master"
          "main"
        ];
      };
      git_metrics = {
        disabled = false;
        added_style = "bold green"; # style for number of added lines;
        deleted_style = "bold red"; # style for number of deleted lines;
        only_nonzero_diffs = true;
        format = "(([+$added]($added_style))([-$deleted]($deleted_style)) )";
        # format = "[ ([+$added]($added_style))([-$deleted]($deleted_style) ) ]";
        ignore_submodules = true; # ignore changes to submodules
      };
      git_state = {
        disabled = false;
        style = "bold yellow";
        format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
      };
      git_status = {
        disabled = false;
        format = ''([\[$all_status$ahead_behind\]]($style) )'';
        style = "bold red";
        ignore_submodules = true;
        conflicted = "="; # merge conflicts;
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
        ssh_symbol = "󰢹 ";
        trim_at = "";
        format = "[$ssh_symbol$hostname ]($style) ";
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
        format = "via [$symbol( $name$state)]($style)";
        symbol = "";
        style = "bold blue";
        impure_msg = " (impure)";
        pure_msg = "";
        unknown_msg = " (purity?)";
        # heuristic = true; # attempt to detect `nix shell` commands rather than only `nix-shell`
        # appears to not work correctly, follow:
        # https://github.com/starship/starship/issues/6052
      };
      shell = {
        disabled = false;
        bash_indicator = "bash";
        zsh_indicator = "zsh";
        format = " [$indicator]($style)";
        style = "white";
      };
      status = {
        disabled = false;
        format = ''[\[$status $common_meaning\]]($style) '';
        map_symbol = false;
        style = "red";
      };
      time = {
        disabled = false;
        format = " [$time]($style)";
        time_format = "%-H:%M%p";
        style = "bright-black";
      };
      username = {
        disabled = true;
        format = "[$user ]($style) ";
        show_always = false; # if false, only shows if: root, not same as login, in ssh;
        style_user = "red";
        style_root = "bold red";
      };
    };
  };

  programs.bash.bashrcExtra = ''
    if [[ $TERM != "dumb" ]]; then
      eval "$( ${pkgs.starship}/bin/starship init bash --print-full-init)"
    fi
  '';
}
