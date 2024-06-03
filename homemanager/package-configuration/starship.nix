{...}: {
  # programs.bash.bashrcExtra = "eval \"$(starship init bash)\"";

  programs.starship.enable = true;

  programs.starship.settings = {
    format = "$username$hostname$shlvl$singularity$directory$vcsh$git_branch$git_state$git_metrics$package$python$nix_shell$conda$direnv$env_var$custom$sudo$jobs$battery$time$status$os$container$shell$character";
  };
}
