{ config, pkgs, ... }:
{
  xdg.configFile."${config.xdg.configHome}/tabler-icons/".source = pkgs.fetchFromGitHub {
    owner = "tabler";
    repo = "tabler-icons";
    rev = "e1d8b8e";
    hash = "sha256-sL6Z8MIS9/SOwceHGia5F/O9JLKomd/agpm/T+lKD/o=";
    sparseCheckout = [ "icons/" ];
  };
}
