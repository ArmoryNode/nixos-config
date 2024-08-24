{ pkgs, ... }:
{
  # Configure VSCode
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ionide.ionide-fsharp
      visualstudioexptteam.vscodeintellicode
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
      github.copilot
    ];

    userSettings = {
      "terminal.integrated.fontFamily" = "'JetBrainsMono NF'";
      "editor.fontLigatures" = "true";
      "editor.fontFamily" = "'JetBrainsMono NF'";
    };
  };
}