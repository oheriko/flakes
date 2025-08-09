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

        baseDevTools = with pkgs; [
          age
          direnv
          fd
          git
          jq
          just
          nix
          nixfmt-rfc-style
          nodejs_24
          ripgrep
          sops
          uv
        ];

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
        devShells = {
          default = mkDevShell [ ];

          ts = mkDevShell [
            pkgs.bun
            pkgs.typescript-language-server
          ];

          yarn = mkDevShell [
            pkgs.yarn
          ];

          pnpm = mkDevShell [
            pkgs.pnpm
          ];

          python = mkDevShell (
            with pkgs;
            [
              python313
              ruff
              ty
            ]
          );

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

          go = mkDevShell (
            with pkgs;
            [
              go
              gopls
              golangci-lint
              delve
            ]
          );

          web = mkDevShell (
            with pkgs;
            [
              tailwindcss-language-server
              typescript-language-server
            ]
          );

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
      }
    );
}
