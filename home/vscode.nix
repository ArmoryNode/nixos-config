{ pkgs, ... }: let
  ms-mssql = (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-mssql";
      name = "mssql";
      version = "1.47.0";
      sha256 = "1fwywfvazmcz23gi291qv8qwpml8qkvgdzjc5jvz6jb8i6vvyfzv";
    };
  });
  ollama.ollama = (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "Ollama";
      name = "ollama";
      version = "0.0.14";
      sha256 = "a811fd4b6d68b6aa6dbbf12dd0af6c75f3530789b461001add17cdb7ed1e5262";
    };
  });
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.enableExtensionUpdateCheck = false;
    profiles.default.enableUpdateCheck = false;
    profiles.default.extensions = (with pkgs.vscode-extensions; [
      github.copilot-chat
      ionide.ionide-fsharp
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
      jnoortheen.nix-ide
      brettm12345.nixfmt-vscode
      thenuprojectcontributors.vscode-nushell-lang
      tamasfe.even-better-toml
      denoland.vscode-deno
      ms-vscode-remote.remote-ssh
    ]) ++ [
      ms-mssql
      ollama.ollama
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