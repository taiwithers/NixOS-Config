{
  config,
  pkgs,
  app-themes,
  ...
}:
{
  home.packages = [ pkgs.blesh ];
  programs.bash.bashrcExtra = ''
    if [[ -n "$(builtin type -P blesh-share)" ]]; then
      source $(blesh-share)/ble.sh
    else
      source ${pkgs.blesh}/share/blesh/ble.sh
    fi
  '';
  xdg.configFile."${config.common.configHome}/blesh/init.sh".text = with app-themes.colours; ''
    # vim mode settings
    function my/vim-load-hook {
      # indicate normal just like insert
      bleopt keymap_vi_mode_string_nmap=$'\e[1m-- NORMAL --\e[m'

      # change cursor shape depending on mode
      ble-bind -m vi_nmap --cursor 2 
      ble-bind -m vi_imap --cursor 5
      ble-bind -m vi_omap --cursor 4
      ble-bind -m vi_xmap --cursor 2
      ble-bind -m vi_cmap --cursor 0
      
      # make CTRL+c behave as in non-vim - discarding the current line
      ble-bind -m vi_imap -f 'C-c' discard-line
      ble-bind -m vi_nmap -f 'C-c' discard-line
    }
    blehook/eval-after-load keymap_vi my/vim-load-hook

    set -o vi # use vim mode for ble.sh

    # disable all? features to build from ground up
    # Disable syntax highlighting
    # bleopt highlight_syntax=

    # Disable highlighting based on filenames
    bleopt highlight_filename=

    # Disable highlighting based on variable types
    bleopt highlight_variable=

    # Disable auto-complete (Note: auto-complete is enabled by default in bash-4.0+)
    bleopt complete_auto_complete=
    # Tip: you may instead specify the delay of auto-complete in millisecond
    bleopt complete_auto_delay=300

    # Disable auto-complete based on the command history
    bleopt complete_auto_history=

    # Disable ambiguous completion
    bleopt complete_ambiguous=

    # Disable menu-complete by TAB
    bleopt complete_menu_complete=

    # Disable menu filtering (Note: auto-complete is enabled by default in bash-4.0+)
    bleopt complete_menu_filter=

    # Disable EOF marker like "[ble: EOF]"
    bleopt prompt_eol_mark=""

    # Disable error exit marker like "[ble: exit %d]"
    bleopt exec_errexit_mark=

    # Disable elapsed-time marker like "[ble: elapsed 1.203s (CPU 0.4%)]"
    bleopt exec_elapsed_mark=
    # Tip: you may instead change the threshold of showing the mark
    bleopt exec_elapsed_enabled='sys+usr>=10*60*1000' # e.g. ten minutes for total CPU usage

    # Disable exit marker like "[ble: exit]"
    # bleopt exec_exit_mark=

    # Disable some other markers like "[ble: ...]" 
    # seem to cause errors
    # bleopt edit_marker=
    # bleopt edit_marker_error=

    # some old things I had
    # bleopt edit_line_type=graphical
    # bleopt complete_auto_delay=300 # ms delay before completion popup
    # bleopt history_share=1 # share history between bash sessions
    # bleopt filename_ls_colors="$LS_COLORS"
    # bleopt accept_line_threshold=-2
    # bleopt exec_errexit_mark= # turn off exit status
    # bleopt complete_menu_maxlines=4
    # bleopt complete_menu_complete= # turn off menu completion

    # bind 'set completion-ignore-case off' # make completion case-sensitive

    # accept autocomplete with tab
    # ble-bind -m auto_complete -f C-i auto_complete/insert
    # ble-bind -m auto_complete -f TAB auto_complete/insert # accept autocomplete with tab
    # ble-bind -m auto_complete -f 'C-c' auto_complete/cancel

    ble-import -d integration/fzf-completion
    ble-import -d integration/fzf-key-bindings

    # set up colors
    ble-face region='fg=${white},bg=${navy}' # selected text in editing line
    ble-face region_target= # "affected region of current command"
    ble-face region_match= # matched range of searches
    ble-face region_insert= # temp texts for dabbrev and menu completion
    ble-face disabled='fg=${grey}'
    ble-face overwrite_mode= # character which will be overwritten by the next input
    ble-face syntax_default='fg=${white}'
    ble-face syntax_command='fg=${green}'
    ble-face syntax_quoted= # quotation content
    ble-face syntax_quotation='copy:syntax_quoted'
    ble-face syntax_escape='fg=${lilac}'
    ble-face syntax_expr='fg=${blue}' # arithmetic expressions
    ble-face syntax_error='fg=${white},bg=${red}'
    ble-face syntax_varname='fg=${blue}'
    ble-face syntax_delimiter='bold' # ; & | etc
    ble-face syntax_param_expansion=
    ble-face syntax_function_name='fg=${lilac}'
    ble-face syntax_comment='fg=${grey}'
    ble-face syntax_glob=
    ble-face syntax_brace=
    ble-face syntax_tilde=
    ble-face syntax_document=
    ble-face syntax_document_begin=
    ble-face command_builtin_dot='copy:command_builtin'
    ble-face command_builtin='copy:syntax_command'
    ble-face command_alias='fg=${green},bold'
    ble-face command_function='copy:syntax_function_name'
    ble-face command_file='fg=${white}'
    ble-face command_keyword='fg=${brown}'
    ble-face command_jobs=
    ble-face command_directory='fg=${blue}'
    ble-face argument_option='fg=${peach}'
    ble-face argument_error='fg=${red}'
    ble-face filename_directory='copy:command_directory'
    ble-face filename_directory_sticky='copy:command_directory'
    ble-face filename_link='fg=${teal}'
    ble-face filename_orphan='fg=${teal},bg=${red}'
    ble-face filename_setuid=
    ble-face filename_setgid=
    ble-face filename_executable='fg=${green}'
    ble-face filename_other= # default
    ble-face filename_socket=
    ble-face filename_pipe=
    ble-face filename_pipe=
    ble-face filename_pipe=
    ble-face filename_pipe=
    ble-face filename_character=
    ble-face filename_block=
    ble-face filename_warning=
    ble-face filename_url='fg=${teal},underline'
    ble-face filename_ls_colors=
    ble-face varname_unset='fg=${red}'
    ble-face varname_export='fg=${peach},bold' # enviroment variables
    ble-face varname_array='copy:syntax_varname'
    ble-face varname_hash='copy:syntax_varname'
    ble-face varname_number='copy:syntax_varname'
    ble-face varname_readonly='fg=${orange}'
    ble-face varname_transform='copy:syntax_varname'
    ble-face varname_empty='copy:varname_unset'
    ble-face varname_expr='copy:syntax_varname'

    # ble-face auto_complete=
    # ble-face cmdinfo_cd_cdpath=
    # ble-face prompt_status_line=
    # ble-face syntax_history_expansion=
    # ble-face vbell=
    # ble-face vbell_erase=
    # ble-face vbell_flash=
  '';
}
