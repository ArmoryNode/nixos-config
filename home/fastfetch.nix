{ pkgs, ... }:
let
  fastFetchConfigPath = "./fastfetch/";
in 
{
  programs.fastfetch = {
    enable = true;
    settings = builtins.fromJSON (
      builtins.unsafeDiscardStringContext (
        builtins.readFile ./${fastFetchConfigPath}/config.jsonc
      )
    );
  };
}
