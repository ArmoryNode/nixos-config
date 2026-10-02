{ pkgs, ... }: {
  # Install necessary packages
  home.packages = with pkgs; 
  [
    csharprepl
    fsautocomplete
    powershell
    (with dotnetCorePackages; combinePackages [
      sdk_8_0-bin
      sdk_9_0-bin
      sdk_10_0-bin
      sdk_11_0-bin
    ])
  ];

  home.file.".nuget/plugins/netcore/CredentialProvider.Microsoft".source =
    "${pkgs.azure-artifacts-credprovider}/lib/azure-artifacts-credprovider";
}
