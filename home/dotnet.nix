{ pkgs, config, lib, ... }:
let
  artifacts-credprovider = pkgs.stdenv.mkDerivation {
    name = "artifacts-credprovider";
    src = pkgs.fetchurl {
      url = "https://aka.ms/install-artifacts-credprovider.sh";
      sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
    };
    buildInputs = [ 
      pkgs.bash
      pkgs.curl
      pkgs.gnutar
      pkgs.gzip
    ];
  };
in
{
  # Install necessary packages
  home.packages = with pkgs; 
  [
    csharprepl
    fsautocomplete
    powershell
    (with dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_7_0
      sdk_8_0
    ])
  ];

  # Run the artifacts-credprovider installer script
  home.activation.artifacts-credprovider = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export HOME=${config.home.homeDirectory}
    ${pkgs.writeShellScriptBin "install-artifacts-credprovider" ''
      wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash
    ''}/bin/install-artifacts-credprovider
  '';
}
