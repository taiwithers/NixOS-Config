{
  config,
  pkgs,
  app-themes,
  ...
}: {
  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
    # settings = {
    #   theme = "base16";
    #   themes.base16 = with app-themes.palettes.zellij; {
    #     fg = "#${base05}";
    #     bg = "#${base02}";
    #     black = "#${base00}";
    #     red = "#${base08}";
    #     green = "#${base0B}";
    #     yellow = "#${base0A}";
    #     blue = "#${base0D}";
    #     magenta = "#${base0E}";
    #     cyan = "#${base0C}";
    #     white = "#${base05}";
    #     orange = "#${base09}";
    #   };
    #   plugins.forgot = {location = "${config.common.configHome}/zellij/plugins/zellij-forgot.wasm";};
    #   keybinds = {
    #     normal = {
    #       "Alt ?" = {'''LaunchOrFocusPlugin "forgot"''' = {floating = true;};};
    #     };
    #   };
    # };
  };
  
  xdg.configFile."${config.common.configHome}/zellij/config.kdl".text = 
  with app-themes.palettes.zellij;
  let 
    themeName = "base16";
  in
  ''
  theme "${themeName}"
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

  plugins {
    forgot location="file://${config.common.configHome}/zellij/plugins/zellij-forgot.wasm"
  }

  keybinds {
    normal {
      bind "Alt ?" { 
        LaunchOrFocusPlugin "forgot" {
          "LOAD_ZELLIJ_BINDINGS" "false"
          "lock"                  "ctrl + g"
          "unlock"                "ctrl + g"
          "new pane"              "alt + n / ctrl + p + n"
          "change focus of pane"  "alt + hjkl / alt + arrows / ctrl + p + arrowi"
          "close pane"            "ctrl + p + x"
          "rename pane"           "ctrl + p + c"
          "toggle fullscreen"     "ctrl + p + f"
          "toggle floating pane"  "ctrl + p + w"
          "toggle embed pane"     "ctrl + p + e"
          "choose right pane"     "ctrl + p + l"
          "choose left pane"      "ctrl + p + r"
          "choose upper pane"     "ctrl + p + k"
          "choose lower pane"     "ctrl + p + j"
          "toggle pane split direction" "alt + [ / alt + ]"
          "new tab"               "ctrl + t + n"
          "close tab"             "ctrl + t + x"
          "change focus of tab"   "ctrl + t + arrow key"
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
          "quit zellij"           "ctrl + q"
          "open keybinds"         "alt + ?"

          floating true
        }
      }
    }

    tmux clear-defaults=true {}
  }
  '';

  xdg.configFile."${config.common.configHome}/zellij/plugins/zellij-forgot.wasm".source = builtins.fetchurl "https://github.com/karimould/zellij-forgot/releases/download/0.4.0/zellij_forgot.wasm";
}
