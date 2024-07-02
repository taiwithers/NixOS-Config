# TODO: add in additional configuration
{
  pkgs,
  ... # just pass in copyq package?
}:
{
  services.copyq = {
    enable = true;
    package = pkgs.copyq;
  };
}
