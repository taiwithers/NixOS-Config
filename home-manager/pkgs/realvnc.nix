{config, pkgs, ...}:{

    home.packages = [pkgs.realvnc-vnc-viewer];

    home.activation.update-realvnc = let 
      nix-prefetch-url = "${pkgs.nix}/bin/nix-prefetch-url";
      url = "https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.5.1-Linux-x64.rpm";
      in config.lib.dag.entryBefore ["writeBoundary"] ''
       ${nix-prefetch-url} --type sha256 ${url} 
    '';
  }
