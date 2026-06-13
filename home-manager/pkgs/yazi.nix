{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    shellWrapperName = "yy";
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
            url = "*";
            run = "git";
            group = "git";
          }
          {
            url = "*/";
            run = "git";
            group = "git";
          }
        ];
        prepend_previewers =
          let
            view-with-bat = url: {
              inherit url;
              run = "piper -- bat --plain --color=always \"$1\"";
            };

          in
          [
            (view-with-bat "*.astro")
            (view-with-bat "*.mdx")
            # nbpreview
            {
              url = "*.ipynb";
              run = "piper -- nbpreview --no-paging --nerd-font --decorated --no-files --unicode --color --images --theme=dark \"$1\"";
            }
            # preview directory trees with eza
            {
              url = "*/";
              run = "piper -- eza --tree --level=3 --color=always --icons=always --group-directories-first --no-quotes \"$1\"";
            }
          ];
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "q";
          run = "quit --no-cwd-file";
          desc = "Quit";
        }
        {
          on = "Q";
          run = "quit";
          desc = "Quit, changing directory";
        }
        {
          on = [
            "g"
            "i"
          ];
          run = "plugin lazygit";
          desc = "run lazygit";
        }
        {
          on = [
            "c"
            "d"
          ];
          run = "plugin zoxide";
          desc = "Jump to a directory with zoxide";
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
