{ config, pkgs, lib, ... }:
{
  # Configure git
  programs.git = {
    enable = true;
    userName = "armorynode";
    userEmail = "22787155+ArmoryNode@users.noreply.github.com";
    extraConfig = {
      user.name = "armorynode";
      user.email = "22787155+ArmoryNode@users.noreply.github.com";

      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
    };
  };
}