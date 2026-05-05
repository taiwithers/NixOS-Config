_: {
  programs.zellij = {
    enable = true;
    settings = {
      default_mode = "locked"; # since many bindings conflict w/ other programs
      show_startup_tips = false;
    };
    extraConfig = /* KDL */ ''
      keybinds  clear-defaults=true {
        locked {
          bind "Ctrl g" { SwitchToMode "Normal"; }
        }


        resize {
          bind "Esc" "Enter" { SwitchToMode "Locked"; }
          bind "h" "Left" { Resize "Increase Left"; }
          bind "j" "Down" { Resize "Increase Down"; }
          bind "k" "Up" { Resize "Increase Up"; }
          bind "l" "Right" { Resize "Increase Right"; }
          bind "H" { Resize "Decrease Left"; }
          bind "J" { Resize "Decrease Down"; }
          bind "K" { Resize "Decrease Up"; }
          bind "L" { Resize "Decrease Right"; }
          bind "=" "+" { Resize "Increase"; }
          bind "-" { Resize "Decrease"; }
        }

        pane{
          bind "p" "Esc" "Enter" { SwitchToMode "Locked"; } // exit

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
          bind "t" "Esc" "Enter" { SwitchToMode "Locked"; }
          bind "n" { NewTab; SwitchToMode "Locked"; }
          bind "x" { CloseTab; SwitchToMode "Locked"; }
          bind "r" {SwitchToMode "RenameTab"; TabNameInput 0;}
          bind "h" "Left" "Up" "k" { GoToPreviousTab; }
          bind "l" "Right" "Down" "j" { GoToNextTab; }
        }

        renametab {
          bind "Ctrl c" "Esc" { UndoRenameTab; SwitchToMode "Locked"; }
        }

        renamepane {
            bind "Ctrl c" "Esc"{ SwitchToMode "Locked"; }
        }

        session {
          bind "o" "Esc" "Enter"{ SwitchToMode "Locked"; }
          bind "d" { Detach; }
          bind "w" {
              LaunchOrFocusPlugin "session-manager" { floating true; move_to_focused_tab true; };
              SwitchToMode "Locked";
          }
          bind "p" {
              LaunchOrFocusPlugin "plugin-manager" { floating true; move_to_focused_tab true; };
              SwitchToMode "Locked";
          }
          bind "a" {
              LaunchOrFocusPlugin "zellij:about" { floating true; move_to_focused_tab true; };
              SwitchToMode "Locked";
          }
          bind "s" {
              LaunchOrFocusPlugin "zellij:share" { floating true; move_to_focused_tab true; };
              SwitchToMode "Locked";
          }
          bind "l" {
              LaunchOrFocusPlugin "zellij:layout-manager" { floating true; move_to_focused_tab true; };
              SwitchToMode "Locked";
          }
        }

        shared_except "locked" {
          bind "Ctrl g" { SwitchToMode "Locked"; }
          bind "Ctrl q" { Quit; }
        }
        shared_except "normal" "locked" {
            bind "Enter" "Esc" { SwitchToMode "Normal"; }
        }

        normal {
            bind "t" { SwitchToMode "Tab"; }
            bind "o" { SwitchToMode "Session"; }
            bind "p" { SwitchToMode "Pane"; }
            bind "Esc" {SwitchToMode "Locked"; }
       }
      }
    '';
    # attachExistingSession = true; # applied to autostarted session
    enableBashIntegration = false; # autostart a zellij session
  };
}
