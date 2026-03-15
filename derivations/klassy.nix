# modified from https://github.com/ShadowRZ/nur-packages/blob/b87f9a470a5856219fdcbfaab6c0931acc7f3b7a/pkgs/klassy-qt6/default.nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  # extra-cmake-modules,
  # kdecoration,
  # kcoreaddons,
  # kguiaddons,
  # kconfigwidgets,
  # kiconthemes,
  # kwindowsystem,
  # kwayland,
  # kirigami,
  # wrapQtAppsHook,
  # qtsvg,
  kdePackages,
# kcmutils,
# frameworkintegration,
}:
stdenv.mkDerivation rec {
  pname = "klassy";
  version = "v6.5";

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = pname;
    rev = version;
    sha256 = "sha256-zf+RO+GolA9Gnf1/izIG7jCSu8Qlo0d0kRc90llMRIc=";
  };

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DBUILD_QT5=OFF"
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
    kdecoration
    kcoreaddons
    kguiaddons
    kconfigwidgets
    kiconthemes
    kwayland
    kwindowsystem
    kirigami
    frameworkintegration
    kcmutils
    qtsvg
  ];

  meta = with lib; {
    description = "A highly customizable binary Window Decoration and Application Style plugin for recent versions of the KDE Plasma desktop";
    homepage = "https://github.com/paulmcauley/klassy";
    license = with licenses; [
      gpl2Only
      gpl2Plus
      gpl3Only
      bsd3
      mit
    ];
  };
}
