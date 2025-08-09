{
  description = "Composable development environments";

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

        # Base packages that every shell should have
        basePackages = with pkgs; [
          git
          curl
          fd
          ripgrep
          jq
          tree
          wget
          unzip
        ];

        # Language-specific package sets
        uvPackages = with pkgs; [
          uv
          python3
        ];
        nodePackages = with pkgs; [
          nodejs_22
          yarn
          pnpm
        ];
        rustPackages = with pkgs; [
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
        zigPackages = with pkgs; [
          zig
          zls
        ];

        # Shell builder helper
        mkShell =
          extraPackages:
          pkgs.mkShell {
            packages = basePackages ++ extraPackages;
            shellHook = ''
              echo "🚀 Development environment loaded!"
              echo "Base tools: git, curl, fd, rg, jq, tree, wget, unzip"
              ${if builtins.elem pkgs.uv extraPackages then "echo \"Python: uv available\"" else ""}
              ${if builtins.elem pkgs.nodejs_22 extraPackages then "echo \"Node.js: $(node --version)\"" else ""}
              ${if builtins.elem pkgs.rustc extraPackages then "echo \"Rust: $(rustc --version)\"" else ""}
              ${if builtins.elem pkgs.go extraPackages then "echo \"Go: $(go version)\"" else ""}
              ${if builtins.elem pkgs.zig extraPackages then "echo \"Zig: $(zig version)\"" else ""}
            '';
          };
      in
      {
        # Default shell - just base packages
        devShells.default = mkShell [ ];

        # Language-specific shells
        devShells.python = mkShell uvPackages;
        devShells.node = mkShell nodePackages;
        devShells.rust = mkShell rustPackages;
        devShells.go = mkShell goPackages;
        devShells.zig = mkShell zigPackages;

        # Combined shells for polyglot projects
        devShells.web = mkShell (nodePackages ++ uvPackages); # Node + Python
        devShells.fullstack = mkShell (nodePackages ++ uvPackages ++ goPackages);
        devShells.systems = mkShell (rustPackages ++ goPackages ++ zigPackages);

        # Convenience aliases (same shells, different names)
        devShells.py = self.devShells.${system}.python;
        devShells.js = self.devShells.${system}.node;
        devShells.rs = self.devShells.${system}.rust;
      }
    );
}
