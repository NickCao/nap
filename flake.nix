{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = import nixpkgs { inherit system; }; in {
          packages.core = pkgs.callPackage ./archlinux.nix {
            repo = "core";
            date = "2023/02-06";
            hash = "sha256-RcVVXv56bmm6ZS2XBiXYBr4DqZFkCTBwc7F8JOIzsAM=";
          };
          packages.extra = pkgs.callPackage ./archlinux.nix {
            repo = "extra";
            date = "2023/02-06";
            hash = "sha256-h2oYA85vMEkBiyCF1aU+NjP4dBhOGkeEGJrbXyWr2cA=";
          };
          packages.community = pkgs.callPackage ./archlinux.nix {
            repo = "community";
            date = "2023/02-06";
            hash = "sha256-fiVQbySTYY9NeMC8eEXvJbquuFjvdE7Nzs0mcp74TGc=";
          };
        });
}
