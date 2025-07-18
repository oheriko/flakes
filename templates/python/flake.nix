{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.python3
            pkgs.ruff
            pkgs.ty
            pkgs.uv
          ];
          shellHook = ''
            if [ ! -d .venv ]; then
              echo "Initializing uv .venv..."
              uv venv .venv --prompt project
            fi
            export VIRTUAL_ENV="$PWD/.venv"
            export PATH="$VIRTUAL_ENV/bin:$PATH"
            export UV_PYTHON_DOWNLOADS=never
            export UV_PYTHON_EXECUTABLE="${pkgs.python3}/bin/python"
          '';
        };
      }
    );
}
