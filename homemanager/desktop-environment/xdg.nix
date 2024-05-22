# TODO: clean up MIME types
{pkgs, ...}: let
  locateDesktop = import ../../nix-scripts/locate-desktop.nix;

  browser = locateDesktop pkgs.firefox;
  imageviewer = locateDesktop pkgs.loupe;
  texteditor = map (p: "${locateDesktop p}") (with pkgs; [
    unstable.sublime4
    vscodium-fhs
    gnome.gedit
  ]);
  filebrowser = locateDesktop pkgs.libsForQt5.dolphin;
in {
  xdg = {
    enable = true;

    desktopEntries = {};

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/gzip" = []; # .gz , .tgz
        "application/json" = texteditor; # .json
        "application/pdf" = [browser];
        "application/zip-compressed" = []; # .zip
        "application/x-debian-package" = []; # .deb, .udeb
        "application/x-font-ttf" = []; # .ttc, .ttf
        "application/x-shellscript" = texteditor; # .sh
        "application/x-tar" = []; # .tar
        "application/x-tex" = texteditor; # .tex
        "application/xhtml+xml" = [browser];
        "application/yaml" = texteditor; # yaml, yml

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

        "image/*" = [imageviewer];

        "inode/directory" = [filebrowser];

        "text/calendar" = []; # .ics .ifb
        "text/csv" = []; # .csv
        "text/html" = [browser];
        "text/plain" = texteditor; # .conf, .def, .diff, .in, .ksh, .list, .log, .pl, .text, .txt
        "text/x-markdown" = texteditor; # .md, .markdown, .mdown, .markdn
        "text/x-py" = texteditor; # .py

        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/msteams" = ["teams-for-linux.desktop"];
        "x-scheme-handler/zoom-mtg" = ["zoom.desktop"]; # not sure if correct
      };
    };
  };
}
