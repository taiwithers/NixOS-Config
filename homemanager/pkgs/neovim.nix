{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = "";
    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
      telescope-nvim
    ];

    # extraLuaConfig = "";
    # extraPackages = [];
    # extraLuaPackages = luaPkgs: [];
    # extraPython3Packages = pyPkgs: [];
    # extraWrapperArgs = [];
    # generatedConfigs = {};
    # generatedConfigViml = {};

    viAlias = false;
    vimAlias = false;
    vimdiffAlias = false;

    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
  };
}
