{
  config,
  pkgs,
  app-themes,
  ...
}: let
  confdir = "${config.common.configHome}/nvim";
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim; # ensure the version we specify in flake.nix is used
    defaultEditor = true;
    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      lua-language-server
      nixd # nix LSP for neovim
      ruff # python LSP
    ];
    plugins = with pkgs.vimPlugins;
      [
        # helpers - no additional setup done in plugins.lua
        nui-nvim
        plenary-nvim

        # in order of plugins.lua appearance
        auto-hlsearch-nvim # auto-hlsearch
        better-escape-nvim # better_escape
        block-nvim # block
        bufferline-nvim # bufferline
        f-string-toggle-nvim # f-string-toggle
        flatten-nvim # flatten
        hardtime-nvim # hardtime
        helpview-nvim # helpview
        hmts-nvim # hmts
        nvim-lspconfig # lspconfig
        lualine-nvim # lualine
        mini-nvim # mini (animate, clue, completion, cursorword, indentscope, move, pairs, surround)
        modes-nvim # modes
        noice-nvim # noice
        nvim-notify # notify
        nvim-tree-lua # nvim-tree
        nvim-treesitter # nvim-treesitter
        nvim-treesitter-context # treesitter-context
        nvim-web-devicons # nvim-web-devicons
        precognition-nvim # precognition
        nvim-scrollview # scrollview, change to unstable
        tabout-nvim # tabout
        telescope-nvim # telescope
        telescope-file-browser-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim # required for legendary
        # telescope-frecency-nvim
        texpresso-vim # texpresso
        tip-nvim # tip
        toggleterm-nvim # toggleterm
        which-key-nvim # which-key
        nvim-window-picker # window-picker

        legendary-nvim # loaded after which-key, change to unstable
        nvim-spider # loaded in keymaps.lua

        # nvim-spectre
        # trouble
        # dashboard-nvim
      ]
      ++ (with nvim-treesitter-parsers; [
        nix
        c
        lua
        vim
        ssh_config
        bash
        python
        regex
        ssh_config
        jsonc
        # jq
        # hyprlang  
        comment
      ]) ++ [treesitter-parser-vimdoc treesitter-parser-query];
  };

  xdg.configFile."${confdir}/init.lua".source = ./init.lua;
  xdg.configFile."${confdir}/colors/base16theme.lua".text = with app-themes.palettes.neovim; ''
    require('mini.base16').setup({
      palette = {
        base00 = '#${base00}',
        base01 = '#${base01}',
        base02 = '#${base02}',
        base03 = '#${base03}',
        base04 = '#${base04}',
        base05 = '#${base05}',
        base06 = '#${base06}',
        base07 = '#${base07}',
        base08 = '#${base08}',
        base09 = '#${base09}',
        base0A = '#${base0A}',
        base0B = '#${base0B}',
        base0C = '#${base0C}',
        base0D = '#${base0D}',
        base0E = '#${base0E}',
        base0F = '#${base0F}',
      },
      use_cterm = true,
      plugins = {default=true,},
    })
  '';

  # symlink other files to avoid constant rebuilding
  home.activation.linkNvimConfig = let
    source-directory = "${config.common.nixConfigDirectory}/home-manager/pkgs/neovim";
    lua-directory = "${confdir}/lua";
  in
    config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir --parents ${lua-directory}/
      
      files=("options" "plugins" "keymaps" "autocommands")
      for fname in "''${files[@]}"; do
        source="${source-directory}/$fname.lua"
        destination="${lua-directory}/$fname.lua"

        if [[ -L "$destination" ]]; then rm "$destination"; fi
        ln -s "$source" "$destination"
      done
    '';
}
