{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    inputs.vscode-server.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
    extraBin = [
      { src = lib.getExe' pkgs.coreutils "dirname"; }
      { src = lib.getExe' pkgs.coreutils "readlink"; }
      { src = lib.getExe' pkgs.coreutils "uname"; }
    ];
  };

  # Enable the VSCode server
  services.vscode-server.enable = true;

  # Allow VSCode server to run
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    isNormalUser = true;
    description = "WSL";
    packages = with pkgs; [
      (with dotnetCorePackages; combinePackages [
        sdk_6_0
        sdk_7_0
        sdk_8_0
        sdk_9_0
      ])
      csharprepl
      git-credential-manager
      dart-sass
      git
      nodejs
      wget
    ];
  };

  # Configure Nushell to be the default shell
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "nu" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.nushell}/bin/nu $LOGIN_OPTION
      fi
    '';
  };

  # Configure home manager
  home-manager.users.nixos = import ./home.nix;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
