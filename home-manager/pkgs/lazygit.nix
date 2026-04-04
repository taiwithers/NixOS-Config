_: {
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        overrideGpg = true;
      };
      gui = {
        expandFocusedSidePanel = true;
        expandedSidePanelWeight = 2;
        nerdFontsVersion = 3;
        commitAuthorFormat = "short";
      };
      promptToReturnFromSubprocess = false;
      keybinding.universal = {
        quit = "Q";
        quitWithoutChangingDirectory = "q";
      };
    };
  };
}
