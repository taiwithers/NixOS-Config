{ config
, pkgs
, ...
}:
let
  confdir = "${config.common.configHome}/nvim";
  # toLua = string: ''
  #   lua << EOF
  #   ${string}
  #   EOF
  # '';
  requirePlugin = lua-name: "require('${lua-name}').setup()";
  loadPlugin = nix-name: lua-name: {
    plugin = nix-name;
    type = "lua";
    config = requirePlugin lua-name;
  };
in
{
  programs.neovim = {
    enable = true;
    # package = pkgs.neovim; # ensure the version we specify in flake.nix is used
    defaultEditor = true;
    extraPackages = with pkgs; [
      # language servers
      bash-language-server
      lua-language-server
      nixd
      vscode-langservers-extracted
      ruff
      astro-language-server # needs prettier plugin for formatting
      typescript-language-server

      # formatters
      nixpkgs-fmt
      black
      isort
      prettier
      prettierd
      stylua
    ];
    plugins =
      with pkgs.vimPlugins;
      [
        bufferline-nvim # bufferline
        lualine-nvim # lualine
        mini-nvim # mini (animate, clue, completion, cursorword, indentscope, move, pairs, surround)
        nvim-surround
        nvim-tree-lua
        noice-nvim # noice
        which-key-nvim # which-key
        nvim-notify # notify

        nvim-cmp
        cmp-nvim-lsp

        yazi-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        nvim-ts-autotag
        conform-nvim

        # helpers - no additional setup done in plugins.lua
        # nui-nvim
        # plenary-nvim
        # cmp-nvim-lsp-signature-help
        # vimtex
        # neo-tree-nvim

        # # simple plugins
        # (loadPlugin auto-hlsearch-nvim "auto-hlsearch")
        # (loadPlugin helpview-nvim "helpview")
        # (loadPlugin highlight-undo-nvim "highlight-undo")
        # (loadPlugin hmts-nvim "hmts")
        # (loadPlugin nvim-tree-lua "nvim-tree")
        # (loadPlugin render-markdown-nvim "render-markdown")
        # (loadPlugin nvim-surround "nvim-surround")

        # in order of plugins.lua appearance
        # nvim-cmp
        # hardtime-nvim # hardtime
        # nvim-lspconfig # lspconfig
        # modes-nvim # modes
        # nvim-navic
        # nvim-treesitter # nvim-treesitter
        # nvim-treesitter-context # treesitter-context
        # otter-nvim

        # precognition-nvim # precognition
        # render-markdown-nvim
        # tabout-nvim # tabout
        # telescope-nvim # telescope
        # telescope-file-browser-nvim
        # telescope-fzf-native-nvim
        # telescope-ui-select-nvim # required for legendary
        # telescope-frecency-nvim
        # texpresso-vim # texpresso
        # toggleterm-nvim # toggleterm
        # nvim-window-picker # window-picker

        # legendary-nvim # loaded after which-key, change to unstable
        # nvim-spider # loaded in keymaps.lua

        # nvim-spectre
        # trouble
        # dashboard-nvim
        # vim-just # syntax highlighting for just

        (pkgs.vimPlugins.nvim-treesitter.withPlugins (
          p: with p; [
            nix
            lua
            vim
            ssh_config
            bash
            python
            regex
            ssh_config
            jsonc
            astro
            # jq
            comment
            toml
            devicetree # zmk
            vimdoc
            query
            latex
            html
            kdl # niri
            just
          ]
        ))

      ]
      ++ [ pkgs.python312Packages.pylatexenc ];

    # extraLuaConfig = builtins.readFile ./init.lua;
  };

  # symlink other files to avoid constant rebuilding
  # home.activation.linkNvimConfig =
  #   let
  #     source-directory = "${config.common.nixConfigDirectory}/home-manager/pkgs/neovim";
  #     lua-directory = "${confdir}/lua";
  #   in
  #   config.lib.dag.entryAfter [ "writeBoundary" ] ''
  #     mkdir --parents ${lua-directory}/
  #
  #     files=("options" "plugins" "keymaps" "autocommands")
  #     for fname in "''${files[@]}"; do
  #       source="${source-directory}/$fname.lua"
  #       destination="${lua-directory}/$fname.lua"
  #
  #     if [[ -L "$destination" ]]; then rm "$destination"; fi
  #     ln -s "$source" "$destination"
  #   done
  # '';

  xdg.configFile."nvim/lua/wsl-clipboard.lua" = pkgs.lib.mkIf config.common.wsl {
    source = "${config.common.nixConfigDirectory}/home-manager/pkgs/neovim/wsl-clipboard.lua";
  };
}
