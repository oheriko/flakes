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
          ];
        };

        typescript = pkgs.mkShell {
          packages = [
            pkgs.nodejs_24
            pkgs.bun
            pkgs.typescript-language-server
            pkgs.tailwindcss-language-server
          ];
        };

        python = pkgs.mkShell {
          packages = [
            pkgs.python3
            pkgs.uv
            pkgs.ruff
          ];
          shellHook = ''
            if [ ! -d .venv ]; then
              echo "Initializing Python virtual environment..."
              uv venv .venv --prompt project
            fi
            export VIRTUAL_ENV="$PWD/.venv"
            export PATH="$VIRTUAL_ENV/bin:$PATH"
            export UV_PYTHON_DOWNLOADS=never
            export UV_PYTHON_EXECUTABLE="${pkgs.python3}/bin/python"
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
          '';
        };

        astro = pkgs.mkShell {
          packages = [
            pkgs.nodejs_24
            pkgs.bun
            pkgs.astro-language-server
            pkgs.typescript-language-server
            pkgs.tailwindcss-language-server
          ];
        };
      });
    };
}
