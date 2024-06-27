{...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        expandFocusedSidePanel = true;
        expandedSidePanelWeight = 2;
        nerdFontsVersion = 3;
        commitAuthorFormat = "short";
      };
      promptToReturnFromSubprocess = false;
    };
  };
  home.shellAliases = {lg = "lazygit";};
}
