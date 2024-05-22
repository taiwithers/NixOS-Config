# TODO: clean up MIME types
{pkgs, ...}: let
  locateDesktop = import ../../nix-scripts/locate-desktop.nix;

  browser = locateDesktop pkgs.firefox;
  imageviewer = locateDesktop pkgs.loupe;
  texteditor = locateDesktop pkgs.unstable.sublime4;
in {
  xdg = {
    enable = true;

    desktopEntries = {};

    mimeApps = {
      enable = true;
      defaultApplications = let
        # pull in locate desktop
      in {
        "application/gzip" = []; # .gz , .tgz
        "application/json" = [texteditor]; # .json
        "application/pdf" = [browser];
        "application/zip-compressed" = []; # .zip
        "application/x-debian-package" = []; # .deb, .udeb
        "application/x-font-ttf" = []; # .ttc, .ttf
        "application/x-shellscript" = []; # .sh
        "application/x-tar" = []; # .tar
        "application/x-tex" = []; # .tex
        "application/xhtml+xml" = ["firefox.desktop"];
        "application/yaml" = []; # yaml, yml

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

        "image/*" = []; # .gif
        "image/ico" = []; # .ico
        "image/jpeg" = []; # .jpeg
        "image/png" = []; # .png
        "image/webp" = []; # .webp

        "inode/directory" = ["org.kde.dolphin.desktop"];

        "text/calendar" = []; # .ics .ifb
        "text/csv" = []; # .csv
        "text/html" = ["firefox.desktop"];
        "text/plain" = []; # .conf, .def, .diff, .in, .ksh, .list, .log, .pl, .text, .txt
        "text/x-markdown" = []; # .md, .markdown, .mdown, .markdn
        "text/x-py" = []; # .py

        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/msteams" = ["teams-for-linux.desktop"];
        "x-scheme-handler/zoom-mtg" = ["zoom.desktop"]; # not sure if correct
      };
    };
  };
}
