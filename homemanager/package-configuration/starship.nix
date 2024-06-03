{...}: {
  # programs.bash.bashrcExtra = "eval \"$(starship init bash)\"";

  programs.starship.enable = true;

  programs.starship.settings = {
    format = "$username$hostname$shlvl$singularity$directory$vcsh$git_branch$git_state$git_metrics$package$python$nix_shell$conda$direnv$env_var$custom$sudo$jobs$battery$time$status$os$container$shell$character";

    battery = {
      format = "[$symbol$percentage]($style)";
      display.threshold = 50;
      display.style = "bold red";
    };

    character = {
      # enter text prompt, shows output of last command
      format = "$symbol";
      success_symbol = "[❯](bold green)";
      error_symbol = "[❯](bold red)";
    };

    cmd_duration = {
      min_time = 500;
    };
  };
}
