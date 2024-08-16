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
        nvim-treesitter

        # in order of plugins.lua appearance
        better-escape-nvim
        block-nvim
        bufferline-nvim
        # fzf-lua
        flatten-nvim
        nvim-lspconfig
        lualine-nvim
        mini-nvim
        noice-nvim
        nvim-notify
        nvim-web-devicons
        tabout-nvim
        toggleterm-nvim
        nvim-spider
        nvim-scrollview # change to unstable
        legendary-nvim # change to unstable
        # nvim-spectre
        nvim-treesitter-context
        nvim-tree-lua
        # trouble
        # dashboard-nvim
        persistence-nvim
        telescope-nvim
        telescope-ui-select-nvim # required for legendary
        telescope-file-browser-nvim
        telescope-fzf-native-nvim
        telescope-frecency-nvim
        nvim-window-picker
        hmts-nvim
        texpresso-vim

        precognition-nvim
        modes-nvim
        which-key-nvim
        tip-nvim
        f-string-toggle-nvim
        auto-hlsearch-nvim
        helpview-nvim
        hardtime-nvim
      ]
      ++ (with nvim-treesitter-parsers; [
        nix
        c
        lua
        vim
        vimdoc
        ssh_config
        query
        bash
        python
        regex
        ssh_config
        jsonc
        # jq
        # hyprlang
        comment
      ]);
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
