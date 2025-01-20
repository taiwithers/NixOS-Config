{ pkgs, ...}:{
	home.packages = with pkgs; [
      pdf2svg # for eps file preview
    ghostscript # pdf creation
    pdftk
    pandoc
	];
}