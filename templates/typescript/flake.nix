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
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = base.lib.${system}.mkTypescriptShell [ ];
      }
    );
}
