{ config, pkgs, ... }:
{

programs.firefox = let 
extensions = pkgs.nur.repos.rycee.firefox-addons;
in
rec {
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.enable
  # enable = true;

  policies = { # about:policies
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    NoDefaultBookmarks = true;
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    PromptForDownloadLocation = true;
    ShowHomeButton = false;
  }; 

  profiles."personal" = {
    id = 0;

    extensions = with extensions; [
      tabliss
      ublock-origin
      clearurls
      darkreader
      no-pdf-download
    ];

    search = rec {
      force = true;
      default = "DuckDuckGo";
      privateDefault = default;
      engines = {
        "Google".metaData.hidden = false;
        "Wikipedia".metaData.hidden = false;
        "Bing".metaData.hidden = true;
        "eBay".metaData.hidden = true;
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

      };
    };

    settings = {
      "browser.uiCustomization.state" = {
        "placements" = {
          "widget-overflow-fixed-list" = [];
          "unified-extensions-area" = [
            "ublock0_raymondhill_net-browser-action"
            "addon-darkreader_org-browser-action"
            "_74145f27-f039-47ce-a470-a662b129930a_-browser-action"
          ];
          "nav-bar" = [
            "back-button"
            "forward-button"
            "stop-reload-button"
            "customizableui-special-spring1"
            "urlbar-container"
            "customizableui-special-spring2"
            "downloads-button"
            "unified-extensions-button"
          ];
          "toolbar-menubar" = [ "menubar-items" ];
          "TabsToolbar" = [ "tabbrowser-tabs" "new-tab-button" ];
          "PersonalToolbar" = [];
        };
      };
      "browser.engagement.home-button.has-removed" = true;
      "browser.aboutConfig.showWarning" = false;
      "browser.cache.memory.capacity" = 15000;
      "browser.contentblocking.category" = "strict";
      "browser.download.always_ask_before_handling_new_types" = true;
      "browser.download.useDownloadDir" = false; # ask where to save files
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.showWeather" = false;
      "browser.sessionhistory.max_total_viewers" = 5; # max pages stored in memory to improve back/forward
      "browser.startup.page" = 3; # always restore session
      "extensions.autoDisableScopes" = 0; # enable nix-downloaded extensions
      "extensions.formautofill.addresses.enabled" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = true;
      "network.prefetch-next" = false;
      "privacy.donottrackheader.enabled" = true;
      "privacy.fingerprintingProtection" = true;
      "privacy.globalprivacycontrol.enabled" = true;
      "privacy.query_stripping.enabled" = true;
      "privacy.query_stripping.enabled.pbmode" = true;
      "privacy.trackingprotection.emailtracking.enabled" = true;
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
    };

    userChrome = builtins.readFile ./userChrome.css;

    userContent = builtins.readFile ./userContent.css;
  };

  profiles."queens" = {
    id = 1;
    extensions = profiles."personal".extensions ++ [extensions.zotero-connector];
    settings = profiles."personal".settings;
    search = profiles."personal".search;

    containersForce = true;
    containers.student = {
      color = "blue";
      icon = "circle";
      id = 0;
    };
    containers.staff = {
      color = "orange";
      icon = "briefcase";
      id = 1;
    };

    userChrome = builtins.readFile ./userChrome.css;

    userContent = builtins.readFile ./userContent.css;
  };

};
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

  xdg.dataFile."applications/firefox-profiles/personal.sh".text = ''
    icon_source="/run/current-system/sw/share/icons/hicolor/128x128/apps/nix-snowflake.png"
    icon_target=""
  '';

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
