{ pkgs, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = false;
      trucolor = true;
      vim_keys = true;
      update_ms = 1000;
    };
  };
}
