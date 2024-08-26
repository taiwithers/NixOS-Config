{
  config,
  pkgs,
  app-themes,
  ...
}: 
let
  plugins = {
    zellij-forgot = {
      alias = "forgot";
      filename = "zellij-forgot.wasm";
      url = "https://github.com/karimould/zellij-forgot/releases/download/0.4.0/zellij_forgot.wasm";
    };
    zj-quit = {
      alias = "quit";
      filename = "zj-quit.wasm";
      url = "https://github.com/cristiand391/zj-quit/releases/download/0.3.0/zj-quit.wasm";
      };
  };
  plugin-directory = "${config.common.configHome}/zellij/plugins";
in {
  home.file."temp".text = "file:/${plugin-directory}/${plugins.zellij-forgot.filename}";
  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
  };
  
  xdg.configFile."${config.common.configHome}/zellij/config.kdl".text = 
  with app-themes.palettes.zellij;
  let 
    themeName = "base16";
  in
  # kdl
  ''
  // top-level config
  theme "${themeName}"
  default_layout "compact"
  // copy_command: "wl-copy"
  // copy_on_select false

  // theme colours
  themes {
    ${themeName} {
        fg "#${base05}"
        bg "#${base02}"
        black "#${base00}"
        red "#${base08}"
        green "#${base0B}"
        yellow "#${base0A}"
        blue "#${base0D}"
        magenta "#${base0E}"
        cyan "#${base0C}"
        white "#${base05}"
        orange "#${base09}"
    }
  }

  // plugin locations
  plugins {
    ${plugins.zellij-forgot.alias} location="file:${plugin-directory}/${plugins.zellij-forgot.filename}";
    ${plugins.zj-quit.alias} location="file:${plugin-directory}/${plugins.zj-quit.filename}";
  }

  // keybinds
  keybinds {

    normal {
      unbind "Ctrl q"

      bind "Ctrl q" { // launch zj-quit
        LaunchOrFocusPlugin "${plugins.zj-quit.alias}" { 
          floating true 
        }
      }

      bind "Alt ?" { // launch zellij-forgot 
        LaunchOrFocusPlugin "${plugins.zellij-forgot.alias}" {
          "LOAD_ZELLIJ_BINDINGS" "false"
          "lock"                  "ctrl + g"
          "unlock"                "ctrl + g"
          "new pane"              "alt + n / ctrl + p + n"
          "change pane focus"  "alt + hjkl / alt + arrows / ctrl + p + arrow"
          "close pane"            "ctrl + p + x"
          "rename pane"           "ctrl + p + c"
          "toggle fullscreen"     "ctrl + p + f"
          "toggle floating pane"  "ctrl + p + w"
          "toggle embeded pane"     "ctrl + p + e"
          "choose right pane"     "ctrl + p + l"
          "choose left pane"      "ctrl + p + r"
          "choose upper pane"     "ctrl + p + k"
          "choose lower pane"     "ctrl + p + j"
          "toggle pane split direction" "alt + [ / alt + ]"
          "new tab"               "ctrl + t + n"
          "close tab"             "ctrl + t + x"
          "change tab focus"   "ctrl + t + arrow key"
          "rename tab"            "ctrl + t + r"
          "sync tab"              "ctrl + t + s"
          "break pane to new tab" "ctrl + t + b"
          "break pane left"       "ctrl + t + ["
          "break pane right"      "ctrl + t + ]"
          "toggle tab"            "ctrl + t + tab"
          "increase pane size"    "ctrl + n + +"
          "decrease pane size"    "ctrl + n + -"
          "increase pane top"     "ctrl + n + k"
          "increase pane right"   "ctrl + n + l"
          "increase pane bottom"  "ctrl + n + j"
          "increase pane left"    "ctrl + n + h"
          "decrease pane top"     "ctrl + n + K"
          "decrease pane right"   "ctrl + n + L"
          "decrease pane bottom"  "ctrl + n + J"
          "decrease pane left"    "ctrl + n + H"
          "move pane to top"      "ctrl + h + k"
          "move pane to right"    "ctrl + h + l"
          "move pane to bottom"   "ctrl + h + j"
          "move pane to left"     "ctrl + h + h"
          "search"                "ctrl + s + s"
          "go into edit mode"     "ctrl + s + e"
          "detach session"        "ctrl + o + w"
          "open session manager"  "ctrl + o + w"
          "quit zellij (zj-quit)" "ctrl + q"
          "open keybinds"         "alt + ?"
          "toggle pane frames"    "ctrl + p + z"
          floating true
        }
      }
    }

    // don't use tmux keybinds
    tmux clear-defaults=true {}
  }
  '';

  xdg.configFile."${plugin-directory}/${plugins.zellij-forgot.filename}".source = builtins.fetchurl plugins.zellij-forgot.url;
  xdg.configFile."${plugin-directory}/${plugins.zj-quit.filename}".source = builtins.fetchurl plugins.zj-quit.url;
}
