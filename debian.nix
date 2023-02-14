{ lib, releaseFile, fetchurl, runCommandNoCC, linkFarm, python3 }:
let
  release = builtins.fromJSON (builtins.readFile releaseFile);
in
linkFarm release.distribution (builtins.map
  (file:
  let
    packages = fetchurl {
      url = "${release.uri}/${file.filename}";
      sha256 = file.sha256;
    };
    temp = runCommandNoCC "temp"
      {
        nativeBuildInputs = [
          (python3.withPackages
            (ps: with ps; [ debian ]))
        ];
      } ''
      python ${./debian-packages} --input ${packages} --output $out
    '';
  in
  [
    {
      name = file.filename;
      path = packages;
    }
    {
      name = "${file.filename}.temp";
      path = temp;
    }
  ])
  release.files)
