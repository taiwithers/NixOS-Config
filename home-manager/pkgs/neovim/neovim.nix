{
  config,
  pkgs,
  app-themes,
  ...
}: let
  githubPlugin = {
    author,
    repo,
    rev,
    hash ? "",
  }: (pkgs.vimUtils.buildVimPlugin {
    pname = author;
    version = rev;
    src = pkgs.fetchFromGitHub {
      owner = author;
      repo = repo;
      rev = rev;
      hash = hash;
    };
  });

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
      ])
      ++ builtins.map githubPlugin [
        {
          repo = "precognition.nvim";
          author = "tris203";
          rev = "2a566f0";
          hash = "sha256-XLcyRB4ow5nPoQ0S29bx0utV9Z/wogg7c3rozYSqlWE=";
        }
        {
          author = "mvllow";
          repo = "modes.nvim";
          rev = "326cff3";
          hash = "sha256-z1XD0O+gG2/+g/skdWGC64Zv4dXvvhWesaK/8DcPF/E=";
        }
        {
          repo = "which-key.nvim";
          rev = "6c1584e";
          author = "folke";
          hash = "sha256-nv9s4/ax2BoL9IQdk42uN7mxIVFYiTK+1FVvWDKRnGM=";
        }
        {
          repo = "Tip.nvim";
          author = "TobinPalmer";
          rev = "7e87517";
          hash = "sha256-9+YjOm2gmTIK6MmAqaAQ5M1IgMX0u5xSLmO+yWtaadk=";
        }
        {
          repo = "f-string-toggle.nvim";
          author = "roobert";
          rev = "4e2ad79";
          hash = "sha256-IMMq4cklHxrhfHALcCamMWT4ekBqOMtkiAUXh8YlaM0=";
        }
        {
          repo = "auto-hlsearch.nvim";
          author = "asiryk";
          rev = "8f28246";
          hash = "sha256-AitkdtKoKNAURrEZuQU/VRLj71qDlI4zwL+vzXUJzew=";
        }
        {
          repo = "helpview.nvim";
          author = "OXY2DEV";
          rev = "7c24a92";
          hash = "sha256-V681TrMpOKuutUZ3n84W1z/y0iSz2SkarsZmhz5rI7w=";
        }
        {
          repo = "hardtime.nvim";
          author = "m4xshen";
          rev = "91c6be1";
          hash = "sha256-pLJShpbqmJbY3ThQuGmUfgsxijSADJrqpGYLE+KAcUQ=";
        }
      ];
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
      rm ${lua-directory}/options.lua
      rm ${lua-directory}/plugins.lua
      rm ${lua-directory}/keymaps.lua
      rm ${lua-directory}/autocommands.lua
      ln -s ${source-directory}/options.lua ${lua-directory}/options.lua
      ln -s ${source-directory}/plugins.lua ${lua-directory}/plugins.lua
      ln -s ${source-directory}/keymaps.lua ${lua-directory}/keymaps.lua
      ln -s ${source-directory}/autocommands.lua ${lua-directory}/autocommands.lua
    '';
}
