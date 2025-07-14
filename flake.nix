{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    mcp.url = "github:ravitemer/mcp-hub";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
      mcp,
    }:
    let
      systems = utils.lib.defaultSystems;
      perSystem = utils.lib.eachSystem systems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          devShells.default = pkgs.mkShell {
            packages = [
              mcp.packages.${system}.default
              pkgs.bun
              pkgs.nixfmt-rfc-style
              pkgs.nodejs_24
              pkgs.tailwindcss-language-server
              pkgs.typescript-language-server
              pkgs.uv
            ];
          };
        }
      );
    in
    perSystem
    // {
      templates.default = {
        path = ./.;
        description = "Erik's base flake with devShell setup for MCP etc.";
      };
    };
}
