{...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = "";
    plugins = [];

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
