# To use the remote-ssh plugin: on the remote machine run `ln -s ~/.vscodium-server/ ~/.vscode-server`
{
  config,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.vscode ];

  # workaround for remote-ssh wanting writable ssh config...
  home.activation.vscode-remote-ssh-config = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [[ -f ~/.ssh/codium-config ]]; then
        rm ~/.ssh/codium-config
    fi
    cp ~/.ssh/config ~/.ssh/codium-config
    chmod a+w ~/.ssh/codium-config # only necessary for removal
  '';
}
