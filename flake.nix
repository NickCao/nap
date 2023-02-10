{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = import nixpkgs { inherit system; }; in {
          packages.core = pkgs.callPackage ./core.nix {
            repo = "core";
            date = "2023/02-06";
            hash = "sha256-RcVVXv56bmm6ZS2XBiXYBr4DqZFkCTBwc7F8JOIzsAM=";
          };
        });
}
