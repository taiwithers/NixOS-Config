{ pkgs, ...} :{
    programs.zellij = {
        enable = true;
        # settings = {};
        # attachExistingSession = true;
        enableBashIntegration = true;
      };
  }
