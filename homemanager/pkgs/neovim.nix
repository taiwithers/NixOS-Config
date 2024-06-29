{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    opts = {
      syntax = "off";
    };

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
      trim.enable = true; # https://github.com/cappyzawa/trim.nvim/
      undotree.enable = true; # https://github.com/mbbill/undotree/
      treesitter = {
        enable = true;
        # folding = true;
        indent = true;

        ensureInstalled = ["python" "nix" "bash"];
        # disabledLanguages = [];
        # grammarPackages = [];
        # ignoreInstall = [];
      };
      # treesitter-refactor.enable = true;

      # otter.enable = true; # https://github.com/jmbuhr/otter.nvim/
    };

    clipboard.providers.wl-copy.enable = true;
  };
}
