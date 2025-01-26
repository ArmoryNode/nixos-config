{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      github.copilot 
      ionide.ionide-fsharp
      visualstudioexptteam.vscodeintellicode
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      brettm12345.nixfmt-vscode
      mkhl.direnv
      thenuprojectcontributors.vscode-nushell-lang
      tamasfe.even-better-toml
      elmtooling.elm-ls-vscode
      denoland.vscode-deno
    ];

    userSettings = {
      "terminal.integrated.fontFamily" = "'JetBrainsMono NF'";
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "'JetBrainsMono NF'";
      "window.menuBarVisibility" = "toggle";
    };
  };
}