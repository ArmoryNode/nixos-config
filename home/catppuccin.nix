{ inputs, pkgs, lib, ... }:
let
  catppuccinFlavor = "macchiato";
  catppuccinAccent = "blue";
in
{
  imports = [ 
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = {
    flavor = catppuccinFlavor;
    accent = catppuccinAccent;
  };

  gtk = {
    enable = true;

    catppuccin = {
      enable = true;

      flavor = catppuccinFlavor;
      accent = catppuccinAccent;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/shell/extensions/user-theme" = {
      name = "catppuccin-${catppuccinFlavor}-${catppuccinAccent}-standard";
    };

    "org/gnome/desktop/interface" = {
      gtk-theme = "catppuccin-${catppuccinFlavor}-${catppuccinAccent}-standard";
    };
  };
}