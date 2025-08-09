{
  description = "Personal development environment flake with opinionated tooling";

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

        # Core development tools shared across all environments
        baseDevTools = with pkgs; [
          # Version control & nix
          git
          nix
          nixfmt-rfc-style

          # Essential CLI tools
          curl
          jq
          ripgrep
          fd

          # Development workflow
          direnv
          just

          # Node.js ecosystem
          nodejs_24

          # Python tooling
          uv
        ];

        # Helper function to create development shells
        mkDevShell =
          extraPkgs:
          pkgs.mkShell {
            buildInputs = baseDevTools ++ extraPkgs;
            shellHook = ''
              echo "🚀 Development environment ready!"
              echo "📦 Available tools: ${
                builtins.concatStringsSep ", " (map (pkg: pkg.pname or pkg.name) (baseDevTools ++ extraPkgs))
              }"
            '';
          };

      in
      {
        # Development shells for different stacks
        devShells = {
          # Default: just the base tools
          default = mkDevShell [ ];

          # JavaScript/TypeScript with Bun
          bun = mkDevShell [ pkgs.bun ];

          # JavaScript/TypeScript with Node
          node = mkDevShell [
            pkgs.yarn
            pkgs.pnpm
          ];

          # Python development
          python = mkDevShell (
            with pkgs;
            [
              python313
              python313Packages.pip
              python313Packages.virtualenv
              ruff
              mypy
            ]
          );

          # Rust development
          rust = mkDevShell (
            with pkgs;
            [
              rustc
              cargo
              rustfmt
              rust-analyzer
              clippy
            ]
          );

          # Go development
          go = mkDevShell (
            with pkgs;
            [
              go
              gopls
              golangci-lint
              delve
            ]
          );

          # Web development (full stack)
          web = mkDevShell (
            with pkgs;
            [
              nodejs_24
              bun
              yarn
              pnpm
              tailwindcss-language-server
              vscode-langservers-extracted
            ]
          );

          # DevOps/Infrastructure
          devops = mkDevShell (
            with pkgs;
            [
              docker
              docker-compose
              kubectl
              helm
              terraform
              aws-cli
              gh
            ]
          );

          # Data science
          data = mkDevShell (
            with pkgs;
            [
              python313
              python313Packages.jupyter
              python313Packages.pandas
              python313Packages.numpy
              python313Packages.matplotlib
              R
              rPackages.tidyverse
            ]
          );
        };

        # Formatter for `nix fmt`
        formatter = pkgs.nixfmt-rfc-style;

        # Development checks
        checks = {
          format-check =
            pkgs.runCommand "format-check"
              {
                buildInputs = [ pkgs.nixfmt-rfc-style ];
              }
              ''
                ${pkgs.nixfmt-rfc-style}/bin/nixfmt --check ${./flake.nix}
                touch $out
              '';
        };
      }
    );
}
