# TODO: add in additional configuration
{
  unstable-pkgs,
  ... # just pass in copyq package?
}: {
  services.copyq = {
    enable = true;
    package = unstable-pkgs.copyq;
  };
}
