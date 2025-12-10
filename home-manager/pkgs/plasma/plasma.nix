# https://github.com/shalva97/kde-configuration-files
# https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.kwin.borderlessMaximizedWindows
{
  config,
  pkgs,
  plasma-manager,
  colours,
  ...
}:
let
  cursor = {
    name = "Posy_Cursor_Black";
    size = 32;
    package = pkgs.posy-cursors;
  };

  fonts = rec {
    sans = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
      size = 12;
      weight = "light";
    };
    mono = {
      name = "Liberation Mono";
      package = pkgs.liberation_ttf;
      inherit (sans) size;
      weight = "regular";
    };
  };

  gtk-theme = {
    name = "Breeze-Dark";
    package = pkgs.kdePackages.breeze-gtk;
  };

  klassy-names = {
    window-decorations = {
      theme = "Klassy";
      library = "org.kde.klassy";
    };
    icon-theme = "klassy-dark";
  };

  aritim-dark-source =
    (pkgs.fetchFromGitHub {
      owner = "Mrcuve0";
      repo = "Aritim-Dark";
      rev = "b53c45e";
      hash = "sha256-N6Wybu7JVbuYmfup3C/cCsBnlgjW0yhs2FOiIJz1NRI=";
      sparseCheckout = [ "KDE/plasmaTheme/Aritim-Dark-Flat-Blur" ];
    })
    + "/KDE/plasmaTheme/Aritim-Dark-Flat-Blur";
in
rec {
  imports = [
    plasma-manager.homeModules.plasma-manager
  ];

  qt.enable = true;
  qt.style.package = pkgs.kdePackages.darkly;
  # qt.platformTheme.name = "qtct";

  home.packages =
    with pkgs.kdePackages;
    [
      klassy
      kara
      krohnkite
      kwin-forceblur
    ]
    ++ [ pkgs.where-is-my-sddm-theme ]
    ++ [ cursor.package ];

  xdg.dataFile."plasma/plasmoids/org.kde.plasma.shutdownorswitch".source =
    (pkgs.fetchFromGitHub {
      owner = "Davide-sd";
      repo = "shutdown_or_switch";
      rev = "ee2e597";
      hash = "sha256-Q/rahjtryiXvzzwkjQiwL4cPTCfuYdjp6q4QkodrhZI=";
    })
    + "/package";

  # xdg.dataFile."plasma/look-and-feel/Magna-Splash-6".source =
  #   (pkgs.fetchFromGitHub {
  #     owner = "L4ki";
  #     repo = "Magna-Plasma-Themes";
  #     rev = "cff6c2d";
  #     hash = "sha256-yYQBtjDOWiu33fVvnv83At0nA5mOmYZldgV4VsMxd2M=";
  #     sparseCheckout = [ "Magna-Splahscreen" ];
  #   })
  #   + "/Magna-Splash-6";

  xdg.dataFile."plasma/plasmoids/Compact.Menu".source = ./Compact.Menu;

  xdg.dataFile."plasma/desktoptheme/Aritim-Dark-Flat-Blur/dialogs".source =
    aritim-dark-source + "/dialogs";
  xdg.dataFile."plasma/desktoptheme/Aritim-Dark-Flat-Blur/widgets".source =
    aritim-dark-source + "/widgets";
  xdg.dataFile."plasma/desktoptheme/Aritim-Dark-Flat-Blur/metadata.desktop".source =
    aritim-dark-source + "/metadata.desktop";

  # override the home manager gtk config
  xdg.configFile."gtkrc-2.0".text = ''
    gtk-alternative-button-order=1
    gtk-button-images=1
    gtk-cursor-theme-name="${cursor.name}"
    gtk-cursor-theme-size=${builtins.toString cursor.size}
    gtk-enable-animations=1
    gtk-font-name="${fonts.sans.name} ${builtins.toString fonts.sans.size}"
    gtk-icon-theme-name="${klassy-names.icon-theme}"
    gtk-menu-images=1
    gtk-primary-button-warps-slider=1
    gtk-sound-theme-name="${programs.plasma.workspace.soundTheme}"
    gtk-theme-name="${gtk-theme.name}"
    gtk-toolbar-style=3
  '';
  # xdg.configFile."gtkrc-2.0".force = true;

  xdg.configFile."gtk-4.0/window_decorations.css".source =
    "${pkgs.kdePackages.kde-gtk-config}/share/themes/Breeze/window_decorations.css";
  xdg.configFile."gtk-3.0/window_decorations.css".source =
    "${pkgs.kdePackages.kde-gtk-config}/share/themes/Breeze/window_decorations.css";

  gtk = rec {
    enable = true;
    gtk2.configLocation = "${config.common.configHome}/gtkrc-2.0";
    font = with fonts.sans; {
      inherit name;
      inherit package;
      inherit size;
    };
    cursorTheme = cursor;
    theme = gtk-theme;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-button-images = true;
      gtk-decoration-layout = ":minimize,maximize,close";
      gtk-enable-animations = true;
      gtk-icon-theme-name = programs.plasma.workspace.iconTheme;
      gtk-menu-images = true;
      gtk-modules = "window-decorations-gtk-module:colorreload-gtk-module";
      gtk-primary-button-warps-slider = true;
      gtk-sound-theme-name = programs.plasma.workspace.soundTheme;
      gtk-toolbar-style = 3;
      gtk-xft-dpi = 122880;
    };
    # need both for things to apply correctly
    gtk3.extraCss = ''
      @import url("file://${gtk-theme.package}/share/themes/${gtk-theme.name}/gtk-3.0/gtk.css");
      @import 'colors.css';
      @import 'window_decorations.css';
    '';

    gtk4.extraConfig = gtk3.extraConfig;
    gtk4.extraCss = ''
      @import url("file://${gtk-theme.package}/share/themes/${gtk-theme.name}/gtk-4.0/gtk.css");
      @import 'colors.css';
      @import 'window_decorations.css';
    '';
  };

  programs.plasma = {
    enable = true;
    resetFiles = [ ]; # files to delete on each generation, string paths relative to config home
    resetFilesExclude = [ ]; # files to NOT delete on each generation
    immutableByDefault = false;
    overrideConfig = true; # read description before changing https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.overrideConfig

    ###############################
    # Environment Aesthetics
    ###############################
    # workspace.lookAndFeel = "org.kde.breezedark.desktop"; # global theme
    workspace.colorScheme = "custom";
    workspace.wallpaper = builtins.fetchurl {
      url = "https://images.unsplash.com/photo-1487528699198-88d79d72479f";
      name = "flowers.jpg";
      sha256 = "sha256:0vy1g8qzllppk4zihwd6qjkbfj56y27pydv7r1c43hq1n5w2qccp";
    };
    configFile.kdeglobals.General.AccentColor = colours.rgb255-commasep.blue-grey; # "146,110,228";
    configFile.kdeglobals.KDE.widgetStyle = "Darkly"; # application style

    workspace.theme = "Aritim-Dark-Flat-Blur"; # plasma style / desktop theme

    workspace.windowDecorations = klassy-names.window-decorations;
    workspace.iconTheme = klassy-names.icon-theme;
    workspace.cursor = {
      theme = cursor.name;
      inherit (cursor) size;
    };
    workspace.soundTheme = "ocean";
    # workspace.splashScreen.theme = "Magna-Splash-6"; # engine is KSplashQML

    configFile.kwinrc.Xwayland.Scale = 1.25;

    fonts = rec {
      fixedWidth = {
        family = "";
        inherit (general) pointSize;
      };
      general = with fonts.sans; {
        family = name;
        pointSize = size;
        inherit weight;
      };
      small = general // {
        pointSize = 9;
      };
      menu = small;
      toolbar = small;
      windowTitle = small;
    };

    panels =
      let
        topPanelHeight = 36;
        bottomPanelHeight = 50;
        hidingMode = "autohide"; # "dodgewindows" breaks sometimes

        plasmoids = rec {
          kara = {
            name = "org.dhruv8sh.kara";
            config.general = {
              spacing = 4;
              type = 0;
              wrapOn = false;
            };
            config.type1.t1activeWidth = 30; # active pill width
            config.type2.fixedLen = 30;
            config.appearance = {
              defaultAltTextColors = false;
              plasmaTxtColors = false;
              altColor = colours.rgb255-commasep.cyan; # active pill colour
              txtColor = colours.rgb255-commasep.blue-grey;
            };
          };

          dateTimeClock = {
            digitalClock = {
              date.enable = true;
              time.showSeconds = "never";
              time.format = "24h";
              timeZone.selected = [ "Local" ];
              font = {
                family = "Monospace";
                weight = 400;
              };
            };
          };

          timeClock = {
            digitalClock = dateTimeClock.digitalClock // {
              date.enable = false;
            };
          };

          spacer = {
            panelSpacer.expanding = true;
          };

          taskbar = {
            iconTasks = {
              launchers = [ ];
              appearance = {
                showTooltips = true;
                highlightWindows = true;
                indicateAudioStreams = true;
                fill = false;
                rows.multirowView = "never";
                iconSpacing = "medium";
              };
              behavior = {
                grouping.method = "none";
                grouping.clickAction = "cycle";
                sortingMethod = "manually";
                minimizeActiveTaskOnClick = true;
                middleClickAction = "newInstance";
                wheel.switchBetweenTasks = true;
                wheel.ignoreMinimizedTasks = true;
                showTasks = {
                  onlyInCurrentScreen = true;
                  onlyInCurrentDesktop = true;
                  onlyInCurrentActivity = true;
                  onlyMinimized = false;
                };
                unhideOnAttentionNeeded = true;
                newTasksAppearOn = "right";

              };
            };
          };

          systemtray = {
            systemTray = {
              pin = false;
              icons.spacing = "small";
              icons.scaleToFit = false;
              items.showAll = false;
              items.hidden =
                (map (x: "org.kde.plasma." + x) [
                  # seem to be permanently hidden
                  "bluetooth"
                  "clipboard"
                  "networkmanagement"
                  "printmanager"
                ])
                ++ [
                  # some of these show up in the dropdown
                  "org.kde.kdeconnect"
                  "OneDriveGUI"
                  "KeePassXC"
                  "steam"
                  "spotify-client"
                ];
              # items.shown = map (x: "org.kde.plasma." + x) [
              #   ];
              items.extra = map (x: "org.kde.plasma." + x) [
                "brightness" # main visible area
                "volume"
                "cameraindicator"
                "devicenotifier"
                "keyboardindicator" # lock keys status
                "battery"
                "mediacontroller"
              ];
              items.configs = {
                battery.showPercentage = true;
              };
            };
          };

          colorizer = {
            plasmaPanelColorizer = {
              general.enable = true;
              general.hideWidget = true;
              widgetBackground = {
                enable = true;
                colorMode.mode = "static";
                colors.source = "custom";
                colors.customColor = colours.hex-hash.navy;
                shape.opacity = 0.2;
                shape.radius = 0;
                shape.outline.colorSource = "custom";
                shape.outline.customColor = colours.hex-hash.blue-grey;
                shape.outline.width = 2;
              };
              textAndIcons = {
                enable = true;
                colorMode.mode = "static";
                colors.source = "custom";
                colors.customColor = colours.hex-hash.ivory;
              };
            };
          };

          startmenu = {
            name = "Compact.Menu";
            config.General = {
              icon = "nix-snowflake-white";
              alphaSort = true;
              compactMode = true;
              displayPosition = "Default";
              favoritesPortedToKAstats = true;
              systemFavorites = "suspend\\,hibernate\\,reboot\\,shutdown";
            };
          };
        };
      in
      [
        # main screen top centre
        {
          alignment = "center";
          floating = true;
          height = topPanelHeight;
          hiding = hidingMode;
          lengthMode = "fit";
          location = "top"; # or "floating"
          offset = 100; # ? from anchor
          opacity = "adaptive";
          screen = 0;
          widgets = [
            plasmoids.colorizer
            plasmoids.kara
            plasmoids.timeClock
            "org.kde.plasma.notifications"
          ];
        }

        # main screen launcher
        {
          alignment = "center";
          floating = true;
          height = bottomPanelHeight;
          hiding = hidingMode;
          lengthMode = "fit";
          location = "bottom"; # or "floating"
          offset = 100; # ? from anchor
          opacity = "adaptive";
          screen = 0;
          widgets = [
            plasmoids.colorizer
            plasmoids.startmenu
            (
              plasmoids.taskbar
              // {
                iconTasks = {
                  launchers = [
                    "preferred://browser"
                    "preferred://filemanager"
                    "preferred://terminal"
                    "applications:kitty.desktop"
                  ];
                };
              }
            )
          ];
        }

        # main screen system tray
        {
          alignment = "right";
          extraSettings = ""; # https://develop.kde.org/docs/plasma/scripting/
          floating = true;
          height = topPanelHeight;
          hiding = hidingMode;
          lengthMode = "fit";
          location = "top"; # or "floating"
          offset = 100; # ? from anchor
          opacity = "adaptive";
          screen = 0;
          widgets = [
            plasmoids.colorizer
            plasmoids.systemtray
            {
              name = "org.kde.plasma.shutdownorswitch";
              config.General.showHybernate = true;
              config.General.showSuspend = true;
            }
          ];
        }

        # additional screen bars
        {
          alignment = "center";
          floating = true;
          height = bottomPanelHeight;
          hiding = hidingMode;
          lengthMode = "fill";
          location = "bottom"; # or "floating"
          offset = 100; # ? from anchor
          opacity = "adaptive";
          screen = 1;
          widgets = [
            plasmoids.colorizer
            plasmoids.kara
            { inherit ((plasmoids.dateTimeClock // { font.size = 12; })) digitalClock; } # I don't know, I'm sorry
            plasmoids.spacer
            plasmoids.taskbar
            plasmoids.spacer
            plasmoids.systemtray
          ];
        }
      ];

    # startup.desktopScript."set_desktop_folder_settings" = {
    #   text = ''
    #     let allDesktops = desktops();
    #     for (const desktop of allDesktops) {
    #       desktop.currentConfigGroup = ["General"];
    #       desktop.writeConfig("url", "desktop:/Documents/Empty/");
    #     }
    #   '';
    #   # activities:/current/
    #   priority = 3;
    # };

    kscreenlocker = {
      appearance = {
        alwaysShowClock = true;
        showMediaControls = true;
        wallpaper = "${config.common.nixConfigDirectory}/NixOS/main/background.png";
      };
      timeout = 15; # minutes until screen locks
      lockOnResume = false;
      passwordRequiredDelay = 900; # seconds after screen lock
    };

    ###############################
    # Keyboard and Mouse
    ###############################
    # input.mice = {}; # https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.input.mice
    # input.touchpads = {}; # https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.input.touchpads
    input.keyboard.numlockOnStartup = "on";
    input.mice = [
      {
        enable = true;
        name = "LIFT MAC Mouse"; # LIFT MAC Mouse
        productId = "b031";
        vendorId = "046d";
      }
    ];
    input.touchpads = [
      {
        enable = true;
        disableWhileTyping = true;
        naturalScroll = true;
        rightClickMethod = "bottomRight";
        scrollMethod = "twoFingers";
        tapToClick = true;
        name = "VEN_04F3:00 04F3:311C Touchpad";
        productId = "311c";
        vendorId = "04f3";
      }
    ];

    desktop.mouseActions = {
      leftClick = null;
      middleClick = null;
      rightClick = "contextMenu";
      verticalScroll = null;
    };

    krunner = {
      activateWhenTypingOnDesktop = false;
    };

    workspace.enableMiddleClickPaste = false;

    # hotkeys to run commands
    hotkeys.commands = {
      launch-rofi = {
        keys = [ "Meta+Space" ];
        command = "rofi -show";
        comment = "Launch rofi.";
      };
      open-settings = {
        keys = [ "Meta+I" ];
        command = "systemsettings";
      };
    };

    # Global keyboard shortcuts:
    shortcuts = {
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "none";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "none";

      "kaccess"."Toggle Screen Reader On and Off" = "none";

      "kcm_touchpad"."Disable Touchpad" = "none";
      "kcm_touchpad"."Enable Touchpad" = "none";
      "kcm_touchpad"."Toggle Touchpad" = [ "none" ];

      "kmix"."decrease_microphone_volume" = "none";
      "kmix"."decrease_volume" = [
        "Ctrl+Alt+Down"
        "Volume Down"
      ]; # ["Ctrl+Alt+Down" "Volume Down,Volume Down,Decrease Volume"];
      "kmix"."decrease_volume_small" = "none";
      "kmix"."increase_microphone_volume" = "none";
      "kmix"."increase_volume" = [
        "Ctrl+Alt+Up"
        "Volume Up"
      ];
      "kmix"."increase_volume_small" = "none";
      "kmix"."mic_mute" = [ "none" ];
      "kmix"."mute" = "Volume Mute";
      "mediacontrol"."mediavolumedown" = "none";
      "mediacontrol"."mediavolumeup" = "none";
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playmedia" = "none";
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";

      # power
      "ksmserver"."Halt Without Confirmation" = "none";
      "ksmserver"."Lock Session" = [ "none" ];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "ksmserver"."Log Out Without Confirmation" = "none";
      "ksmserver"."LogOut" = "none";
      "ksmserver"."Reboot" = "none";
      "ksmserver"."Reboot Without Confirmation" = "none";
      "ksmserver"."Shut Down" = "none";
      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = "none";
      "org_kde_powerdevil"."Hibernate" = "none";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" = "none";
      "org_kde_powerdevil"."PowerDown" = "none";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "none";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."Turn Off Screen" = [ ];
      "org_kde_powerdevil"."powerProfile" = [ "none" ];

      # windows
      "kwin"."Activate Window Demanding Attention" = "none";
      "kwin"."Cycle Overview" = [ ];
      "kwin"."Cycle Overview Opposite" = [ ];
      "kwin"."Decrease Opacity" = "none";
      "kwin"."Edit Tiles" = "none";
      "kwin"."Expose" = "none";
      "kwin"."ExposeAll" = [ "none" ];
      "kwin"."ExposeClass" = "none";
      "kwin"."ExposeClassCurrentDesktop" = [ ];
      "kwin"."Grid View" = "none";
      "kwin"."Increase Opacity" = "none";
      "kwin"."Kill Window" = "Alt+F4";
      "kwin"."KrohnkiteBTreeLayout" = [ ];
      "kwin"."KrohnkiteColumnsLayout" = [ ];
      "kwin"."KrohnkiteDecrease" = [ ];
      "kwin"."KrohnkiteFloatAll" = "Meta+Shift+F";
      "kwin"."KrohnkiteFloatingLayout" = [ ];
      "kwin"."KrohnkiteFocusDown" = "Meta+J";
      "kwin"."KrohnkiteFocusLeft" = "Meta+H";
      "kwin"."KrohnkiteFocusNext" = "Meta+N";
      "kwin"."KrohnkiteFocusPrev" = "Meta+P";
      "kwin"."KrohnkiteFocusRight" = "Meta+L";
      "kwin"."KrohnkiteFocusUp" = "Meta+K";
      "kwin"."KrohnkiteGrowHeight" = [ ];
      "kwin"."KrohnkiteIncrease" = [ ];
      "kwin"."KrohnkiteMonocleLayout" = [ ];
      "kwin"."KrohnkiteNextLayout" = "Meta+Shift+N";
      "kwin"."KrohnkitePrevLayout" = [ ];
      "kwin"."KrohnkitePreviousLayout" = "Meta+Shift+P";
      "kwin"."KrohnkiteQuarterLayout" = [ ];
      "kwin"."KrohnkiteRotate" = "Meta+R";
      "kwin"."KrohnkiteRotatePart" = "Meta+Shift+R";
      "kwin"."KrohnkiteSetMaster" = "Meta+Return";
      "kwin"."KrohnkiteShiftDown" = "Meta+Shift+J";
      "kwin"."KrohnkiteShiftLeft" = "Meta+Shift+H";
      "kwin"."KrohnkiteShiftRight" = "Meta+Shift+L";
      "kwin"."KrohnkiteShiftUp" = "Meta+Shift+K";
      "kwin"."KrohnkiteShrinkHeight" = [ ];
      "kwin"."KrohnkiteShrinkWidth" = [ ];
      "kwin"."KrohnkiteSpiralLayout" = [ ];
      "kwin"."KrohnkiteSpreadLayout" = [ ];
      "kwin"."KrohnkiteStackedLayout" = [ ];
      "kwin"."KrohnkiteStairLayout" = [ ];
      "kwin"."KrohnkiteTileLayout" = [ ];
      "kwin"."KrohnkiteToggleFloat" = "Meta+F";
      "kwin"."KrohnkiteTreeColumnLayout" = [ ];
      "kwin"."KrohnkitegrowWidth" = [ ];
      "kwin"."Move Tablet to Next Output" = [ ];
      "kwin"."Overview" = "Meta+Tab";
      "kwin"."Setup Window Shortcut" = "none";
      "kwin"."Show Desktop" = "none";
      "kwin"."Switch One Desktop Down" = "none";
      "kwin"."Switch One Desktop Up" = "none";
      "kwin"."Switch One Desktop to the Left" = "none";
      "kwin"."Switch One Desktop to the Right" = "none";
      "kwin"."Switch Window Down" = "none";
      "kwin"."Switch Window Left" = "none";
      "kwin"."Switch Window Right" = "none";
      "kwin"."Switch Window Up" = "none";
      "kwin"."Switch to Desktop 1" = "none";
      "kwin"."Switch to Desktop 10" = "none";
      "kwin"."Switch to Desktop 11" = "none";
      "kwin"."Switch to Desktop 12" = "none";
      "kwin"."Switch to Desktop 13" = "none";
      "kwin"."Switch to Desktop 14" = "none";
      "kwin"."Switch to Desktop 15" = "none";
      "kwin"."Switch to Desktop 16" = "none";
      "kwin"."Switch to Desktop 17" = "none";
      "kwin"."Switch to Desktop 18" = "none";
      "kwin"."Switch to Desktop 19" = "none";
      "kwin"."Switch to Desktop 2" = "none";
      "kwin"."Switch to Desktop 20" = "none";
      "kwin"."Switch to Desktop 3" = "none";
      "kwin"."Switch to Desktop 4" = "none";
      "kwin"."Switch to Desktop 5" = "none";
      "kwin"."Switch to Desktop 6" = "none";
      "kwin"."Switch to Desktop 7" = "none";
      "kwin"."Switch to Desktop 8" = "none";
      "kwin"."Switch to Desktop 9" = "none";
      "kwin"."Switch to Next Desktop" = "none";
      "kwin"."Switch to Next Screen" = "none";
      "kwin"."Switch to Previous Desktop" = "none";
      "kwin"."Switch to Previous Screen" = "none";
      "kwin"."Switch to Screen 0" = "none";
      "kwin"."Switch to Screen 1" = "none";
      "kwin"."Switch to Screen 2" = "none";
      "kwin"."Switch to Screen 3" = "none";
      "kwin"."Switch to Screen 4" = "none";
      "kwin"."Switch to Screen 5" = "none";
      "kwin"."Switch to Screen 6" = "none";
      "kwin"."Switch to Screen 7" = "none";
      "kwin"."Switch to Screen Above" = "none";
      "kwin"."Switch to Screen Below" = "none";
      "kwin"."Switch to Screen to the Left" = "none";
      "kwin"."Switch to Screen to the Right" = "none";
      "kwin"."Toggle Night Color" = [ ];
      "kwin"."Toggle Window Raise/Lower" = "none";
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      "kwin"."Walk Through Windows Alternative" = "none";
      "kwin"."Walk Through Windows Alternative (Reverse)" = "none";
      "kwin"."Walk Through Windows of Current Application" = "none";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "none";
      "kwin"."Walk Through Windows of Current Application Alternative" = "none";
      "kwin"."Walk Through Windows of Current Application Alternative (Reverse)" = "none";
      "kwin"."Window Above Other Windows" = "none";
      "kwin"."Window Below Other Windows" = "none";
      "kwin"."Window Close" = "none";
      "kwin"."Window Fullscreen" = "F11";
      "kwin"."Window Grow Horizontal" = "none";
      "kwin"."Window Grow Vertical" = "none";
      "kwin"."Window Lower" = "none";
      "kwin"."Window Maximize" = [
        "Meta+End"
        "Meta+PgUp"
      ];
      "kwin"."Window Maximize Horizontal" = "none";
      "kwin"."Window Maximize Vertical" = "none";
      "kwin"."Window Minimize" = [
        "Meta+Home"
        "Meta+PgDown"
      ];
      "kwin"."Window Move" = "none";
      "kwin"."Window Move Center" = "none";
      "kwin"."Window No Border" = "none";
      "kwin"."Window On All Desktops" = "none";
      "kwin"."Window One Desktop Down" = "none";
      "kwin"."Window One Desktop Up" = "none";
      "kwin"."Window One Desktop to the Left" = "none";
      "kwin"."Window One Desktop to the Right" = "none";
      "kwin"."Window One Screen Down" = "none";
      "kwin"."Window One Screen Up" = "none";
      "kwin"."Window One Screen to the Left" = "none";
      "kwin"."Window One Screen to the Right" = "none";
      "kwin"."Window Operations Menu" = "none";
      "kwin"."Window Pack Down" = "none";
      "kwin"."Window Pack Left" = "none";
      "kwin"."Window Pack Right" = "none";
      "kwin"."Window Pack Up" = "none";
      "kwin"."Window Quick Tile Bottom" = "none";
      "kwin"."Window Quick Tile Bottom Left" = "none";
      "kwin"."Window Quick Tile Bottom Right" = "none";
      "kwin"."Window Quick Tile Left" = "none";
      "kwin"."Window Quick Tile Right" = "none";
      "kwin"."Window Quick Tile Top" = "none";
      "kwin"."Window Quick Tile Top Left" = "none";
      "kwin"."Window Quick Tile Top Right" = "none";
      "kwin"."Window Raise" = "none";
      "kwin"."Window Resize" = "none";
      "kwin"."Window Shade" = "none";
      "kwin"."Window Shrink Horizontal" = "none";
      "kwin"."Window Shrink Vertical" = "none";
      "kwin"."Window to Desktop 1" = "none";
      "kwin"."Window to Desktop 10" = "none";
      "kwin"."Window to Desktop 11" = "none";
      "kwin"."Window to Desktop 12" = "none";
      "kwin"."Window to Desktop 13" = "none";
      "kwin"."Window to Desktop 14" = "none";
      "kwin"."Window to Desktop 15" = "none";
      "kwin"."Window to Desktop 16" = "none";
      "kwin"."Window to Desktop 17" = "none";
      "kwin"."Window to Desktop 18" = "none";
      "kwin"."Window to Desktop 19" = "none";
      "kwin"."Window to Desktop 2" = "none";
      "kwin"."Window to Desktop 20" = "none";
      "kwin"."Window to Desktop 3" = "none";
      "kwin"."Window to Desktop 4" = "none";
      "kwin"."Window to Desktop 5" = "none";
      "kwin"."Window to Desktop 6" = "none";
      "kwin"."Window to Desktop 7" = "none";
      "kwin"."Window to Desktop 8" = "none";
      "kwin"."Window to Desktop 9" = "none";
      "kwin"."Window to Next Desktop" = "none";
      "kwin"."Window to Next Screen" = "none";
      "kwin"."Window to Previous Desktop" = "none";
      "kwin"."Window to Previous Screen" = "none";
      "kwin"."Window to Screen 0" = "none";
      "kwin"."Window to Screen 1" = "none";
      "kwin"."Window to Screen 2" = "none";
      "kwin"."Window to Screen 3" = "none";
      "kwin"."Window to Screen 4" = "none";
      "kwin"."Window to Screen 5" = "none";
      "kwin"."Window to Screen 6" = "none";
      "kwin"."Window to Screen 7" = "none";
      "plasmashell"."activate application launcher" = [ "Meta" ];
      "plasmashell"."activate task manager entry 1" = "Meta+1";
      "plasmashell"."activate task manager entry 10" = "Meta+0";
      "plasmashell"."activate task manager entry 2" = "Meta+2";
      "plasmashell"."activate task manager entry 3" = "Meta+3";
      "plasmashell"."activate task manager entry 4" = "Meta+4";
      "plasmashell"."activate task manager entry 5" = "Meta+5";
      "plasmashell"."activate task manager entry 6" = "Meta+6";
      "plasmashell"."activate task manager entry 7" = "Meta+7";
      "plasmashell"."activate task manager entry 8" = "Meta+8";
      "plasmashell"."activate task manager entry 9" = "Meta+9";

      "plasmashell"."clear-history" = "none";
      "plasmashell"."clipboard_action" = "none";
      "plasmashell"."cycle-panels" = "none";
      "plasmashell"."cycleNextAction" = "none";
      "plasmashell"."cyclePrevAction" = "none";
      "plasmashell"."manage activities" = "none";
      "plasmashell"."next activity" = [ ];
      "plasmashell"."previous activity" = [ ];
      "plasmashell"."repeat_action" = "none";
      "plasmashell"."show dashboard" = "none";
      "plasmashell"."show-barcode" = "none";
      "plasmashell"."show-on-mouse-pos" = "Meta+V"; # clipboard history
      "plasmashell"."stop current activity" = "none";
      "plasmashell"."switch to next activity" = "none";
      "plasmashell"."switch to previous activity" = "none";
      "plasmashell"."toggle do not disturb" = "none";
    };

    spectacle.shortcuts = {
      captureActiveWindow = [ ];
      captureCurrentMonitor = [ ];
      captureEntireDesktop = [ ];
      captureRectangularRegion = [ "Print" ];
      captureWindowUnderCursor = [ ];
      launch = [ ];
      launchWithoutCapturing = [ ];
      recordRegion = [ ];
      recordScreen = [ ];
      recordWindow = [ ];
    };

    ###############################
    # Window Aesthetics
    ###############################
    kwin.borderlessMaximizedWindows = false;

    kwin.effects = {
      blur.enable = false;
      blur.noiseStrength = 10;
      blur.strength = 5;
      desktopSwitching.animation = "slide";
      dimInactive.enable = false;
      minimization.animation = "off";
      shakeCursor.enable = true;
      translucency.enable = true;
    };

    kwin.nightLight = {
      enable = true;
      mode = "location";
      temperature.day = 5800;
      temperature.night = 3600;
      location.latitude = "46.030534351145036";
      location.longitude = "-78.49624060150377";
    };

    configFile.kwinrc."Effect-blurplus" = {
      "BlurDecorations" = true;
      "BlurDocks" = false;
      "BlurMatching" = false;
      "BlurMenus" = true;
      "BlurNonMatching" = true;
      "FakeBlur" = true;
      "NoiseStrength" = 0;
      "WindowClasses" = builtins.concatStringsSep "\n" [
        "kdeconnectd"
      ];
    };

    # turn off hot corner
    configFile.kwinrc."Effect-overview" = {
      "BorderActivate" = 9;
    };

    configFile.kwinrc."Effect-translucency" = {
      "ComboboxPopups" = 90;
      "Dialogs" = 90;
      "Menus" = 90;
      "MoveResize" = 75;
    };

    kwin.titlebarButtons = {
      left = [ ];
      right = [
        "minimize"
        "maximize"
        "close"
      ];
    };

    ###############################
    # Power
    ###############################
    configFile.powerdevilrc."General"."pausePlayersOnSuspend" = false;
    powerdevil = rec {
      batteryLevels = {
        lowLevel = 20;

        criticalAction = "hibernate";
        criticalLevel = 5;
      };

      AC = {
        autoSuspend.action = "sleep";
        autoSuspend.idleTimeout = 60 * 30; # time to autoSuspend action
        dimDisplay.enable = false;

        powerButtonAction = "showLogoutScreen";
        turnOffDisplay.idleTimeout = null; # should let autoSuspend kick in instead
        turnOffDisplay.idleTimeoutWhenLocked = "whenLockedAndUnlocked"; # should let autoSuspend kick in instead

        whenLaptopLidClosed = "hibernate";
        inhibitLidActionWhenExternalMonitorConnected = false; # do same action regardless of monitor

        whenSleepingEnter = "standbyThenHibernate";
      };

      battery = AC // {
        # autoSuspend.idleTimeout = 120;
        inhibitLidActionWhenExternalMonitorConnected = false;
        powerProfile = "powerSaving";
      };

      lowBattery = battery // {
        displayBrightness = 10;
      };
    };

    ###############################
    # Window Behaviour
    ###############################
    windows.allowWindowsToRememberPositions = false; # false since running tiling script
    workspace.clickItemTo = "select";

    kwin = {
      cornerBarrier = true;
      edgeBarrier = 20; # add some resistance to crossing screens
    };
    configFile.kwinrc.Windows = {
      AutoRaise = true;
      Placement = "smart";
      SeparateScreenFocus = true;
    };

    configFile.kwinrc."Script-krohnkite" = {
      "debug" = true;
      "debugActiveWin" = true;
      "enableColumnsLayout" = false;
      "enableSpiralLayout" = false;
      "enableSpreadLayout" = false;
      "enableStairLayout" = false;
      "enableThreeColumnLayout" = false;
      "floatingTitle" = "Picture-in-Picture";
      "ignoreClass" = null;
      "ignoreRole" = null;
      "ignoreTitle" = builtins.concatStringsSep "," [
        "OneDriveGUI v1.1.1"
        "Progress"
      ];
      "maximizeSoleTile" = true;
      "monocleMaximize" = false;
      "newWindowPosition" = 1;
      "preventProtrusion" = false;
      "tileLayoutGap" = 3;
    };

    window-rules = [
      {
        description = "Firefox Picture-in-Picture";
        match.title = {
          type = "exact";
          value = "Picture-in-Picture";
        };
        match.window-class = {
          match-whole = false; # unsure if this matters
          type = "substring";
          value = "firefox";
        };
        apply = {
          above = {
            apply = "initially";
            value = true;
          };
          position = {
            apply = "initially";
            value = "770,530";
          };
        };
      }
      {
        description = "No minimum window size";
        match.window-types = [ "normal" ];
        apply = {
          minsizerule.value = 2;
        };
      }
      {
        description = "Force title bar";
        match.window-types = [ "normal" ];
        apply.noborderrule.value = 2;
      }
    ];

    ###################################
    #          Program Configs
    ###################################

    configFile."spectaclerc" = {
      General = {
        autoSaveImage = true;
        clipboardGroup = "PostScreenshotCopyImage";
        launchAction = "DoNotTakeScreenshot";
        rememberSelectionRect = "always";
      };
      GuiConfig = {
        captureMode = 0;
      };

      ImageSave = {
        imageCompressionQuality = 100;
        translatedScreenshotsFoldre = "Screenshots";
      };

      VideoSave = {
        translatedScreencastsFolder = "Screencasts";
      };
    };
  };

  # colour scheme file
  # NOTE: setting colors:view:backgroundAlternate to the same as backgroundNormal gets ride of dolphin stripes
  xdg.dataFile."color-schemes/custom.colors".text = with colours.rgb255-commasep; ''
    [ColorEffects:Disabled]
    Color=${dark-grey}
    ColorAmount=0.375
    ColorEffect=3
    ContrastAmount=0.35
    ContrastEffect=0
    IntensityAmount=0.1
    IntensityEffect=0

    [ColorEffects:Inactive]
    ChangeSelectionColor=false
    Color=${dark-grey}
    ColorAmount=0.025
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${blue-grey}
    DecorationFocus=${light-blue}
    DecorationHover=${sky}
    ForegroundActive=${cyan}
    ForegroundInactive=${light-grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${yellow}
    ForegroundNormal=${ivory}
    ForegroundPositive=${lime}
    ForegroundVisited=${purple}

    [Colors:Complementary]
    BackgroundAlternate=${navy}
    BackgroundNormal=${dark-blue}
    DecorationFocus=${light-blue}
    DecorationHover=${sky}
    ForegroundActive=${cyan}
    ForegroundInactive=${light-grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${yellow}
    ForegroundNormal=${ivory}
    ForegroundPositive=${lime}
    ForegroundVisited=${purple}

    [Colors:Header]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${navy}
    DecorationFocus=${light-blue}
    DecorationHover=${sky}
    ForegroundActive=${cyan}
    ForegroundInactive=${light-grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${yellow}
    ForegroundNormal=${ivory}
    ForegroundPositive=${lime}
    ForegroundVisited=${purple}

    [Colors:Header][Inactive]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${navy}
    DecorationFocus=${light-blue}
    DecorationHover=${sky}
    ForegroundActive=${cyan}
    ForegroundInactive=${light-grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${yellow}
    ForegroundNormal=${ivory}
    ForegroundPositive=${lime}
    ForegroundVisited=${purple}

    [Colors:Selection]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${blue-grey}
    DecorationFocus=${light-blue}
    DecorationHover=${sky}
    ForegroundActive=${cyan}
    ForegroundInactive=${light-grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${yellow}
    ForegroundNormal=${ivory}
    ForegroundPositive=${lime}
    ForegroundVisited=${purple}

    [Colors:Tooltip]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${indigo}
    DecorationFocus=${light-blue}
    DecorationHover=${sky}
    ForegroundActive=${cyan}
    ForegroundInactive=${light-grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${yellow}
    ForegroundNormal=${ivory}
    ForegroundPositive=${lime}
    ForegroundVisited=${purple}

    [Colors:View]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${navy}
    DecorationFocus=${light-blue}
    DecorationHover=${sky}
    ForegroundActive=${cyan}
    ForegroundInactive=${light-grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${yellow}
    ForegroundNormal=${ivory}
    ForegroundPositive=${lime}
    ForegroundVisited=${purple}

    [Colors:Window]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${dark-blue},20
    DecorationFocus=${light-blue}
    DecorationHover=${sky}
    ForegroundActive=${cyan}
    ForegroundInactive=${light-grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${yellow}
    ForegroundNormal=${ivory}
    ForegroundPositive=${lime}
    ForegroundVisited=${purple}

    [General]
    ColorScheme=Custom
    Name=Custom
    shadeSortColumn=true
    TitlebarIsAccentColored=false

    [KDE]
    contrast=4

    [WM]
    activeBackground=${dark-grey}
    activeBlend=252,252,252
    activeForeground=252,252,252
    inactiveBackground=42,46,50
    inactiveBlend=161,169,177
    inactiveForeground=161,169,177
  '';

  xdg.configFile."klassy/klassyrc".text = ''
    [ButtonColors]
    ButtonBackgroundOpacityActive=70
    ButtonBackgroundOpacityInactive=70
    CloseButtonIconColorActive=AsSelected
    CloseButtonIconColorInactive=AsSelected

    [ShadowStyle]
    ShadowSize=ShadowNone

    [TitleBarOpacity]
    ActiveTitleBarOpacity=40
    BlurTransparentTitleBars=false
    InactiveTitleBarOpacity=40
    OpaqueMaximizedTitleBars=false

    [TitleBarSpacing]
    TitleBarLeftMargin=3
    TitleBarRightMargin=3

    [Windeco]
    BoldButtonIcons=BoldIconsFine
    ButtonIconStyle=StyleOxygen
    ButtonShape=ShapeSmallCircle
    ColorizeThinWindowOutlineWithButton=false
    DrawBackgroundGradient=true
    DrawBorderOnMaximizedWindows=true
    IconSize=IconMedium
    WindowCornerRadius=0

    [WindowOutlineStyle]
    ThinWindowOutlineStyleInactive=WindowOutlineNone
    ThinWindowOutlineThickness=2.5
    WindowOutlineAccentColorOpacityActive=80
  '';

  xdg.configFile."dolphinrc_hm".text = ''
    [ContextMenu]
    ShowDuplicateHere=false
    ShowMoveToOtherSplitView=false
    ShowViewMode=false

    [DetailsMode]
    PreviewSize=22
    SidePadding=0

    [General]
    BrowseThroughArchives=true
    CloseActiveSplitView=false
    ConfirmClosingMultipleTabs=false
    DoubleClickViewAction=none
    EditableUrl=false
    OpenExternallyCalledFolderInNewTab=true
    OpenNewTabAfterLastTab=true
    ShowStatusBar=false
    Version=202
    ViewPropsTimestamp=2025,5,24,14,40,0.739

    [InformationPanel]
    previewsShown=false
    showHovered=false

    [KFileDialog Settings]
    Places Icons Auto-resize=false
    Places Icons Static Size=22

    [MainWindow]
    MenuBar=Disabled
    ToolBarsMovable=Disabled

    [PreviewSettings]
    Plugins=cursorthumbnail,djvuthumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,ffmpegthumbs
  '';

  xdg.configFile."kiorc".text = ''
    [Confirmations]
    ConfirmDelete=true
    ConfirmEmptyTrash=true
    ConfirmTrash=false

    [Executable scripts]
    behaviourOnLaunch=alwaysAsk
  '';

  xdg.configFile."klaunchrc".text = ''
    [BusyCursorSettings]
    Bouncing=false

    [FeedbackStyle]
    BusyCursor=false
    TaskbarButton=false
  '';

  # removed due to not wanting it
  # xdg.configFile."ksplashrc".text = ''
  #   [KSplash]
  #   Theme=Magna-Splash-6
  # ''

  xdg.configFile."ktrashrc".text = ''
    [${config.common.dataHome}/Trash]
    Days=7
    LimitReachedAction=0
    Percent=10
    UseSizeLimit=true
    UseTimeLimit=false
  '';

  xdg.configFile."darklyrc".text = ''
    [Common]
    ButtonSize=2
    CornerRadius=1

    [Style]
    DolphinSidebarOpacity=20
    MenuBarOpacity=20
    MenuItemDrawStrongFocus=false
    MenuOpacity=30
    MnemonicsMode=MN_NEVER
    RoundedRubberBandFrame=false
    ScrollableMenu=false
    TabBarAltStyle=true
    TabDrawHighlight=true
    TabUseHighlightColor=true
    TransparentDolphinView=true
    UnifiedTabBarKonsole=true
    WidgetDrawShadow=false
    WindowDragMode=WD_MINIMAL
  '';

  xdg.desktopEntries."KDE Background Services" = {
    exec = "kcmshell6 kcm_kded";
    name = "KDE Background Services";
  };

  # kdeglobals [General] TerminalApplication=kitty

  # kdeglobals
  # kwinrc
  # kwinrulesrc
  # plasma-org.kde.plasma.desktop-appletsrc
}
