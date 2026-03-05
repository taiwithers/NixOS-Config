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
  home.packages = [ pkgs.typescript-language-server ];
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
      typescript
      typescript-language-server

      # formatters
      nixpkgs-fmt # trying to import nixfmt gives infinite recursion?
      black
      isort
      prettier
      prettierd
      stylua
      just
      fixjson
      dockerfmt
      shfmt
      yamlfmt
      prettier-plugin-astro
      # potential latex formatters:
      perlPackages.LatexIndent
      bibtex-tidy

    ];
    plugins =
      with pkgs.vimPlugins;
      [
        bufferline-nvim # bufferline
        lualine-nvim # lualine
        mini-nvim # mini (animate, clue, completion, cursorword, indentscope, move, pairs, surround)
        nvim-surround
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
        modes-nvim
        auto-hlsearch-nvim
        highlight-undo-nvim
        gitsigns-nvim
        toggleterm-nvim
        comment-nvim
        yanky-nvim

        # helpers - no additional setup done in plugins.lua
        # nui-nvim
        # plenary-nvim
        # vimtex

        # # simple plugins
        # (loadPlugin hmts-nvim "hmts")

        # in order of plugins.lua appearance
        # hardtime-nvim # hardtime
        # nvim-navic
        # nvim-treesitter-context # treesitter-context
        # otter-nvim

        # precognition-nvim # precognition
        # tabout-nvim # tabout
        # telescope-ui-select-nvim # required for legendary
        # texpresso-vim # texpresso
        # nvim-window-picker # window-picker

        # legendary-nvim # loaded after which-key, change to unstable

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
            scss # for astro
            typescript # for astro
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

  xdg.configFile."nvim/lua/nix-paths.lua".text = ''
    vim.g.tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib"
    vim.g.prettier_plugin_astro = "${pkgs.prettier-plugin-astro}/dist/index.js"
  '';

  xdg.configFile."nvim/lua/wsl-clipboard.lua" = pkgs.lib.mkIf config.common.wsl {
    source = "${config.common.nixConfigDirectory}/home-manager/pkgs/neovim/wsl-clipboard.lua";
  };
}
