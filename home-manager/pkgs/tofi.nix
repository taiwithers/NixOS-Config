# 0 very dark grey
# 1 dark blue
# 2 very dark grey
# 3 medium
# 4 light grey
# 5-7 white
# 8 red
# 9 peach
# A orange
# B green
# C very light blue
# D light blue
# E lilac
# F brown
{
  config,
  pkgs,
  app-themes,
  ...
}: {
  programs.tofi = {
    enable = true;
    settings = with app-themes.palettes.tofi; {
      # behaviour
      auto-accept-single = true;
      drun-launch = true; # run selection instead of printing to stdout
      result-spacing = 3; # pixels
      anchor = "center";

      # appearance
      font = "mono";
      font-size = 12;
      text-cursor = true;

      # window
      background-color = "${base01}";
      width = "20%";
      height = "30%";
      corner-radius = 5;

      # outline
      outline-width = 0;
      outline-color = "${base03}";

      # border
      border-width = 6;
      border-color = "${base0C}";

      # text
      text-color = "${base05}";

      input-color = "${base05}";
      input-background = "${base01}";
      input-background-padding = "5,5,5,5";
      input-background-corner-radius = 5;

      placeholder-color = "${base05}";
      placeholder-background = "${base01}";
      placeholder-background-padding = "5,5,5,5";
      placeholder-background-corner-radius = 5;

      prompt-color = "${base05}";
      prompt-background = "${base01}";
      prompt-background-padding = "5,5,5,5";
      prompt-background-corner-radius = 5;

      default-result-color = "${base05}";
      default-result-background = "${base01}";
      default-result-background-padding = "5,5,5,5";
      default-result-background-corner-radius = 5;

      selection-color = "${base05}";
      selection-background = "${base01}";
      selection-background-padding = "5,5,5,5";
      selection-background-corner-radius = 5;
      selection-match-color = "${base05}";
    };
  };
}
