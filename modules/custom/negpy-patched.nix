{ stdenv, fetchzip, autoPatchelfHook, negpy }: let
  negpyPkgs = negpy.inputs.nixpkgs.legacyPackages.${stdenv.hostPlatform.system};
  negpyWgpuNative = stdenv.mkDerivation {
    pname = "negpy-wgpu-native";
    version = "29.0.1.1";
    src = fetchzip {
      url = "https://github.com/gfx-rs/wgpu-native/releases/download/v29.0.1.1/wgpu-linux-x86_64-release.zip";
      hash = "sha256-/EJ6yy1PETqcny5d2ZM2ZJ5VgVTDvqGaSSmIvqamcwM=";
      stripRoot = false;
    };
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib ];
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      install -Dm755 lib/libwgpu_native.so $out/lib/libwgpu_native.so
      runHook postInstall
    '';
  };
in negpy.packages.${stdenv.hostPlatform.system}.default.overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ negpyPkgs.wrapGAppsHook3 ];
  buildInputs = (old.buildInputs or []) ++ [ negpyPkgs.gtk3 ];
  postFixup = (old.postFixup or "") + ''
    wrapProgram $out/bin/negpy \
      --set WGPU_LIB_PATH ${negpyWgpuNative}/lib/libwgpu_native.so
  '';
})