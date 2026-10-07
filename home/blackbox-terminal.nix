{ lib, pkgs, ... }: {
  home.packages = [
    pkgs.blackbox-terminal
  ];

  dconf.settings."com/raggesilver/BlackBox" = {
    remember-window-size = true;
    window-height = lib.gvariant.mkUint32 520;
    window-width = lib.gvariant.mkUint32 820;
    terminal-padding = lib.gvariant.mkTuple [
      (lib.gvariant.mkUint32 8)
      (lib.gvariant.mkUint32 8)
      (lib.gvariant.mkUint32 8)
      (lib.gvariant.mkUint32 8)
    ];
  };
}