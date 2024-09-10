# https://github.com/shalva97/kde-configuration-files
# https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.kwin.borderlessMaximizedWindows
{config, pkgs, flake-inputs, app-themes, ...}:
let
  kde-colours = builtins.mapAttrs (name: value: flake-inputs.nix-colors.lib.conversions.hexToRGBString "," value) app-themes.palettes.kde;
in {
  imports = [
    flake-inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  # home.packages = [pkgs.libsForQt5.krohnkite];
  programs.plasma = {
    enable = true;
    resetFiles = []; # files to delete on each generation
    resetFilesExclude = []; # files to NOT delete on each generation
    immutableByDefault = false;
    overrideConfig = false; # read description before changing https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.overrideConfig

    # startup = {};

    workspace.lookAndFeel = "org.kde.breezedark.desktop"; # global theme
    workspace.colorScheme = "custom";
    # application style (settings) ??
    workspace.theme = "custom";  # plasma style / desktop theme
    workspace.windowDecorations = {
      library = "org.kde.kwin.aurorae";
      theme = "__aurorae__svg__custom";
    };
    workspace.iconTheme = "breeze-dark";# "Papirus-Dark"
    workspace.cursor = {
      theme = "Posy_Cursor_Black";
      size = 32;
    };
    workspace.splashScreen.theme = "none";

    input.keyboard.numlockOnStartup = "on";

    desktop.mouseActions = {
      leftClick = null;
      middleClick = "applicationLauncher";
      rightClick = "contextMenu";
      verticalScroll = "switchVirtualDesktop";
    };

    # desktop.widgets = {};
    # panels = [];

    fonts = rec {
      fixedWidth = {
        family = "";
        pointSize = general.pointSize;
      };
      general = {
        family = "Noto Sans";
        pointSize = 12;
        weight = "light";
      };
      small = general // {pointSize = 9;};
      menu = small;
      toolbar = small;
      windowTitle = small;
    };    

    hotkeys.commands = {
      tofi = {
        keys = ["Ctrl+Space"];
        command = "tofi-drun";
        comment = "Launch tofi in application mode.";
      };
    };

    # input.mice = {}; # https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.input.mice
    # input.touchpads = {}; # https://nix-community.github.io/plasma-manager/options.xhtml#opt-programs.plasma.input.touchpads

    kwin.borderlessMaximizedWindows = false;

    kwin.effects = {
      blur.enable = true;
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

    # kwin.scripts.polonium.enable = true;
    kwin.scripts.polonium.settings = {
      borderVisibility = "borderAll";
      filter.processes = ["tofi" "krunner" "kded" "polkit" "plasmashell"];
      filter.windowTitles = ["OneDriveGUI" "Picture-in-Picture"];
      layout = {
        engine = "binaryTree";
        insertionPoint = "activeWindow";
      };
      maximizeSingleWindow = true;
      resizeAmount = 100;
      saveOnTileEdit = true;
      tilePopups = false;
    };

    kwin.titlebarButtons = {
      left = [];
      right = ["minimize" "maximize" "close"];
    };

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

      battery = AC // {autoSuspend.idleTimeout = 120;};
      lowBattery = battery;

    };

    spectacle.shortcuts = {
      captureActiveWindow = [];
      captureCurrentMonitor = [];
      captureEntireDesktop =[];
      captureRectangularRegion = ["Print"];
      captureWindowUnderCursor = [];
      launch = [];
      launchWithoutCapturing = [];
      recordRegion = [];
      recordScreen = [];
      recordWindow = [];

    };

    windows.allowWindowsToRememberPositions = false; # false since running polonium

    workspace.clickItemTo = "select";

  };

# cursor and icons are under ~/.nix-profile/share/icons

xdg.dataFile."plasma/desktoptheme/custom".source = ./desktoptheme;

xdg.dataFile."aurorae/themes/custom/alldesktops.svg".source = ./auroraetheme/alldesktops.svg;
xdg.dataFile."aurorae/themes/custom/close.svg".source = ./auroraetheme/close.svg;
xdg.dataFile."aurorae/themes/custom/decoration.svg".source = ./auroraetheme/decoration.svg;
xdg.dataFile."aurorae/themes/custom/help.svg".source = ./auroraetheme/help.svg;
xdg.dataFile."aurorae/themes/custom/keepabove.svg".source = ./auroraetheme/keepabove.svg;
xdg.dataFile."aurorae/themes/custom/keepbelow.svg".source = ./auroraetheme/keepbelow.svg;
xdg.dataFile."aurorae/themes/custom/maximize.svg".source = ./auroraetheme/maximize.svg;
xdg.dataFile."aurorae/themes/custom/minimize.svg".source = ./auroraetheme/minimize.svg;
xdg.dataFile."aurorae/themes/custom/restore.svg".source = ./auroraetheme/restore.svg;
xdg.dataFile."aurorae/themes/custom/shade.svg".source = ./auroraetheme/shade.svg;
xdg.dataFile."aurorae/themes/custom/metadata.desktop".source = ./auroraetheme/metadata.desktop;

xdg.dataFile."aurorae/themes/custom/customrc".text = with kde-colours; ''
[General]
ActiveTextColor=${base0C}
InactiveTextColor=${base07}
UseTextShadow=false
Shadow=true
Animation=0
TitleAlignment=Center
TitleVerticalAlignment=Center
DecorationPosition=0

[Layout]
BorderBottom=4
BorderLeft=1
BorderRight=1
ButtonHeight=22
ButtonMarginTop=0
ButtonSpacing=2
ButtonWidth=22
ExplicitButtonSpacer=10
PaddingBottom=67
PaddingLeft=54
PaddingRight=54
PaddingTop=44
TitleBorderLeft=1
TitleBorderRight=1
TitleEdgeBottom=2
TitleEdgeBottomMaximized=2
TitleEdgeLeft=3
TitleEdgeLeftMaximized=3
TitleEdgeRight=3
TitleEdgeRightMaximized=3
TitleEdgeTop=3
TitleEdgeTopMaximized=3
TitleHeight=16
'';

xdg.dataFile."color-schemes/custom.colors".text = with kde-colours;
''
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
ColorAmount=0.30000000000000004
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
  
}
