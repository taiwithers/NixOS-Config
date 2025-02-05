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
in
rec {
  imports = [
    plasma-manager.homeManagerModules.plasma-manager
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
    # (builtins.fetchGit "https://github.com/Davide-sd/shutdown_or_switch.git") + "/package";
    + "/package";

  xdg.dataFile."plasma/look-and-feel/Magna-Splash-6".source =
    (pkgs.fetchFromGitHub {
      owner = "L4ki";
      repo = "Magna-Plasma-Themes";
      rev = "cff6c2d";
      hash = "sha256-yYQBtjDOWiu33fVvnv83At0nA5mOmYZldgV4VsMxd2M=";
      sparseCheckout = [ "Magna-Splahscreen" ];
    })
    # (builtins.fetchGit "https://github.com/L4ki/Magna-Plasma-Themes.git")
    + "/Magna-Splash-6";

  xdg.dataFile."plasma/plasmoids/Compact.Menu".source = ./Compact.Menu;

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
  xdg.configFile."gtk-4.0/window_decorations.css".source =
    "${pkgs.kde-gtk-config}/share/themes/Breeze/window_decorations.css";
  xdg.configFile."gtk-3.0/window_decorations.css".source =
    "${pkgs.kde-gtk-config}/share/themes/Breeze/window_decorations.css";

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
    enable = false;
    resetFiles = [ ]; # files to delete on each generation, string paths relative to config home
    resetFilesExclude = [ ]; # files to NOT delete on each generation
    immutableByDefault = false;
    overrideConfig = false; # read description before changing https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.overrideConfig

    ###############################
    # Environment Aesthetics
    ###############################
    workspace.lookAndFeel = "org.kde.breezedark.desktop"; # global theme
    workspace.colorScheme = "custom";
    workspace.wallpaper =
      let
        wallpaper-name = "Next"; # only one available in this kde package
        wallpaper-folder = "images_dark"; # or "images"
      in
      "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/${wallpaper-name}/contents/${wallpaper-folder}/1080x1920.png";
    configFile.kdeglobals.General.AccentColor = colours.rgb255-commasep.blue-grey; # "146,110,228";
    workspace.theme = "ActiveAccentDark"; # plasma style / desktop theme
    workspace.windowDecorations = klassy-names.window-decorations;
    workspace.iconTheme = klassy-names.icon-theme;
    workspace.cursor = {
      theme = cursor.name;
      inherit (cursor) size;
    };
    workspace.soundTheme = "ocean";
    workspace.splashScreen.theme = "Magna-Splash-6"; # engine is KSplashQML
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

    kscreenlocker =
      let
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
    shortcuts = { };

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

      battery = AC // {
        autoSuspend.idleTimeout = 120;
      };
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
          };
        };
      }
    ];
  };

  # colour scheme file
  # NOTE: setting colors:view:backgroundAlternate to the same as backgroundNormal gets ride of dolphin stripes
  xdg.dataFile."color-schemes/custom.colors".text = with colours.rgb255-commasep; ''
    [ColorEffects:Disabled]
    Color=${dark-grey}
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.55
    ContrastEffect=1
    IntensityAmount=0.1
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=${dark-grey}
    ColorAmount=0.3
    ColorEffect=2
    ContrastAmount=0.25
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${navy}
    DecorationFocus=${cyan}
    DecorationHover=${cyan}
    ForegroundActive=${ivory}
    ForegroundInactive=${grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${peach}
    ForegroundNormal=${ivory}
    ForegroundPositive=${green}
    ForegroundVisited=${purple}

    [Colors:Complementary]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${navy}
    DecorationFocus=${cyan}
    DecorationHover=${cyan}
    ForegroundActive=${ivory}
    ForegroundInactive=${grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${peach}
    ForegroundNormal=${ivory}
    ForegroundPositive=${green}
    ForegroundVisited=${purple}

    [Colors:Header]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${navy}
    DecorationFocus=${cyan}
    DecorationHover=${cyan}
    ForegroundActive=${ivory}
    ForegroundInactive=${grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${peach}
    ForegroundNormal=${ivory}
    ForegroundPositive=${green}
    ForegroundVisited=${purple}

    [Colors:Header][Inactive]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${navy}
    DecorationFocus=${cyan}
    DecorationHover=${cyan}
    ForegroundActive=${ivory}
    ForegroundInactive=${grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${peach}
    ForegroundNormal=${ivory}
    ForegroundPositive=${green}
    ForegroundVisited=${purple}

    [Colors:Selection]
    BackgroundAlternate=${blue-grey}
    BackgroundNormal=${light-grey}
    DecorationFocus=${cyan}
    DecorationHover=${cyan}
    ForegroundActive=${navy}
    ForegroundInactive=${dark-grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${peach}
    ForegroundNormal=${ivory}
    ForegroundPositive=${green}
    ForegroundVisited=${purple}

    [Colors:Tooltip]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${navy}
    DecorationFocus=${cyan}
    DecorationHover=${cyan}
    ForegroundActive=${ivory}
    ForegroundInactive=${grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${peach}
    ForegroundNormal=${ivory}
    ForegroundPositive=${green}
    ForegroundVisited=${purple}

    [Colors:View]
    BackgroundAlternate=${navy}
    BackgroundNormal=${navy}
    DecorationFocus=${cyan}
    DecorationHover=${cyan}
    ForegroundActive=${ivory}
    ForegroundInactive=${grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${peach}
    ForegroundNormal=${ivory}
    ForegroundPositive=${green}
    ForegroundVisited=${purple}

    [Colors:Window]
    BackgroundAlternate=${dark-blue}
    BackgroundNormal=${navy}
    DecorationFocus=${cyan}
    DecorationHover=${cyan}
    ForegroundActive=${ivory}
    ForegroundInactive=${grey}
    ForegroundLink=${light-blue}
    ForegroundNegative=${red}
    ForegroundNeutral=${peach}
    ForegroundNormal=${ivory}
    ForegroundPositive=${green}
    ForegroundVisited=${purple}

    [General]
    ColorScheme=Custom
    Name=Custom
    TitlebarIsAccentColored=false
    shadeSortColumn=false

    [KDE]
    contrast=4

    [WM]
    activeBackground=${navy},150
    activeBlend=${blue-grey}
    activeForeground=${ivory}
    inactiveBackground=${dark-grey},150
    inactiveBlend=${blue-grey}
    inactiveForeground=${ivory}
  '';

  xdg.configFile."klassy/klassyrc".text = ''
    [ButtonColors]
    ButtonBackgroundOpacityActive=40
    ButtonBackgroundOpacityInactive=40
    ButtonIconOpacityActive=80
    ButtonIconOpacityInactive=80

    [Global]
    LookAndFeelSet=org.kde.breezedark.desktop

    [Style]
    DockWidgetDrawFrame=true
    FrameCornerRadius=FCR_Custom
    MenuItemDrawStrongFocus=false
    MenuOpacity=70
    MnemonicsMode=MN_NEVER
    ScrollBarAddLineButtons=0
    ScrollBarSubLineButtons=0
    SidePanelDrawFrame=true
    SplitterProxyEnabled=true
    WindowDragMode=WD_NONE

    [TitleBarOpacity]
    ActiveTitleBarOpacity=80
    InactiveTitleBarOpacity=80
    OpaqueMaximizedTitleBars=false

    [TitleBarSpacing]
    TitleBarLeftMargin=3
    TitleBarRightMargin=3

    [Windeco]
    BoldButtonIcons=BoldIconsFine
    ButtonIconStyle=StyleOxygen
    ButtonShape=ShapeSmallCircle
    ColorizeThinWindowOutlineWithButton=false
    CornerRadius=0
    DrawBackgroundGradient=true
    DrawBorderOnMaximizedWindows=true
    DrawTitleBarSeparator=true
    IconSize=IconMedium
    WindowCornerRadius=0

    [WindowOutlineStyle]
    ThinWindowOutlineStyleInactive=WindowOutlineNone
    ThinWindowOutlineThickness=2.4999999999999982
    WindowOutlineAccentColorOpacityActive=50
  '';

  xdg.configFile."dolphinrc".text = ''
    MenuBar=Disabled

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
    DoubleClickViewAction=none
    OpenExternallyCalledFolderInNewTab=true
    OpenNewTabAfterLastTab=true
    ShowStatusBar=false
    Version=202
    ViewPropsTimestamp=2024,11,30,17,35,37.881

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

  xdg.configFile."kcminputrc".text = ''
    [Keyboard]
    NumLock=0

    [Libinput][1267][12572][VEN_04F3:00 04F3:311C Touchpad]
    NaturalScroll=true

    [Mouse]
    cursorSize=32
    cursorTheme=Posy_Cursor_Black
  '';

  xdg.configFile."kglobalshortcutsrc".source = ./kglobalshortcutsrc;

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

  xdg.configFile."kscreenlockerrc".text = ''
    [Daemon]
    LockGrace=300

    [Greeter][Wallpaper][org.kde.image][General]
    Image=/home/tai/Nix/NixOS/main/background.png
    PreviewImage=/home/tai/Nix/NixOS/main/background.png
  '';

  xdg.configFile."ksplashrc".text = ''
    [KSplash]
    Theme=Magna-Splash-6
  '';

  xdg.configFile."powerdevilrc".text = ''
    [AC][SuspendAndShutdown]
    InhibitLidActionWhenExternalMonitorPresent=false

    [Battery][Performance]
    PowerProfile=power-saver

    [Battery][SuspendAndShutdown]
    InhibitLidActionWhenExternalMonitorPresent=false

    [LowBattery][Display]
    DisplayBrightness=10

    [LowBattery][Performance]
    PowerProfile=power-saver

    [LowBattery][SuspendAndShutdown]
    InhibitLidActionWhenExternalMonitorPresent=false
  '';

  xdg.configFile."spectaclerc".text = ''
    [General]
    autoSaveImage=true
    clipboardGroup=PostScreenshotCopyImage
    rememberSelectionRect=Always

    [GuiConfig]
    captureMode=0
    selectionRect=252,314,1034,553

    [ImageSave]
    imageCompressionQuality=100
    lastImageSaveLocation=file:///home/tai/Pictures/Screenshots/Screenshot_20241204_100725.png
    translatedScreenshotsFolder=Screenshots

    [VideoSave]
    translatedScreencastsFolder=Screencasts
  '';

  xdg.configFile."kded5rc".text = ''
    [Module-appmenu]
    autoload=true

    [Module-audioshortcutsservice]
    autoload=true

    [Module-baloosearchmodule]
    autoload=true

    [Module-bluedevil]
    autoload=true

    [Module-browserintegrationreminder]
    autoload=false

    [Module-colorcorrectlocationupdater]
    autoload=false

    [Module-device_automounter]
    autoload=false

    [Module-devicenotifications]
    autoload=true

    [Module-donationmessage]
    autoload=false

    [Module-freespacenotifier]
    autoload=true

    [Module-gtkconfig]
    autoload=false

    [Module-inotify]
    autoload=true

    [Module-kameleon]
    autoload=false

    [Module-kded_bolt]
    autoload=true

    [Module-kded_touchpad]
    autoload=true

    [Module-keyboard]
    autoload=false

    [Module-kscreen]
    autoload=true

    [Module-ktimezoned]
    autoload=true

    [Module-mprisservice]
    autoload=true

    [Module-networkmanagement]
    autoload=true

    [Module-plasma-session-shortcuts]
    autoload=true

    [Module-plasma_accentcolor_service]
    autoload=true

    [Module-printmanager]
    autoload=true

    [Module-remotenotifier]
    autoload=true

    [Module-smbwatcher]
    autoload=true

    [Module-statusnotifierwatcher]
    autoload=true
  '';

  xdg.desktopEntries."KDE Background Services" = {
    exec = "kcmshell6 kcm_kded";
    name = "KDE Background Services";
  };
  # kdeglobals
  # kwinrc
  # kwinrulesrc
  # plasma-org.kde.plasma.desktop-appletsrc
}
