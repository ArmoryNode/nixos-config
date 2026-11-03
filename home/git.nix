{ pkgs, ... }: let
  gitCredentialLibsecret = pkgs.stdenv.mkDerivation {
    pname = "git-credential-libsecret";
    inherit (pkgs.git) version src;

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.libsecret ];

    buildPhase = ''
      runHook preBuild
      make -C contrib/credential/libsecret
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 contrib/credential/libsecret/git-credential-libsecret \
        "$out/bin/git-credential-libsecret"
      runHook postInstall
    '';
  };
in {
  # Configure git
  programs.git = {
    enable = true;
    settings = {
      user.name = "armorynode";
      user.email = "22787155+ArmoryNode@users.noreply.github.com";

      credential.helper = "${gitCredentialLibsecret}/bin/git-credential-libsecret";
    };
  };
}