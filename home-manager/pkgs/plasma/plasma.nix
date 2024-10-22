# https://github.com/shalva97/kde-configuration-files
# https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.kwin.borderlessMaximizedWindows

{
  config,
  pkgs,
  flake-inputs,
  app-themes,
  ...
}:
let
  kde-colours = builtins.mapAttrs (
    name: value: flake-inputs.nix-colors.lib.conversions.hexToRGBString "," value
  ) app-themes.palettes.kde;

  cursor = {
      name = "Posy_Cursor_Black";
      size = 32;
      package = pkgs.posy-cursors;
    };

  fonts = {
    sans = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
        size = 12;
        weight = "light";
      };
    };
  gtk-theme = {
    name = "Breeze-dark-gtk";
    package = pkgs.kdePackages.breeze;
    };

  klassy = {
      window-decorations = {
          theme = "Klassy";
          library = "org.kde.klassy";
        };
      icon-theme = "klassy";
    };
in
rec {
  imports = [
    flake-inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  home.packages = [pkgs.klassy pkgs.kara];

  gtk = rec {
    enable = true;
    gtk2.configLocation = "${config.common.configHome}/gtk-2.0/gtkrc";
    font = with fonts.sans; {
      name = name;
      package = package;
      size = size;
    };
    cursorTheme = cursor;
    theme = gtk-theme;

    # gtk2.extraConfig = with programs.plasma; ''
    #   gtk-button-images=1
    #   gtk-enable-animations=1
    #   gtk-icon-theme-name="${workspace.iconTheme}"
    #   gtk-menu-images=1
    #   gtk-primary-button-warps-slider=1
    #   gtk-sound-theme-name="${workspace.soundTheme}"
    #   gtk-toolbar-style=3
    # '';

    gtk3.extraConfig = {
      application-prefer-dark-theme = true;
      gtk-button-images = true;
      gtk-decoration-layout = ":minimize,maximize,close";
      gtk-enable-animations = true;
      gtk-icon-theme-name = programs.plasma.workspace.iconTheme;
      gtk-menu-images = true;
      gtk-modules = "colorreload-gtk-module";
      gtk-primary-button-warps-slider = true;
      gtk-sound-theme-name = programs.plasma.workspace.soundTheme;
      gtk-toolbar-style = 3;
    };

    gtk4.extraConfig = gtk3.extraConfig;
  };

  programs.plasma = {
    enable = false;
    resetFiles = [ "gtk-2.0/gtkrc" ]; # files to delete on each generation, string paths relative to config home
    resetFilesExclude = [ ]; # files to NOT delete on each generation
    immutableByDefault = false;
    overrideConfig = false; # read description before changing https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.overrideConfig

    ###############################
    # Environment Aesthetics
    ###############################
    workspace.lookAndFeel = "org.kde.breezedark.desktop"; # global theme
    workspace.colorScheme = "custom";
    workspace.wallpaper = let
      wallpaper-name = "Next"; # only one available in this kde package
      wallpaper-folder = "images_dark"; # or "images"
      in "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/${wallpaper-name}/contents/${wallpaper-folder}/1080x1920.png";
    configFile.kdeglobals.General.AccentColor = kde-colours.base0E; #"146,110,228";
    workspace.theme = "ActiveAccentDark"; # plasma style / desktop theme
    workspace.windowDecorations = klassy.window-decorations;
    workspace.iconTheme = klassy.icon-theme;
    workspace.cursor = {
      theme = cursor.name;
      size = cursor.size;
    };
    workspace.soundTheme = "ocean";
    workspace.splashScreen.theme = "Magna-Splash-6"; # engine is KSplashQML 
    configFile.kwinrc.Xwayland.Scale = 1.25;

    fonts = rec {
      fixedWidth = {
        family = "";
        pointSize = general.pointSize;
      };
      general = with fonts.sans; {
        family = name;
        pointSize = size;
        weight = weight;
      };
      small = general // {
        pointSize = 9;
      };
      menu = small;
      toolbar = small;
      windowTitle = small;
    };

    # panels = [
    #   # main screen top centre   
    #   {
    #      alignment = "center";
    #      extraSettings = ""; # https://develop.kde.org/docs/plasma/scripting/
    #      floating = true;
    #      height = 36;
    #      hiding = "dodgewindows";
    #      lengthMode = "fit";
    #      location = "top"; # or "floating"
    #      offset = 100; # ? from anchor
    #      screen = 0;
    #      widgets = ( map (x: "org.kde.plasma." + x) ["ginti" "digitalclock" "notifications"] ) ++ ["luisbocanegra.panel.colorizer"];
    #     }

    #   # main screen launcher
    #  {
    #      alignment = "center";
    #      extraSettings = ""; # https://develop.kde.org/docs/plasma/scripting/
    #      floating = true;
    #      height = 70;
    #      hiding = "dodgewindows";
    #      lengthMode = "fit";
    #      location = "bottom"; # or "floating"
    #      offset = 100; # ? from anchor
    #      screen = 0;
    #      widgets = ["Compact.Menu" "org.kde.plasma.icontasks" "luisbocanegra.panel.colorizer"];
    #     }

    #   # main screen system tray
    #   {
    #      alignment = "right";
    #      extraSettings = ""; # https://develop.kde.org/docs/plasma/scripting/
    #      floating = true;
    #      height = 36;
    #      hiding = "dodgewindows";
    #      lengthMode = "fit";
    #      location = "top"; # or "floating"
    #      offset = 100; # ? from anchor
    #      screen = 0;
    #      widgets = ( map (x: "org.kde.plasma." + x) ["systemtray" "shutdownorswitch"] ) ++ ["luisbocanegra.panel.colorizer"];
    #     }

    #   # additional screen bars
    #   {
    #      alignment = "center";
    #      extraSettings = ""; # https://develop.kde.org/docs/plasma/scripting/
    #      floating = true;
    #      height = 70;
    #      hiding = "dodgewindows";
    #      lengthMode = "fit";
    #      location = "bottom"; # or "floating"
    #      offset = 100; # ? from anchor
    #      screen = 1;
    #      widgets = ( map (x: "org.kde.plasma." + x) ["ginti" "digitalclock" "spacer" "icontasks" "spacer" "systemtray"] ) ++ ["luisbocanegra.panel.colorizer"];
    #     }
    # ];

    kscreenlocker = let
      wallpaper-name = "Next"; # only one available in this kde package
      wallpaper-folder = "images_dark"; # or "images"
      in 
      { 
      appearance = {
        alwaysShowClock = true;
        showMediaControls = true;
        wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/${wallpaper-name}/contents/${wallpaper-folder}/1080x1920.png";
        # wallpaperPictureOfTheDay.provider = "apod";
      };
      passwordRequiredDelay = 60; # seconds after screen lock 
      timeout = 5; # minutes until screen locks
    };

    ###############################
    # Keyboard and Mouse
    ###############################
    # input.mice = {}; # https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.input.mice
    # input.touchpads = {}; # https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.input.touchpads
    input.keyboard.numlockOnStartup = "on";
    desktop.mouseActions = {
      leftClick = null;
      middleClick = "applicationLauncher";
      rightClick = "contextMenu";
      verticalScroll = "switchVirtualDesktop";
    };

    # hotkeys to run commands
    hotkeys.commands = {
      launch-tofi = {
        keys = [ "Ctrl+Space" ];
        command = "tofi-drun";
        comment = "Launch tofi in application mode.";
      };
    };

    # Global keyboard shortcuts:
    shortcuts = {};

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
      blur.enable = true;
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
    powerdevil = rec {
      AC = {
        autoSuspend.action = "sleep";
        autoSuspend.idleTimeout = 300; # time to autoSuspend action
        dimDisplay.enable = false;
        powerButtonAction = "showLogoutScreen";
        turnOffDisplay.idleTimeout = null; # should let autoSuspend kick in instead
        turnOffDisplay.idleTimeoutWhenLocked = "whenLockedAndUnlocked"; # should let autoSuspend kick in instead
        whenLaptopLidClosed = "sleep";
      };

      battery = AC // { autoSuspend.idleTimeout = 120; };
      lowBattery = battery;
    };

    
    ###############################
    # Window Behaviour
    ###############################
    windows.allowWindowsToRememberPositions = false; # false since running tiling script
    workspace.clickItemTo = "select";
    kwin.edgeBarrier = 20; # add some resistance to crossing screens
    configFile.kwinrc.Windows = {
      AutoRaise = true;
      BorderlessMaximizedWindows = false;
      Placement = "smart";
      SeparateScreenFocus = true;
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
           } ;
        };
      }
    ];


  };

  # colour scheme file
  xdg.dataFile."color-schemes/custom.colors".text = with kde-colours; ''
    [ColorEffects:Disabled]
    Color=${base01}
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.55
    ContrastEffect=1
    IntensityAmount=0.1
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=${base03}
    ColorAmount=0.3
    ColorEffect=2
    ContrastAmount=0.25
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=${base01}
    BackgroundNormal=${base01}
    DecorationFocus=${base0C}
    DecorationHover=${base0C}
    ForegroundActive=${base0C}
    ForegroundInactive=${base0C}
    ForegroundLink=${base0D}
    ForegroundNegative=${base08}
    ForegroundNeutral=${base09}
    ForegroundNormal=${base06}
    ForegroundPositive=${base0B}
    ForegroundVisited=${base0E}

    [Colors:Complementary]
    BackgroundAlternate=${base01}
    BackgroundNormal=${base00}
    DecorationFocus=${base0C}
    DecorationHover=${base0C}
    ForegroundActive=${base0C}
    ForegroundInactive=${base0C}
    ForegroundLink=${base0D}
    ForegroundNegative=${base08}
    ForegroundNeutral=${base09}
    ForegroundNormal=${base06}
    ForegroundPositive=${base0B}
    ForegroundVisited=${base0E}

    [Colors:Header]
    BackgroundAlternate=${base00}
    BackgroundNormal=${base01}
    DecorationFocus=${base0C}
    DecorationHover=${base0C}
    ForegroundActive=${base0C}
    ForegroundInactive=${base0C}
    ForegroundLink=${base0D}
    ForegroundNegative=${base08}
    ForegroundNeutral=${base09}
    ForegroundNormal=${base06}
    ForegroundPositive=${base0B}
    ForegroundVisited=${base0E}

    [Colors:Header][Inactive]
    BackgroundAlternate=${base01}
    BackgroundNormal=${base00}
    DecorationFocus=${base0C}
    DecorationHover=${base0C}
    ForegroundActive=${base0C}
    ForegroundInactive=${base0C}
    ForegroundLink=${base0D}
    ForegroundNegative=${base08}
    ForegroundNeutral=${base09}
    ForegroundNormal=${base06}
    ForegroundPositive=${base0B}
    ForegroundVisited=${base0E}

    [Colors:Selection]
    BackgroundAlternate=${base01}
    BackgroundNormal=${base0D}
    DecorationFocus=${base0C}
    DecorationHover=${base0C}
    ForegroundActive=${base06}
    ForegroundInactive=${base0C}
    ForegroundLink=${base08}
    ForegroundNegative=${base08}
    ForegroundNeutral=${base0F}
    ForegroundNormal=${base06}
    ForegroundPositive=${base07}
    ForegroundVisited=${base01}

    [Colors:Tooltip]
    BackgroundAlternate=${base00}
    BackgroundNormal=${base01}
    DecorationFocus=${base0C}
    DecorationHover=${base0C}
    ForegroundActive=${base0C}
    ForegroundInactive=${base0C}
    ForegroundLink=${base0D}
    ForegroundNegative=${base08}
    ForegroundNeutral=${base09}
    ForegroundNormal=${base06}
    ForegroundPositive=${base0B}
    ForegroundVisited=${base0E}

    [Colors:View]
    BackgroundAlternate=${base01}
    BackgroundNormal=${base00}
    DecorationFocus=${base0C}
    DecorationHover=${base0C}
    ForegroundActive=${base0C}
    ForegroundInactive=${base0C}
    ForegroundLink=${base0D}
    ForegroundNegative=${base08}
    ForegroundNeutral=${base09}
    ForegroundNormal=${base06}
    ForegroundPositive=${base0B}
    ForegroundVisited=${base0E}

    [Colors:Window]
    BackgroundAlternate=${base01}
    BackgroundNormal=${base00}
    DecorationFocus=${base0C}
    DecorationHover=${base0C}
    ForegroundActive=${base0C}
    ForegroundInactive=${base0C}
    ForegroundLink=${base0D}
    ForegroundNegative=${base08}
    ForegroundNeutral=${base09}
    ForegroundNormal=${base06}
    ForegroundPositive=${base0B}
    ForegroundVisited=${base0E}

    [General]
    ColorScheme=Custom
    Name=Custom
    TitlebarIsAccentColored=false
    shadeSortColumn=true

    [KDE]
    contrast=4

    [WM]
    activeBackground=${base00}
    activeBlend=${base06}
    activeForeground=${base07}
    inactiveBackground=${base00}
    inactiveBlend=${base06}
    inactiveForeground=${base07}
  '';

  # xdg.configFile."plasma-org.kde.plasma.desktop-appletsrc".source = ./panels.txt;
}
