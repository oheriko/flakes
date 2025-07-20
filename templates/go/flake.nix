{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    base.url = "github:oheriko/flakes";
  };

  outputs =
    {
      nixpkgs,
      utils,
      base,
      ...
    }:
    utils.lib.eachDefaultSystem (system: {
      devShells.default = base.lib.${system}.mkGoShell [ ];
    });
}
