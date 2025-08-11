{
  description = "Composable development environments with project templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mcphub-nvim.url = "github:ravitemer/mcphub.nvim";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      mcphub-nvim,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        mcpPackages = with pkgs; [
          mcphub-nvim.packages."${system}".default
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

        justPackages = [
          pkgs.just
          pkgs.just-lsp
        ];

        moonPackages = [
          pkgs.moon
        ];

        tsPackages = with pkgs; [
          bun
          typescript-language-server
        ];

        twPackages = [ pkgs.tailwindcss-language-server ];

        yamlPackages = [
          pkgs.yamlfmt
          pkgs.yaml-language-server
        ];

        zigPackages = with pkgs; [
          zig
          zls
        ];

        mkShell =
          extraPackages:
          pkgs.mkShell {
            packages = nixPackages ++ mcpPackages ++ yamlPackages ++ extraPackages;
          };
      in
      with rec {
        devShells = {
          default = mkShell [ ];
          just = mkShell justPackages;
          moon = mkShell moonPackages;
          py = mkShell pyPackages;
          rs = mkShell rsPackages;
          go = mkShell goPackages;
          ts = mkShell tsPackages;
          zig = mkShell zigPackages;
          # systems = mkShell (rsPackages ++ goPackages ++ zigPackages);
          mono = mkShell (moonPackages ++ tsPackages ++ rsPackages);
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
        just = {
          path = ./templates/just;
          description = "Just project";
        };
        moon = {
          path = ./templates/moon;
          description = "Moonrepo project";
        };
        mcp = {
          path = ./templates/mcp;
          description = "MCP servers";
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
