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
        shrinkSidePanelsToContent = true;
      };
      promptToReturnFromSubprocess = false;
      keybinding.universal = {
        quit = "Q";
        quitWithoutChangingDirectory = "q";
        # set the "open" command to the same as "edit"
        # stops files from opening in vscode on wsl
        edit = [
          "e"
          "o"
        ];
        openFile = "<disabled>";
      };
      customCommands = [
        {
          key = "M";
          command = "git mergetool {{ .SelectedFile.Name }}";
          context = "files";
          loadingText = "opening git mergetool";
          output = "terminal";
        }
      ];
    };
  };
}
