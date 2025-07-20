{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    mcp.url = "github:ravitemer/mcp-hub";
  };
  outputs =
    {
      nixpkgs,
      utils,
      mcp,
      ...
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            mcp.packages.${system}.default
            pkgs.lua
            pkgs.luajit
            pkgs.nodejs_24
            pkgs.stylua
            pkgs.lua-language-server
            pkgs.uv
          ];
        };
      }
    );
}
