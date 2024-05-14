{
  config,
  pkgs,
  ...
}: {
  # fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    cm_unicode
    intel-one-mono
    (nerdfonts.override {fonts = ["SpaceMono" "NerdFontsSymbolsOnly"];})
  ];
}
