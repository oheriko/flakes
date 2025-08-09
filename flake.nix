{
  description = "oheriko's development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.git
            pkgs.tree-sitter
            pkgs.nil
            pkgs.nixfmt-rfc-style
            pkgs.nodejs_24 # For MCP servers
            pkgs.uv # For MCP servers
          ];
        };

        typescript = pkgs.mkShell {
          packages = [
            pkgs.bun
            pkgs.typescript-language-server
            pkgs.tailwindcss-language-server
          ];
          shellHook = ''
            if [ ! -f "biome.jsonc" ] && [ ! -f "biome.json" ]; then
              curl -s https://raw.githubusercontent.com/oheriko/flakes/main/configs/biome.jsonc > biome.jsonc
            fi
          '';
        };

        # PYTHON: Simple auto-installing Python shell
        python = pkgs.mkShell {
          packages = [
            pkgs.python3
            pkgs.ruff
          ];
          shellHook = ''
            if [ ! -f "pyproject.toml" ]; then
              curl -s https://raw.githubusercontent.com/oheriko/flakes/main/configs/pyproject.toml > pyproject.toml
              uv sync
            fi

            if [ -d ".venv" ]; then
              export VIRTUAL_ENV="$(pwd)/.venv"
              export PATH="$VIRTUAL_ENV/bin:$PATH"
              export UV_PYTHON_DOWNLOADS=never
              export UV_PYTHON_EXECUTABLE="${pkgs.python3}/bin/python"
            fi
          '';
        };

        rust = pkgs.mkShell {
          packages = [
            pkgs.rustc
            pkgs.cargo
            pkgs.rust-analyzer
            pkgs.rustfmt
            pkgs.clippy
          ];
          shellHook = ''
            export RUST_BACKTRACE=1

            if [ ! -f "Cargo.toml" ]; then
              curl -s https://raw.githubusercontent.com/oheriko/flakes/main/configs/Cargo.toml > Cargo.toml
            fi
          '';
        };

        go = pkgs.mkShell {
          packages = [
            pkgs.go
            pkgs.gopls
            pkgs.golangci-lint
            pkgs.go-tools
          ];
          shellHook = ''
            export GOPATH="$HOME/go"
            export PATH="$GOPATH/bin:$PATH"

            if [ ! -f "go.mod" ]; then
              PROJECT_NAME=$(basename "$(pwd)")
              go mod init "$PROJECT_NAME"

            fi
          '';
        };

        astro = pkgs.mkShell {
          packages = [
            pkgs.bun
            pkgs.astro-language-server
            pkgs.typescript-language-server
            pkgs.tailwindcss-language-server
          ];
          shellHook = ''
            if [ ! -f "biome.jsonc" ] && [ ! -f "biome.json" ]; then
              curl -s https://raw.githubusercontent.com/oheriko/flakes/main/configs/biome.jsonc > biome.jsonc
            fi
          '';
        };

        lua = pkgs.mkShell {
          packages = [
            pkgs.lua
            pkgs.luajit
            pkgs.stylua
            pkgs.lua-language-server
          ];
        };

        zig = pkgs.mkShell {
          packages = [
            pkgs.zig
            pkgs.zls
          ];
        };
      });
    };
}
