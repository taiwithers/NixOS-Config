{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.blesh];
  programs.bash.bashrcExtra = ''
    if [[ -n "$(builtin type -P blesh-share)" ]]; then
      source $(blesh-share)/ble.sh
    else
      source ${pkgs.blesh}/share/blesh/ble.sh
    fi
  '';
  xdg.configFile."${config.common.configHome}/blesh/init.sh".text = ''
    # vim mode settings
    set -o vi # use vim mode for ble.sh
    ble-bind -m vi_nmap --cursor 2 # change cursor shape depending on mode
    ble-bind -m vi_imap --cursor 5
    ble-bind -m vi_omap --cursor 4
    ble-bind -m vi_xmap --cursor 2
    ble-bind -m vi_cmap --cursor 0
    # make CTRL+c behave as in non-vim - discarding the current line
    ble-bind -m vi_imap -f 'C-c' discard-line
    ble-bind -m vi_nmap -f 'C-c' discard-line

    bleopt edit_line_type=graphical
    bleopt complete_auto_delay=300 # ms delay before completion popup
    bleopt history_share=1 # share history between bash sessions
    bleopt filename_ls_colors="$LS_COLORS"
    bleopt accept_line_threshold=-2
    bleopt exec_errexit_mark= # turn off exit status
    bleopt complete_menu_maxlines=4
    bleopt complete_menu_complete= # turn off menu completion
  
    bind 'set completion-ignore-case off' # make completion case-sensitive

    # accept autocomplete with tab
    # ble-bind -m auto_complete -f C-i auto_complete/insert
    ble-bind -m auto_complete -f TAB auto_complete/insert # accept autocomplete with tab
    ble-bind -m auto_complete -f 'C-c' auto_complete/cancel
    
    ble-import -d integration/fzf-completion
    ble-import -d integration/fzf-key-bindings
  '';
}
