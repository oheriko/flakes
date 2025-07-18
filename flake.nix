{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    mcp.url = "github:ravitemer/mcp-hub";
  };

  outputs =
    { self, utils, ... }:
    {
      templates = {
        default = {
          path = ./templates/typescript;
          description = "Erik's base flake with TypeScript devShell setup for MCP etc.";
        };
        astro = {
          path = ./templates/astro;
          description = "Erik's Astro devShell setup.";
        };
        typescript = {
          path = ./templates/typescript;
          description = "Erik's TypeScript devShell setup.";
        };
        rust = {
          path = ./templates/rust;
          description = "Erik's Rust devShell setup.";
        };
        go = {
          path = ./templates/go;
          description = "Erik's Go devShell setup.";
        };
        python = {
          path = ./templates/python;
          description = "Erik's Python devShell setup.";
        };
        lua = {
          path = ./templates/lua;
          description = "Erik's Lua devShell setup.";
        };
        zig = {
          path = ./templates/zig;
          description = "Erik's Zig devShell setup.";
        };
      };
    };
}
