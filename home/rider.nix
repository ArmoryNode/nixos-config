{ pkgs, inputs, ... }:
let
  copilotPlugins = inputs.nix-jetbrains-plugins.lib.pluginsForIdeWith {
    applyPluginOverrides = true;
  } pkgs pkgs.jetbrains.rider [ "com.github.copilot" ];
in {
  home.packages = with pkgs; [
    (jetbrains.plugins.addPlugins jetbrains.rider (lib.attrValues copilotPlugins))
  ];
}