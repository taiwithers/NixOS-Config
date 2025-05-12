_:
{

  home.shellAliases = {
    mma = "micromamba activate";
    mmd = "micromamba deactivate";
  };

  programs.bash.bashrcExtra = ''
    if [[ -f ~/.mamba_init ]]; then
      source ~/.mamba_init
    fi
  '';

}
