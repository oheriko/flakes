{
  description = "Composable development environments with project templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        mcpPackages = with pkgs; [
          nodejs_24
          uv
        ];

        nixPackages = with pkgs; [
          nix
          nixfmt-rfc-style
        ];

        pyPackages = with pkgs; [
          python314
          ruff
          ty
        ];

        rsPackages = with pkgs; [
          rustc
          cargo
          rust-analyzer
          rustfmt
          clippy
        ];

        goPackages = with pkgs; [
          go
          gopls
          gotools
        ];

        justPackages = [ pkgs.just-language-server ];

        tsPackages = with pkgs; [
          bun
          typescript-language-server
        ];

        twPackages = [ pkgs.tailwindcss-language-server ];

        zigPackages = with pkgs; [
          zig
          zls
        ];

        mkShell =
          extraPackages:
          pkgs.mkShell {
            packages = nixPackages ++ mcpPackages ++ extraPackages;
          };
      in
      with rec {
        devShells = {
          default = mkShell [ ];
          just = mkShell justPackages;
          py = mkShell pyPackages;
          rs = mkShell rsPackages;
          go = mkShell goPackages;
          ts = mkShell tsPackages;
          zig = mkShell zigPackages;
          # systems = mkShell (rustPackages ++ goPackages ++ zigPackages);
        };
      };
      {
        inherit devShells;
      }
    )
    // {
      templates = {
        default = {
          path = ./templates/default;
          description = "Basic project with .envrc";
        };

        py = {
          path = ./templates/py;
          description = "Python project with uv and pyproject.toml";
        };

        ts = {
          path = ./templates/ts;
          description = "TypeScript project with modern tooling";
        };

        rs = {
          path = ./templates/rs;
          description = "Rust project with Cargo.toml";
        };

        go = {
          path = ./templates/go;
          description = "Go project with go.mod";
        };
      };
    };
}
