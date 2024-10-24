{ config, pkgs, ... }:
{

  home.file =
    let
      prefix = ".mozilla/firefox/Profiles/";

    in
    {
      "${prefix}/Staff/chrome/userChrome.css".source = ./userChrome.css;
      "${prefix}/Staff/chrome/userContent.css".source = ./userContent.css;

      "${prefix}/Student/chrome/userChrome.css".source = ./userChrome.css;
      "${prefix}/Student/chrome/userContent.css".source = ./userContent.css;

      "${prefix}/Personal/chrome/userChrome.css".source = ./userChrome.css;
      "${prefix}/Personal/chrome/userContent.css".source = ./userContent.css;
    };

  # firefox work profile desktop icon
  xdg.desktopEntries =
    builtins.mapAttrs
      (entryname: profile: rec {
        name = "Firefox - ${entryname}";
        exec = "firefox -P ${profile} %U --name ${name} --class ${name}";
        settings.StartupWMClass = name;
        icon = ./green.png;
      })
      {
        TA = "Staff";
        Personal = "Personal";
        Student = "Student";
      };
}
