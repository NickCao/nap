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
            hash = "sha256-a9B0GC8/j3JM+eewBDuH0C/zxoGGEX8hyHRjGZvlbog=";
          };
        });
}
