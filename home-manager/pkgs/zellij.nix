_: {
  programs.zellij = {
    enable = true;
    settings = {
      default_mode = "locked"; # since many bindings conflict w/ other programs
    };
    extraConfig = /* KDL */ ''
      keybinds {
        unbind "Ctrl s" "Ctrl h" "Ctrl b" "Ctrl n"
        // C-s starts move mode which I don't need
        // C-h starts move mode which I don't need
        // C-b starts tmux mode which I don't need
        // C-n starts resize mode which I have as C-p R

        resize {
          bind "Esc" "Enter" { SwitchToMode "Locked"; }
        }

        pane clear-defaults=true {
          bind "Ctrl p" "Esc" "Enter" { SwitchToMode "Locked"; } // exit

          // switch focus
          bind "h" "Left" { MoveFocus "Left"; }
          bind "l" "Right" { MoveFocus "Right"; }
          bind "j" "Down" { MoveFocus "Down"; }
          bind "k" "Up" { MoveFocus "Up"; }
          bind "p" { SwitchFocus; }

          // create new panes (mnemonically follows :split :vsplit)
          bind "s" { NewPane "Down"; SwitchToMode "Locked"; }
          bind "Shift s" { NewPane "Right"; SwitchToMode "Locked"; }
          // bind "s" { NewPane "stacked"; SwitchToMode "Locked"; }

          // move panes
          bind "Shift h" { MovePane "Left"; }
          bind "Shift l" { MovePane "Right"; }
          bind "Shift j" { MovePane "Down"; }
          bind "Shift k" { MovePane "Up"; }

          // other pane actions
          bind "x" { CloseFocus; SwitchToMode "Locked"; } // close
          bind "r" { SwitchToMode "RenamePane"; PaneNameInput 0; } // rename
          bind "f" { ToggleFocusFullscreen; SwitchToMode "Locked"; } // toggle fullscreen
          bind "Shift r" { SwitchToMode "resize"; } // enter resize mode
          bind "t" { BreakPane; SwitchToMode "Locked"; }
          // bind "w" { ToggleFloatingPanes; SwitchToMode "Locked"; } // show/hide floating panes
        }

        tab {
          unbind "s" "b" "[" "]" "Tab" "1" "2" "3" "4" "5" "6" "6" "7" "8" "9"
          // s: sync pane inputs
          // b/[/]: breaking panes into new tabs
          // Tab: swaps between 2 tabs
          // numeric: jump to tab
          bind "Ctrl t" "Esc" "Enter" { SwitchToMode "Locked"; }
          bind "n" { NewTab; SwitchToMode "Locked"; }
          bind "x" { CloseTab; SwitchToMode "Locked"; }
        }

        renametab {
          bind "Ctrl c" "Esc" { UndoRenameTab; SwitchToMode "Locked"; }
        }

        session {
          bind "Ctrl o" { SwitchToMode "Locked"; }
        }

        shared_except "locked" {
          // don't really want random shortcut bindings, and also don't want alt-based bindings
          unbind "Alt f"  "Alt n"  "Alt i"  "Alt o"  "Alt h"  "Alt Left"  "Alt l"  "Alt Right"  "Alt j"  "Alt Down"  "Alt k"  "Alt Up"  "Alt ="  "Alt +"  "Alt -"  "Alt ["  "Alt ]"  "Alt p"  "Alt Shift p"  
        }


      }
    '';
    # attachExistingSession = true; # applied to autostarted session
    enableBashIntegration = false; # autostart a zellij session
  };
}
