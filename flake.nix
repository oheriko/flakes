{
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
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        baseDevTools = with pkgs; [
          git
          nix
          nixfmt-rfc-style
          curl
          nodejs_24
          uv
          direnv
          just
        ];

        mkDevShell =
          extraPkgs:
          pkgs.mkShell {
            buildInputs = baseDevTools ++ extraPkgs;
          };

      in
      {
        devShells = {
          default = mkDevShell [ ];
          bun = mkDevShell [ pkgs.bun ];
          python = mkDevShell (
            with pkgs;
            [
              python313
            ]
          );

          rust = mkDevShell (
            with pkgs;
            [
              rustc
              cargo
              rust-analyzer
            ]
          );

          go = mkDevShell [ pkgs.go ];
        };
      }
    ))
    // {
      # Templates are system-independent and go at the top level
      templates = {
        bun = {
          path = ./templates/bun;
          description = "Bun";
        };
        # ... other templates
      };
    };
}
