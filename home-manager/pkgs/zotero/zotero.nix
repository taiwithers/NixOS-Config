# not called
{ pkgs, ... }:
{
  home.packages = [ pkgs.zotero ];

  xdg.configFile."Zotero/plugins/betterBibTex.xpi".source =
    let
      version = "6.7.263";
    in
    pkgs.fetchurl {
      url = "https://github.com/retorquere/zotero-better-bibtex/releases/download/v${version}/zotero-better-bibtex-${version}.xpi";
      hash = "sha256-xLFhKDmkj3vMr94S5syZpY3Jx6/aLcudvZI5Vr4Rgv0=";
    };
}
