{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    base.url = "path:../../base";
  };

  outputs =
    {
      nixpkgs,
      utils,
      base,
      ...
    }:
    utils.lib.eachDefaultSystem (system: {
      devShells.default = base.lib.${system}.mkTypeScriptShell [ ];

      # Or if you need extra packages:
      # devShells.default = base-flake.lib.${system}.mkTypeScriptShell [
      #   # Extra packages specific to this project
      # ];
    });
}
