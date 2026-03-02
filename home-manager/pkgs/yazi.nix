{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    settings = {
        mgr = {
            show_hidden = true;
          };
        preview = {
            wrap = "yes";
          };
        plugin.prepend_fetchers = [
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
      };
    keymap = {
        mgr.prepend_keymap = [{
            on = ["g" "i"];
            run = "plugin lazygit";
            desc = "run lazygit";
          } {
              on = "<Esc>"; run="close"; desc="Close";
            }];
      };
    plugins = {
      
      lazygit = pkgs.yaziPlugins.lazygit;
git = pkgs.yaziPlugins.git;

      };
    initLua = ''
      require("git"):setup()
    '';
  };
}
