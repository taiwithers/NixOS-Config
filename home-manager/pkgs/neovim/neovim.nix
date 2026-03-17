{
  config,
  pkgs,
  ...
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
    defaultEditor = true;
    extraPackages = with pkgs; [
      # language servers
      bash-language-server
      lua-language-server
      nixd
      vscode-langservers-extracted
      ruff
      astro-language-server
      typescript
      typescript-language-server
      mdx-language-server
      gcc13 # don't let project-specific gccs take over, not sure if this works
      nodejs # same as gcc

      # formatters
      nixfmt-rfc-style
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
      # potential latex formatters: perlPackages.LatexIndent bibtex-tidy

      # plugin integrations and dependencies
      yazi
      lazygit
      fd
      bat
      ripgrep
    ];
    plugins =
      with pkgs.vimPlugins;
      [
        bufferline-nvim # tab bar
        lualine-nvim # status bar
        mini-nvim # mini (autopairs, delete buffer without changing layout)
        nvim-surround # actions on surrounding brackets
        noice-nvim # pretty UI
        which-key-nvim # which-key
        nvim-notify # apply noice ui to notifications
        nvim-cmp # completion
        cmp-nvim-lsp # completion source - LSP
        cmp-nvim-lua # completion source - vim.X lua api
        yazi-nvim # integrate yazi
        telescope-nvim # picker for files and much more
        telescope-fzf-native-nvim # improve telescope's sorting and searching
        nvim-ts-autotag # auto-close html tags
        conform-nvim # configuration for formatters
        modes-nvim # change the colour of the current line based on mode
        auto-hlsearch-nvim # turn off search highlights automatically - change this is redundant w/ flash
        highlight-undo-nvim # highlight the text changed by undoing
        gitsigns-nvim # show git status of lines in the signcolumn
        toggleterm-nvim # manage terminal windows
        comment-nvim # fancy comment functionality
        nvim-neoclip-lua # clipboard history
        sqlite-lua # for nvim-neoclip-lua
        flash-nvim # improved FtTt motions
        template-string-nvim # auto handle f-strings and js equiv
        project-nvim # auto-cd
        marks-nvim # show marks in signcolumn
        darkvoid-nvim # colourscheme that doesn't work great
        mdx-nvim # treesitter highlighting for mdx files
        otter-nvim # LSP for embedded code blocks
        markdown-plus-nvim # lots of markdown functionality (list continuation, table navigation, etc.)
        nvim-colorizer-lua # highlight hex, rgb, css colours
        telescope-ui-select-nvim # send vim.ui.select to telescope
        tabout-nvim # tab out of brackets and quotes
        nvim-ts-context-commentstring # fix comments in jsx/tsx since comment.nvim doesn't support them
        range-highlight-nvim # when running cmdline things on selected text, highlight those lines

        # vimtex
        # texpresso-vim # texpresso
        # nvim-window-picker # window-picker

        (pkgs.vimPlugins.nvim-treesitter.withPlugins (
          p: with p; [
            astro
            bash
            comment
            devicetree # zmk
            hmts-nvim
            html
            # jq
            jsonc
            just
            kdl # niri
            latex
            lua
            nix
            python
            query
            regex
            scss # for astro
            ssh_config
            ssh_config
            toml
            tsx
            typescript # for astro
            vim
            vimdoc
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

  home.activation.linkNvimConfig =
    let
      source-directory = "${config.common.nixConfigDirectory}/home-manager/pkgs/neovim";
    in
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      fname=init
      source="${source-directory}/$fname.lua"
      destination="${confdir}/$fname.lua"

      if [[ -L "$destination" ]]; then rm "$destination"; fi
      ln -s "$source" "$destination"
    '';

  xdg.configFile."nvim/lua/nix-paths.lua".text = ''
    vim.g.tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib"
    vim.g.prettier_plugin_astro = "${pkgs.prettier-plugin-astro}/dist/index.js"
    vim.g.nixpkgs_expr = 'import (builtins.getFlake "${config.common.nixConfigDirectory}").inputs.nixpkgs {}'
  '';

  xdg.configFile."nvim/lua/wsl-clipboard.lua" = pkgs.lib.mkIf config.common.wsl {
    source = "${config.common.nixConfigDirectory}/home-manager/pkgs/neovim/wsl-clipboard.lua";
  };
}
