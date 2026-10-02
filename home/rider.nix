{ pkgs, inputs, ... }: let
  plugins = inputs.nix-jetbrains-plugins.lib.pluginsForIde
    pkgs pkgs.jetbrains.rider [ "com.github.copilot" ];
  copilot = plugins."com.github.copilot".overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      install -m644 ${pkgs.writeText "copilot-sdk-package.json" (builtins.toJSON {
        type = "module";
      })} "$out/copilot-agent/dist/node_modules/@github/copilot/sdk/package.json"
    '';
  });
in {
  home.packages = [
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.rider [ copilot ])
  ];
}