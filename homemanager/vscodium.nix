{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.vscodium-fhs];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions;
      [
        njpwerner.autodocstring
        vscodevim.vim
        ms-python.isort
        ms-python.python
        ms-toolsai.jupyter
        ms-pyright.pyright
        kamadorueda.alejandra
        jellyedwards.gitsweep
        gruntfuggly.todo-tree
        file-icons.file-icons
        ms-python.vscode-pylance
        mechatroner.rainbow-csv
        johnpapa.vscode-peacock
        james-yu.latex-workshop
        yzhang.markdown-all-in-one
        ms-vscode-remote.remote-ssh
        vscode-icons-team.vscode-icons
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-eslint";
          publisher = "dbaeumer";
          version = "2.1.14";
          sha256 = "113w2iis4zi4z3sqc3vd2apyrh52hbh2gvmxjr5yvjpmrsksclbd";
        }
      ];

    keybindings = builtins.fromJSON (builtins.readFile ./vscodium-keybindings.json);
    userSettings = builtins.fromJSON (builtins.readFile ./vscodium-settings.json);
  };
}
