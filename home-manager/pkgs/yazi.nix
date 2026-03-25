{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    theme.mgr.syntect_theme = "~/.config/bat/themes/base16-stylix.tmTheme";
    settings = {
      mgr = {
        show_hidden = false; # toggle with `.`
      };
      preview = {
        wrap = "yes";
      };
      plugin = {
        prepend_fetchers = [
          # no idea what's going on here but you need it for the git plugin
          {
            id = "git";
            url = "*";
            run = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
          }
        ];
        prepend_previewers =
          let
            view-with-bat = name: {
              inherit name;
              run = "piper -- bat --plain --color=always \"$1\"";
            };

          in
          [
            (view-with-bat "*.astro")
            (view-with-bat "*.mdx")
            # nbpreview
            {
              name = "*.ipynb";
              run = "piper -- nbpreview --no-paging --nerd-font --decorated --no-files --unicode --color --images --theme=dark \"$1\"";
            }
            # preview directory trees with eza
            {
              name = "*/";
              run = "piper -- eza --tree --level=3 --color=always --icons=always --group-directories-first --no-quotes \"$1\"";
            }
          ];
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [
            "g"
            "i"
          ];
          run = "plugin lazygit";
          desc = "run lazygit";
        }
        {
          on = "<Esc>";
          run = "close";
          desc = "Close";
        }
        {
          on = "p";
          run = "plugin smartpaste";
          desc = "Paste into current or hovered directory";
        }
      ];
    };
    plugins = {
      piper = pkgs.yaziPlugins.piper;
      lazygit = pkgs.yaziPlugins.lazygit;
      git = pkgs.yaziPlugins.git;
      smartpaste = pkgs.yaziPlugins.smart-paste;
    };
    initLua = ''
      require("git"):setup()
    '';
    extraPackages = [
      pkgs.bat
      pkgs.eza
      pkgs.nbpreview
    ];
  };
}
