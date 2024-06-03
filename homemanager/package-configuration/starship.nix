{...}: {
  # programs.bash.bashrcExtra = "eval \"$(starship init bash)\"";

  programs.starship.enable = true;

  programs.starship.settings = {
    format = ''      $username$hostname\
                    $battery\
                    $conda\
                    $custom\
                    $directory\
                    $git_branch$git_state$git_metrics\
                    $jobs\
                    $nix_shell\
                    $os\
                    $package\
                    $python\
                    $shell\
                    $shlvl\
                    $singularity\
                    $status\
                    $sudo\
                    $time\
                    $vcsh\
                    $character
    '';

    battery = {
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
      # enter text prompt, shows output of last command
      format = "$symbol";
      success_symbol = "[❯](bold green)";
      error_symbol = "[❯](bold red)";
    };

    cmd_duration = {
      min_time = 500;
      format = "took [$duration]($style) ";
      style = "white";
      show_notifications = true;
      min_time_to_notify = 60;
    };

    conda = {
      style = "dimmed green";
      format = "[$symbol$environment]($style)";
      ignore_base = true;
    };

    directory = {
      format = "[$path]($style)[$read_only]($read_only_style)";
      style = "bold cyan";
      home_symbol = "~";

      truncation_length = 3;
      turncate_to_repo = true;
      truncation_symbol = ".../";

      # read_only = ""; # copy/pasting emoji into sublime doesn't work too well
      read_only_style = "red";
    };

    git_branch = {
      format = "on [$symbol$branch(:$remote_branch)]($style) ";
      style = "dimmed purple";
      ignore_branches = ["master" "main"];
    };

    git_state = {
      style = "bold yellow";
      format = "\([$state( $progress_current/$progress_total)]($style)\) ";
    };

    git_metrics = {
      added_style = "bold green"; # style for number of added lines
      deleted_style = "bold red"; # style for number of deleted lines
      only_nonzero_diffs = true;
      format = "([+$added]($added_style) )([-$deleted]($deleted_style) )";
      disabled = false;
      ignore_submodules = true; # ignore changes to submodules
    };

    git_status = {
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
      ssh_only = true;
      ssh_symbol = "\udb82\udcb9 ";
    };
  };
}
