{
  description = "Erik's base development flake with common tools and utilities";

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
    let
      commonPackages = system: pkgs: [
        mcp.packages.${system}.default
        pkgs.nil
        pkgs.nixfmt-rfc-style
        pkgs.nodejs_24
        pkgs.uv
      ];

      languagePackages = {
        typescript = system: pkgs: [
          pkgs.bun
          pkgs.tailwindcss-language-server
          pkgs.typescript-language-server
        ];

        astro = system: pkgs: [
          pkgs.astro-language-server
          pkgs.bun
          pkgs.tailwindcss-language-server
          pkgs.typescript-language-server
        ];

        python = system: pkgs: [
          pkgs.python3
          pkgs.ruff
          pkgs.ty
        ];

        go = system: pkgs: [
          pkgs.go
          pkgs.gopls
          pkgs.golangci-lint
          pkgs.go-tools
          pkgs.delve
        ];

        lua = system: pkgs: [
          pkgs.lua
          pkgs.luajit
          pkgs.stylua
          pkgs.lua-language-server
        ];

        rust = system: pkgs: [
          pkgs.rust-bin.stable.latest.default
          pkgs.cargo-watch
          pkgs.rust-analyzer
          pkgs.clippy
          pkgs.rustfmt
        ];

        zig = system: pkgs: [
          pkgs.zig
          pkgs.zls
        ];
      };

      shellHooks = {
        python = pkgs: ''
          if [ ! -d .venv ]; then
            echo "Initializing uv .venv..."
            uv venv .venv --prompt project
          fi
          export VIRTUAL_ENV="$PWD/.venv"
          export PATH="$VIRTUAL_ENV/bin:$PATH"
          export UV_PYTHON_DOWNLOADS=never
          export UV_PYTHON_EXECUTABLE="${pkgs.python3}/bin/python"
        '';

        go = pkgs: ''
          export GOPATH="$HOME/go"
          export PATH="$GOPATH/bin:$PATH"
        '';

        rust = pkgs: ''
          export RUST_BACKTRACE=1
        '';
      };

      mkDevShell =
        {
          system,
          language ? null,
          extraPackages ? [ ],
          extraHook ? "",
        }:
        let
          pkgs = import nixpkgs { inherit system; };
          basePackages = commonPackages system pkgs;

          langPackages =
            if language != null then (languagePackages.${language} or (system: pkgs: [ ])) system pkgs else [ ];

          allPackages = basePackages ++ langPackages ++ extraPackages;

          baseHook = if language != null then (shellHooks.${language} or (pkgs: "")) pkgs else "";

          finalHook = if extraHook != "" then baseHook + "\n" + extraHook else baseHook;
        in
        pkgs.mkShell {
          packages = allPackages;
          shellHook = finalHook;
        };
    in
    utils.lib.eachDefaultSystem (system: {
      lib = {
        inherit
          mkDevShell
          commonPackages
          languagePackages
          shellHooks
          ;

        mkTypescriptShell =
          extraPackages:
          mkDevShell {
            inherit system extraPackages;
            language = "typescript";
          };

        mkAstroShell =
          extraPackages:
          mkDevShell {
            inherit system extraPackages;
            language = "astro";
          };

        mkPythonShell =
          extraPackages:
          mkDevShell {
            inherit system extraPackages;
            language = "python";
          };

        mkGoShell =
          extraPackages:
          mkDevShell {
            inherit system extraPackages;
            language = "go";
          };

        mkLuaShell =
          extraPackages:
          mkDevShell {
            inherit system extraPackages;
            language = "lua";
          };

        mkRustShell =
          extraPackages:
          mkDevShell {
            inherit system extraPackages;
            language = "rust";
          };

        mkZigShell =
          extraPackages:
          mkDevShell {
            inherit system extraPackages;
            language = "zig";
          };
      };

      devShells = {
        typescript = mkDevShell {
          inherit system;
          language = "typescript";
        };
        astro = mkDevShell {
          inherit system;
          language = "astro";
        };
        python = mkDevShell {
          inherit system;
          language = "python";
        };
        go = mkDevShell {
          inherit system;
          language = "go";
        };
        lua = mkDevShell {
          inherit system;
          language = "lua";
        };
        rust = mkDevShell {
          inherit system;
          language = "rust";
        };
        zig = mkDevShell {
          inherit system;
          language = "zig";
        };
      };
    })
    // {
      # Export templates that use this flake directly
      templates = {
        default = {
          path = ./templates/typescript;
          description = "TypeScript development environment using base flake";
        };
        typescript = {
          path = ./templates/typescript;
          description = "TypeScript development environment using base flake";
        };
        astro = {
          path = ./templates/astro;
          description = "Astro development environment using base flake";
        };
        go = {
          path = ./templates/go;
          description = "Go development environment using base flake";
        };
        lua = {
          path = ./templates/lua;
          description = "Lua development environment using base flake";
        };
        python = {
          path = ./templates/python;
          description = "Python development environment using base flake";
        };
        rust = {
          path = ./templates/rust;
          description = "Rust development environment using base flake";
        };
        zig = {
          path = ./templates/zig;
          description = "Zig development environment using base flake";
        };
      };
    };
}
