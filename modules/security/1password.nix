{ pkgs, ... }:
{
  # Allow 1Password to be unlocked by system authentication
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "armorynode" ];
  };

  # Allow 1Password browser extension to connect to desktop app
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        firefox
      '';
      mode = "0755";
    };
  };
}