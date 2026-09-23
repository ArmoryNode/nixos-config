{ stdenvNoCC, src }: stdenvNoCC.mkDerivation {
  pname = "conflux-icon-theme";
  version = "unstable";
  inherit src;

  installPhase = ''
    mkdir -p $out/share/icons
    mkdir $out/share/icons/Conflux
    cp -a index.theme apps devices emblems mimes places preferences status \
      $out/share/icons/Conflux
    find $out/share/icons/Conflux -xtype l -delete
  '';
}