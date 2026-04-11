{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      play_sound = {
        # ref: https://github.com/dunst-project/dunst/issues/257
        summary = "*"; # play for all (globbed)
        script = "play-notification-beep";
      };
    };
  };
  home.packages =
    let
      beepFile = builtins.fetchurl {
        # url ripped from view source (in the JS) of the page linked by
        # https://github.com/dunst-project/dunst/issues/257#issuecomment-203863050
        url = "https://media.soundgasm.net/sounds/69d364f647cb05784cd92f5a7affb494cec6d1f4.m4a";
        name = "beep.m4a";
        sha256 = "sha256-G/C0a4/W8m8OmKZfQS9OHiRVTvFM1CH3uGFfqS5dLgI=";
      };
    in
    [
      pkgs.libnotify # provides `notify-send` as a simpler alternative to `dunstify`
      (pkgs.writeShellScriptBin "play-notification-beep"
        # append 2> /dev/null to the end of this to suppress the output if desired
        # nodisp prevents a window from opening, and autoexit closes ffmpeg when the file is done
        "${pkgs.ffmpeg}/bin/ffplay -nodisp -autoexit ${beepFile}"
      )
    ];

  # add some kind of "view all" / view recent?

  # notification scripts:
  # on brightness change - show brightness
  # on caps/num/scroll lock change
  # on volume/mute change - show volume/device/play sound
  # on internet connection change
  # on battery status change
  # on battery percentage change
}
