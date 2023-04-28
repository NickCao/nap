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
            hash = "sha256-a9B0GC8/j3JM+eewBDuH0C/zxoGGEX8hyHRjGZvlbog=";
          };
          packages.extra = pkgs.callPackage ./archlinux.nix {
            repo = "extra";
            date = "2023/02-06";
            hash = "sha256-a5Jvd6cRTY6JFXZJD2T47tZPVVFNZAjjCiPATknn9GU=";
          };
          packages.community = pkgs.callPackage ./archlinux.nix {
            repo = "community";
            date = "2023/02-06";
            hash = "sha256-YVLp+rWqrjHfxedfgnsWj8WLvL0Ra9jQxrKqtCL7Y88=";
          };
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [
              (pkgs.python311.withPackages (ps: with ps;[ debian requests ]))
            ];
          };
        });
}
