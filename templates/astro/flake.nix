{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      utils,
      ...
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        typescriptBase = (import ../typescript/flake.nix).outputs { inherit nixpkgs utils; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = typescriptBase.devShells.typescriptBase.buildInputs ++ [
            pkgs.astro-language-server
          ];
        };
      }
    );
}
