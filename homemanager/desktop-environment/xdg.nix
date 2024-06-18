{pkgs, ...}: let
  locateDesktop = import ../../scripts/locate-desktop.nix;
  getDesktopFiles = list: map (p: "${locateDesktop p}") list;

  defaults = builtins.mapAttrs (name: value: (getDesktopFiles value)) (with pkgs; {
    browsers = [
      firefox
      vivaldi
    ];

    imageviewers = [
      loupe
      firefox
    ];

    texteditors = [
      sublime4
      vscodium-fhs
      gedit
    ];

    filebrowsers = [
      libsForQt5.dolphin
    ];

    archivemanagers = [
      gnome.file-roller
    ];
  });
in {
  xdg = {
    enable = true;

    desktopEntries = {};

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/gzip" = defaults.archivemanagers; # .gz , .tgz
        "application/json" = defaults.texteditors; # .json
        "application/pdf" = defaults.browsers;
        "application/zip-compressed" = defaults.archivemanagers; # .zip
        "application/x-debian-package" = []; # .deb, .udeb
        "application/x-font-ttf" = []; # .ttc, .ttf
        "application/x-shellscript" = defaults.texteditors; # .sh
        "application/x-tar" = defaults.archivemanagers; # .tar
        "application/x-tex" = defaults.texteditors; # .tex
        "application/xhtml+xml" = defaults.browsers;
        "application/yaml" = defaults.texteditors; # yaml, yml

        "application/vnd.oasis.opendocument.graphics*" = ["draw.desktop"]; # .odg
        # "application/vnd.oasis.opendocument.graphics-template" = []; # .otg
        "application/vnd.oasis.opendocument.presentation*" = ["impress.desktop"]; # .odp
        # "application/vnd.oasis.opendocument.presentation-template" = []; # .otp
        "application/vnd.oasis.opendocument.spreadsheet*" = ["calc.desktop"]; # .ods
        # "application/vnd.oasis.opendocument.spreadsheet-template" = []; # .ots
        "application/vnd.oasis.opendocument.text*" = ["writer.desktop"]; # .odt
        # "application/vnd.oasis.opendocument.text-template" = []; # .ott
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["impress.desktop"]; # .pptx
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["writer.desktop"]; # .docx

        "image/*" = defaults.imageviewers;

        "inode/directory" = defaults.filebrowsers;

        "text/calendar" = defaults.browsers; # .ics .ifb
        "text/csv" = builtins.concatLists [["calc.desktop"] defaults.texteditors]; # .csv
        "text/html" = defaults.browsers;
        "text/plain" = defaults.texteditors; # .conf, .def, .diff, .in, .ksh, .list, .log, .pl, .text, .txt
        "text/x-markdown" = defaults.texteditors; # .md, .markdown, .mdown, .markdn
        "text/x-py" = defaults.texteditors; # .py

        "x-scheme-handler/http" = defaults.browsers;
        "x-scheme-handler/https" = defaults.browsers;
        "x-scheme-handler/msteams" = ["teams-for-linux.desktop"];
        "x-scheme-handler/zoom-mtg" = ["zoom.desktop"]; # not sure if correct
      };
    };
  };
}
