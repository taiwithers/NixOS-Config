{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    # plugins = {};
    # extraPlugins = with pkgs.vimPlugins; [
    #   lazygit-nvim
    #   fzf-lua
    # ];
  };
  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  #   extraConfig = "";
  #   plugins = with pkgs.vimPlugins; [
  #     # nvim-tree-lua
  #     telescope-nvim # :Telescope find_files
  #     nvim-whichkey-setup-lua
  #   ];

  #   # extraLuaConfig = "";
  #   # extraPackages = [];
  #   # extraLuaPackages = luaPkgs: [];
  #   # extraPython3Packages = pyPkgs: [];
  #   # extraWrapperArgs = [];
  #   # generatedConfigs = {};
  #   # generatedConfigViml = {};

  #   viAlias = false;
  #   vimAlias = false;
  #   vimdiffAlias = false;

  #   withNodeJs = false;
  #   withPython3 = false;
  #   withRuby = false;
  # };
}
