{
	stdenv,
  cmake,
  kdePackages,
	fetchFromGitHub,
	lib,
}:
stdenv.mkDerivation rec {
	pname = "plasma-panel-spacer-extended";
	version = "1074478";

	src = fetchFromGitHub {
		owner = "luisbocanegra";
		repo = pname;
		rev = version;
		hash = "sha256-wZx4OIYdZX7sDhHHamExScSY7Q0PVifcvLiazXpY+zA=";
	};

	nativeBuildInputs = [
		cmake
		kdePackages.extra-cmake-modules
		kdePackages.wrapQtAppsHook
		kdePackages.plasma-desktop
	];

  cmakeFlags = [
      (lib.cmakeFeature "Qt6_DIR" "${kdePackages.qtbase}/lib/cmake/Qt6")
  ];

}