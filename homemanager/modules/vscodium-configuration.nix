# To use the remote-ssh plugin: on the remote machine run `ln -s ~/.vscodium-server/ ~/.vscode-server`
{
  pkgs,
  lib,
  ...
}: let
in {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode-extension-MS-python-vscode-pylance"
      "vscode-extension-ms-vscode-remote-remote-ssh"
    ];

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
        # tomoki1207-pdf
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        # additional extensions that aren't in nixpkgs
        # follow instructions here: https://matthewrhone.dev/nixos-vscode
        # install extensions manually through codium
        # run the script: https://github.com/NixOS/nixpkgs/blob/42d815d1026e57f7e6f178de5a280c14f7aba1a5/pkgs/misc/vscode-extensions/update_installed_exts.sh
        # paste outputs for any extensions that aren't above into this area
        {
          name = "moegi-theme";
          publisher = "ddiu8081";
          version = "0.7.1";
          sha256 = "0s9rymrif1dq7py1mr5fhlz53sa6xr57ssia88l0lq39dq02j845";
        }
        {
          name = "vscode-powertools";
          publisher = "egomobile";
          version = "0.67.4";
          sha256 = "0wl86x8rq6dssjcj74b9xr2bpjicdaciva24kvckqpfmxmslylz7";
        }
        {
          name = "path-autocomplete";
          publisher = "ionutvmi";
          version = "1.25.0";
          sha256 = "0jjqh3p456p1aafw1gl6xgxw4cqqzs3hssr74mdsmh77bjizcgcb";
        }
        {
          name = "fix-all-json";
          publisher = "zardoy";
          version = "0.1.5";
          sha256 = "0jpdwy18yzm7apnazbwg0112rnilzrv8666fk5afkjqgsp0pjjly";
        }
        {
          name = "base16-generator";
          publisher = "golf1052";
          version = "1.19.1";
          sha256 = "0g5lcy064zm88wcik2n6c7i5g50rk0zbz722l65lzv8wggnr2gqk";
        }
      ];

    keybindings = builtins.fromJSON (builtins.readFile ../non-nix/vscodium-keybindings.json);
    userSettings = builtins.fromJSON (builtins.readFile ../non-nix/vscodium-settings.json);
  };
}
