# TODO: clean up MIME types
{pkgs, ...}: let
  locateDesktop = import ../../nix-scripts/locate-desktop.nix;
  getDesktopFiles = list: map (p: "${locateDesktop p}") list;

  defaults = builtins.mapAttrs (name: value: (getDesktopFiles value)) (with pkgs; {
    browsers = [
      firefox
    ];

    imageviewers = [
      loupe
      firefox
    ];

    texteditors = [
      unstable.sublime4
      vscodium-fhs
      gnome.gedit
    ];

    filebrowsers = [
      libsForQt5.dolphin
    ];
  });
in {
  xdg = {
    enable = true;

    desktopEntries = {};

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/gzip" = []; # .gz , .tgz
        "application/json" = defaults.texteditors; # .json
        "application/pdf" = defaults.browsers;
        "application/zip-compressed" = []; # .zip
        "application/x-debian-package" = []; # .deb, .udeb
        "application/x-font-ttf" = []; # .ttc, .ttf
        "application/x-shellscript" = defaults.texteditors; # .sh
        "application/x-tar" = []; # .tar
        "application/x-tex" = defaults.texteditors; # .tex
        "application/xhtml+xml" = defaults.browsers;
        "application/yaml" = defaults.texteditors; # yaml, yml

        "application/vnd.oasis.opendocument.graphics" = []; # .odg
        "application/vnd.oasis.opendocument.graphics-template" = []; # .otg
        "application/vnd.oasis.opendocument.presentation" = []; # .odp
        "application/vnd.oasis.opendocument.presentation-template" = []; # .otp
        "application/vnd.oasis.opendocument.spreadsheet" = []; # .ods
        "application/vnd.oasis.opendocument.spreadsheet-template" = []; # .ots
        "application/vnd.oasis.opendocument.text" = []; # .odt
        "application/vnd.oasis.opendocument.text-template" = []; # .ott
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = []; # .pptx
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = []; # .docx

        "image/*" = defaults.imageviewers;

        "inode/directory" = defaults.filebrowsers;

        "text/calendar" = []; # .ics .ifb
        "text/csv" = []; # .csv
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
