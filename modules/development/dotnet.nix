{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    csharprepl
    fsautocomplete
    powershell
    (with dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_7_0
      sdk_8_0
      sdk_9_0
    ])
  ];
}