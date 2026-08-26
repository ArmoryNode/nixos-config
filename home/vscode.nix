{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    
    profiles.default.extensions = with pkgs.vscode-extensions; [
      github.copilot 
      ionide.ionide-fsharp
      visualstudioexptteam.vscodeintellicode
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
      jnoortheen.nix-ide
      brettm12345.nixfmt-vscode
      thenuprojectcontributors.vscode-nushell-lang
      tamasfe.even-better-toml
      elmtooling.elm-ls-vscode
      denoland.vscode-deno
    ];

    profiles.default.userSettings = {
      "terminal.integrated.fontFamily" = "'JetBrainsMono NF'";
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "'JetBrainsMono NF'";
      "window.menuBarVisibility" = "toggle";
    };
  };
}