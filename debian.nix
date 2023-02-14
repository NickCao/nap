{ lib, releaseFile, fetchurl, runCommandNoCC, linkFarm, python3 }:
let
  release = builtins.fromJSON (builtins.readFile releaseFile);
  packages = builtins.map
    (file: fetchurl {
      url = "${release.uri}/${file.filename}";
      sha256 = file.sha256;
    })
    release.files;
in
runCommandNoCC "${release.distribution}.db"
{
  nativeBuildInputs = [
    (python3.withPackages
      (ps: with ps; [ debian ]))
  ];
} ''
  python ${./debian-packages} ${lib.escapeShellArgs packages} --output $out
''
