{ stdenvNoCC, src }: stdenvNoCC.mkDerivation {
  pname = "adwair-icon-theme";
  version = "unstable";
  inherit src;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    bash install.sh --path "$out/share/icons"
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    for theme in Adwair Adwair-dark; do
      test -f "$out/share/icons/$theme/index.theme"
      test -d "$out/share/icons/$theme/apps/scalable"
    done
    runHook postInstallCheck
  '';
}