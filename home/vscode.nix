{ pkgs, ... }: let
  ms-mssql = (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-mssql";
      name = "mssql";
      version = "1.47.0";
      sha256 = "1fwywfvazmcz23gi291qv8qwpml8qkvgdzjc5jvz6jb8i6vvyfzv";
    };
  });
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.enableExtensionUpdateCheck = false;
    profiles.default.enableUpdateCheck = false;
    profiles.default.extensions = (with pkgs.vscode-extensions; [
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
    ]) ++ [
      ms-mssql
    ];

    profiles.default.mutableUserSettings = true;
    profiles.default.userSettings = {
      "terminal.integrated.fontFamily" = "'JetBrainsMono NF', 'JetBrains Mono Nerd Font";
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "'JetBrainsMono NF'";
      "window.menuBarVisibility" = "toggle";
    };
  };
}