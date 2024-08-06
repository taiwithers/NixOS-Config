# not called
{pkgs, ...}: {
  home.file."Zotero/plugins/" = {
    "betterBibTex.xpi" = let
      version = "6.7.203";
    in
      pkgs.fetchurl {
        url = "https://github.com/retorquere/zotero-better-bibtex/releases/download/v${version}/zotero-better-bibtex-${version}.xpi";
        hash = "";
      };
  };
}
