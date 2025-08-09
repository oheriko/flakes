{
  description = "Bun";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Could also reference your shared flake if you want
  };

  outputs =
    { nixpkgs, ... }:
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [ pkgs.bun ];
        shellHook = ''
          if [ ! -f "biome.jsonc" ]; then
            echo "📥 Fetching Biome config..."
            curl -s -o biome.jsonc https://raw.githubusercontent.com/oheriko/configs/main/biome/biome.jsonc
          fi
        '';
      };
    };
}
