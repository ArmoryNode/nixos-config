{ pkgs, ... }:
{
  # Configure git
  programs.git = {
    enable = true;
    settings = {
      user.name = "armorynode";
      user.email = "22787155+ArmoryNode@users.noreply.github.com";

      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
    };
  };
}