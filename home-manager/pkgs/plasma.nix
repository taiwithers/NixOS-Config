# https://github.com/shalva97/kde-configuration-files
{config, pkgs, flake-inputs, ...}:{
    imports = [
      flake-inputs.plasma-manager.homeManagerModules.plasma-manager
    ];
   
   programs.plasma = {
       enable = true;
       input.keyboard.numlockOnStartup = "on";
       workspace.cursor.theme = "Posy_Cursor";
       workspace.lookAndFeel = "org.kde.breezedark.desktop";
       workspace.theme = "breeze-dark"; 
     };
    
  }
