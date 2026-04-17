{ pkgs, ... }:
let
  fzf-preview = pkgs.writeShellApplication {
    # modified from: https://github.com/junegunn/fzf/blob/master/bin/fzf-preview.sh
    name = "fzf-previewer";
    runtimeInputs = with pkgs; [
      eza
      file
      chafa
      bat
    ];
    text = ''
      # Not entirely sure what this section is
      if [[ $# -ne 1 ]]; then
        >&2 echo "usage: $0 FILENAME[:LINENO][:IGNORED]"
        exit 1
      fi

      # check file type
      file_to_preview=''${1/#\~\//$HOME/}

      # get vertical center
      center=0
      if [[ ! -r $file_to_preview ]]; then
        if [[ $file_to_preview =~ ^(.+):([0-9]+)\ *$ ]] && [[ -r ''${BASH_REMATCH [ 1 ]} ]]; then
          file_to_preview=''${BASH_REMATCH [ 1 ]}
          center=''${BASH_REMATCH [ 2 ]}
        elif [[ $file_to_preview =~ ^(.+):([0-9]+):[0-9]+\ *$ ]] && [[ -r ''${BASH_REMATCH [ 1 ]} ]]; then
          file_to_preview=''${BASH_REMATCH [ 1 ]}
          center=''${BASH_REMATCH [ 2 ]}
        fi
      fi

      type=$(file --brief --dereference --mime -- "$file_to_preview")

      # text or binary files `=~` is regex matching
      if [[ ! $type =~ image/ ]]; then
        # use eza for directories
        if [[ $type =~ directory ]]; then
          eza --tree --level=1 --all --group-directories-first --colour=always "$1"
          exit
        fi

        # just show info for binary files
        if [[ $type =~ =binary ]]; then
          file "$1"
          exit
        fi

        # fall back to bat
        bat --style=-header --style=-numbers --color=always --pager=never --highlight-line="''${center:-0}" -- "$file_to_preview"
        exit
      fi

      # no idea what this is either, something to do with finding the image dimensions
      height=''${FZF_PREVIEW_LINES:-""}
      width=''${FZF_PREVIEW_COLUMNS:-""}
      dim=''${width}x''${height}
      if [[ $dim == x ]]; then
        dim=$(stty size < /dev/tty | awk '{print $2 "x" $1}')
      elif ! [[ ''${KITTY_WINDOW_ID:-""} ]] && ((FZF_PREVIEW_TOP + FZF_PREVIEW_LINES == $(stty size < /dev/tty | awk '{print $1}'))); then
        # Avoid scrolling issue when the Sixel image touches the bottom of the screen
        # * https://github.com/junegunn/fzf/issues/2544
        dim=''${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))
      fi

      # 1. Use icat (from Kitty) if kitten is installed
      if [[ ''${KITTY_WINDOW_ID:-""} ]] || [[ ''${GHOSTTY_RESOURCES_DIR:-""} ]] && command -v kitten > /dev/null; then
        # 1. 'memory' is the fastest option but if you want the image to be scrollable,
        #    you have to use 'stream'.
        #
        # 2. The last line of the output is the ANSI reset code without newline.
        #    This confuses fzf and makes it render scroll offset indicator.
        #    So we remove the last line and append the reset code to its previous line.
        kitten icat --clear --transfer-mode=memory --unicode-placeholder --stdin=no --place="$dim@0x0" "$file_to_preview" | sed '$d' | sed $'$s/$/\e[m/'

      # 2. Use chafa with Sixel output
      elif command -v chafa > /dev/null; then
        chafa -s "$dim" "$file_to_preview"
        # Add a new line character so that fzf can display multiple images in the preview window
        echo

      # 3. Cannot find any suitable method to preview the image
      else
        file "$file_to_preview"
      fi
    '';
  };
  fzfDefaultOptions = [
    "--layout reverse"
    "--height '~60%'"
    "--border sharp"
    "--margin 0,3%"
    "--info inline"
    "--tabstop 4"
  ];
in
{
  home.packages = [ fzf-preview ];
  programs.fzf = rec {
    enable = true;
    colors = { };

    # typing "fzf" as a command
    defaultCommand = "fd --type file --type symlink";
    defaultOptions = fzfDefaultOptions;

    # ctrl-r
    historyWidgetOptions = fzfDefaultOptions;

    # alt-c
    changeDirWidgetCommand = "fd --type directory";
    changeDirWidgetOptions = fzfDefaultOptions ++ [ "--preview 'fzf-previewer {}'" ];

    # ctrl-t
    fileWidgetCommand = defaultCommand;
    fileWidgetOptions = fzfDefaultOptions ++ [ "--preview 'fzf-previewer {}'" ];
  };
}
