{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    plugins = {
      fzf-lua.enable = true;
      lazygit.enable = true;
      lsp = {
        # neovim built-in lsp?
        enable = true;
        servers = {
          bashls.enable = true;
          jsonls.enable = true;
          nixd.enable = true;
          pylsp.enable = true;
        };
      };

      nvim-tree = {
        # https://github.com/nvim-tree/nvim-tree.lua
        enable = true;
        openOnSetup = true;
      };

      which-key.enable = true;

      multicursors.enable = true; # https://github.com/smoka7/multicursors.nvim
      statuscol.enable = true; # https://github.com/luukvbaal/statuscol.nvim/
      surround.enable = true; # https://github.com/tpope/vim-surround/
      # otter.enable = true; # https://github.com/jmbuhr/otter.nvim/
      # treesitter = {
      #   enable = true;
      #   ensureInstalled = ["python" "nix" "bash"];
      #   folding = true;
      #   indent = true;
      # };
      # treesitter-refactor.enable = true;
      # trim.enable = true; # https://github.com/cappyzawa/trim.nvim/
      # undotree.enable = true; # https://github.com/mbbill/undotree/
    };

    clipboard.providers.wl-copy.enable = true;
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
