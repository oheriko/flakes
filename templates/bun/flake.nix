{
  description = "Bun";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.bun ];
          shellHook = ''
            if [ ! -f "biome.jsonc" ]; then
              echo "📥 Fetching Biome config..."
              curl -s -o biome.jsonc https://raw.githubusercontent.com/oheriko/configs/main/biome/biome.jsonc
            fi
          '';
        };
      }
    );
}
