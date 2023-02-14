{ lib, releaseFile, fetchurl, linkFarm }:
let
  release = builtins.fromJSON (builtins.readFile releaseFile);
in
linkFarm release.distribution (builtins.map
  (file: {
    name = file.filename;
    path = fetchurl {
      url = "${release.uri}/${file.filename}";
      sha256 = file.sha256;
    };
  })
  release.files)
