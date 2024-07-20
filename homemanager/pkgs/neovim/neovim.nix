{ config, pkgs, ... }:
let
  githubPlugin =
    {
      author,
      repo,
      rev,
      hash ? "",
    }:
    (pkgs.vimUtils.buildVimPlugin {
      pname = author;
      version = rev;
      src = pkgs.fetchFromGitHub {
        owner = author;
        repo = repo;
        rev = rev;
        hash = hash;
      };
    });
  
  confdir = "${config.xdg.configHome}/nvim";
in
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim; # ensure the version we specify in flake.nix is used
    defaultEditor = true;
    extraPackages = with pkgs; [
      lua-language-server
      nixd # nix LSP for neovim
      ruff # python LSP
    ];
    plugins =
      with pkgs.vimPlugins;
      [
        # helpers - no additional setup done in plugins.lua
        nui-nvim
        plenary-nvim
        nvim-treesitter
        nvim-notify

        # in order of plugins.lua appearance
        block-nvim
        fzf-lua
        nvim-lspconfig
        lualine-nvim
        mini-nvim
        neo-tree-nvim
        noice-nvim
        nvim-web-devicons
        tabout-nvim
        nvim-spider
      ]
      ++ (with nvim-treesitter-parsers; [
        nix
        python
        regex
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
          rev = "6e61b09";
          author = "folke";
          hash = "sha256-cI3OzzT7Que15ayqkX0+jCiJsfQz2UI1s5L1rHhM+vU=";
        }
      ];
  };

  xdg.configFile."${confdir}/init.lua".source = ./init.lua;
  # xdg.configFile."${confdir}/lua/options.lua".source = ./options.lua;
  # xdg.configFile."${confdir}/lua/plugins.lua".source = ./plugins.lua;
  # xdg.configFile."${confdir}/lua/keymaps.lua".source = ./keymaps.lua;
}
