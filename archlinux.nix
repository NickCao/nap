{ lib
, stdenvNoCC
, fetchzip
, fetchurl
, writeText
, linkFarm
, mirror ? "https://arch-archive.tuna.tsinghua.edu.cn"
, repo
, date
, hash
}:
let
  db = fetchurl {
    url = "${mirror}/${date}/${repo}/os/x86_64/${repo}.db.tar.gz";
    inherit hash;
  };
  dbExtracted = stdenvNoCC.mkDerivation {
    name = repo;
    src = db;
    buildCommand = ''
      mkdir -p $out
      tar -x -f $src -C $out
    '';
  };
  parseDesc = desc: lib.listToAttrs (builtins.map
    (pair: {
      name = lib.strings.toLower (
        builtins.replaceStrings [ "%" ] [ "" ]
          (builtins.elemAt pair 0)
      );
      value = builtins.elemAt pair 1;
    })
    (builtins.filter
      (pair: (
        builtins.length pair == 2 &&
        builtins.elem (builtins.elemAt pair 0) [ "%FILENAME%" "%SHA256SUM%" "%PGPSIG%" ]
      ))
      (builtins.map
        (lib.strings.splitString "\n")
        (lib.strings.splitString "\n\n" desc))));
  toDerivations = desc: [
    {
      name = desc.filename;
      path = fetchurl {
        name = "source";
        url = "${mirror}/${date}/${repo}/os/x86_64/${desc.filename}";
        sha256 = desc.sha256sum;
      };
    }
    {
      name = "${desc.filename}.sig";
      path = writeText "source" desc.pgpsig;
    }
  ];
  packages = linkFarm repo ((lib.flatten
    (builtins.attrValues (builtins.mapAttrs
      (name: value:
        assert value == "directory";
        toDerivations (parseDesc (builtins.readFile "${dbExtracted}/${name}/desc")))
      (builtins.readDir dbExtracted)))) ++ [
    { name = "${repo}.db"; path = db; }
    { name = "${repo}.db.tar.gz"; path = db; }
  ]);
in
packages
