{
  description = "Dev shell for hacking on this Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      # Systems this dev shell is built for.
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          # Tools the Neovim config expects on $PATH while editing *this* repo:
          #   - lua-language-server: LSP for the Lua config files
          #   - stylua:              format-on-save (conform.nvim) for Lua
          packages = [
            pkgs.lua-language-server
            pkgs.stylua
          ];

          shellHook = ''
            echo "nvim-config dev shell — lua_ls + stylua on \$PATH"
          '';
        };
      });
    };
}
