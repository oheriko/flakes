{
  description = "Erik's composable development environments with auto-installing configs";

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
        # BASE: Essential tools for any development
        default = pkgs.mkShell {
          packages = [
            pkgs.git
            pkgs.tree-sitter
            pkgs.nil
            pkgs.nixfmt-rfc-style
          ];
          shellHook = ''
            echo "📦 Base development environment"
            echo ""
            echo "Layer tools in your .envrc:"
            echo "  use flake github:oheriko/flakes#typescript"
            echo "  use flake github:oheriko/flakes#python"
            echo "  use flake github:oheriko/flakes#rust"
            echo "  use flake github:oheriko/flakes#go"
            echo ""
            echo "Get config files:"
            echo "  curl -O https://raw.githubusercontent.com/oheriko/flakes/main/configs/.gitignore"
          '';
        };

        # TYPESCRIPT: Simple auto-installing TypeScript shell
        typescript = pkgs.mkShell {
          packages = [
            pkgs.nodejs_24
            pkgs.bun
            pkgs.typescript-language-server
            pkgs.tailwindcss-language-server
          ];
          shellHook = ''
            echo "🟦 TypeScript tools loaded"

            # Auto-install biome.jsonc if missing
            if [ ! -f "biome.jsonc" ] && [ ! -f "biome.json" ]; then
              echo "Creating biome.jsonc..."
              curl -s https://raw.githubusercontent.com/oheriko/flakes/main/configs/biome.jsonc > biome.jsonc
            fi
          '';
        };

        # PYTHON: Simple auto-installing Python shell
        python = pkgs.mkShell {
          packages = [
            pkgs.python3
            pkgs.uv
            pkgs.ruff
          ];
          shellHook = ''
            echo "🐍 Python tools loaded"

            # Auto-install pyproject.toml if missing
            if [ ! -f "pyproject.toml" ]; then
              echo "Creating pyproject.toml..."
              curl -s https://raw.githubusercontent.com/oheriko/flakes/main/configs/pyproject.toml > pyproject.toml
              uv sync
            fi

            # Activate .venv if it exists
            if [ -d ".venv" ]; then
              export VIRTUAL_ENV="$(pwd)/.venv"
              export PATH="$VIRTUAL_ENV/bin:$PATH"
              export UV_PYTHON_DOWNLOADS=never
              export UV_PYTHON_EXECUTABLE="${pkgs.python3}/bin/python"
            fi
          '';
        };

        # RUST: Simple auto-installing Rust shell
        rust = pkgs.mkShell {
          packages = [
            pkgs.rustc
            pkgs.cargo
            pkgs.rust-analyzer
            pkgs.rustfmt
            pkgs.clippy
          ];
          shellHook = ''
            echo "🦀 Rust tools loaded"
            export RUST_BACKTRACE=1

            # Auto-install Cargo.toml if missing
            if [ ! -f "Cargo.toml" ]; then
              echo "Creating Cargo.toml..."
              curl -s https://raw.githubusercontent.com/oheriko/flakes/main/configs/Cargo.toml > Cargo.toml
              
              if [ ! -d "src" ]; then
                mkdir -p src
                echo 'fn main() { println!("Hello, world!"); }' > src/main.rs
              fi
            fi
          '';
        };

        # GO: Simple auto-installing Go shell
        go = pkgs.mkShell {
          packages = [
            pkgs.go
            pkgs.gopls
            pkgs.golangci-lint
            pkgs.go-tools
          ];
          shellHook = ''
                        echo "🐹 Go tools loaded"
                        export GOPATH="$HOME/go"
                        export PATH="$GOPATH/bin:$PATH"
                        
                        # Auto-install go.mod if missing
                        if [ ! -f "go.mod" ]; then
                          echo "Creating go.mod..."
                          PROJECT_NAME=$(basename "$(pwd)")
                          go mod init "$PROJECT_NAME"
                          
                          if [ ! -f "main.go" ]; then
                            cat > main.go << 'EOF'
            package main

            import "fmt"

            func main() {
                fmt.Println("Hello, World!")
            }
            EOF
                          fi
                        fi
          '';
        };

        # ASTRO: Astro-specific tools
        astro = pkgs.mkShell {
          packages = [
            pkgs.nodejs_24
            pkgs.bun
            pkgs.astro-language-server
            pkgs.typescript-language-server
            pkgs.tailwindcss-language-server
          ];
          shellHook = ''
            echo "🚀 Astro tools loaded"

            # Auto-install biome.jsonc if missing (Astro uses same config as TypeScript)
            if [ ! -f "biome.jsonc" ] && [ ! -f "biome.json" ]; then
              echo "Creating biome.jsonc..."
              curl -s https://raw.githubusercontent.com/oheriko/flakes/main/configs/biome.jsonc > biome.jsonc
            fi
          '';
        };

        # LUA: Lua development tools
        lua = pkgs.mkShell {
          packages = [
            pkgs.lua
            pkgs.luajit
            pkgs.stylua
            pkgs.lua-language-server
          ];
          shellHook = ''
            echo "🌙 Lua tools loaded"
          '';
        };

        # ZIG: Zig development tools
        zig = pkgs.mkShell {
          packages = [
            pkgs.zig
            pkgs.zls
          ];
          shellHook = ''
            echo "⚡ Zig tools loaded"
          '';
        };
      });
    };
}
