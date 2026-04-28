_: {
  programs.zellij = {
    enable = true;
    # settings = { };
    extraConfig = /* KDL */ ''
      keybinds {
        unbind "Ctrl s"  "Ctrl t"  "Ctrl h" "Ctrl b"
        // C-s conflicts w/ nvim save
        // C-t conflicts w/ fzf
        // C-h starts move mode which I don't need
        // C-b starts tmux mode which I don't need


        // Remap tabs mode from C-t (conflicts w/ fzf) to C-n
        // this overrides the use of C-n for pane resize mode (which has been bound to C-p S-r)
        shared_except "tab" "locked" {
          bind "Ctrl n" { SwitchToMode "Tab"; }
        }
        tab {
          bind "Ctrl n" { SwitchToMode "Normal"; }
        }

        pane clear-defaults=true {
          bind "Ctrl p" "Esc" "Enter" { SwitchToMode "Normal"; } // exit

          // switch focus
          bind "h" "Left" { MoveFocus "Left"; }
          bind "l" "Right" { MoveFocus "Right"; }
          bind "j" "Down" { MoveFocus "Down"; }
          bind "k" "Up" { MoveFocus "Up"; }
          bind "p" { SwitchFocus; }

          // create new panes (mnemonically follows :split :vsplit)
          bind "s" { NewPane "Down"; SwitchToMode "Normal"; }
          bind "Shift s" { NewPane "Right"; SwitchToMode "Normal"; }
          // bind "s" { NewPane "stacked"; SwitchToMode "Normal"; }

          // move panes
          bind "Shift h" { MovePane "Left"; }
          bind "Shift l" { MovePane "Right"; }
          bind "Shift j" { MovePane "Down"; }
          bind "Shift k" { MovePane "Up"; }

          // other pane actions
          bind "x" { CloseFocus; SwitchToMode "Normal"; } // close
          bind "r" { SwitchToMode "RenamePane"; PaneNameInput 0; } // rename
          bind "f" { ToggleFocusFullscreen; SwitchToMode "Normal"; } // toggle fullscreen
          bind "Shift r" { SwitchToMode "resize"; } // enter resize mode
          bind "t" { BreakPane; SwitchToMode "Normal"; }
          // bind "w" { ToggleFloatingPanes; SwitchToMode "Normal"; } // show/hide floating panes
        }

        tab {
          unbind "s" "b" "[" "]"
          // s: sync pane inputs
          // b/[/]: breaking panes into new tabs
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
