{ lib
, fetchzip
, fetchurl
, linkFarm
, mirror ? "https://arch-archive.tuna.tsinghua.edu.cn"
, repo
, date
, hash
}:
let
  db = fetchzip {
    url = "${mirror}/${date}/${repo}/os/x86_64/${repo}.db.tar.gz";
    stripRoot = false;
    inherit hash;
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
        builtins.elem (builtins.elemAt pair 0) [ "%FILENAME%" "%SHA256SUM%" ]
      ))
      (builtins.map
        (lib.strings.splitString "\n")
        (lib.strings.splitString "\n\n" desc))));
  toDerivation = desc: {
    name = desc.filename;
    path = fetchurl {
      name = "source";
      url = "${mirror}/${date}/${repo}/os/x86_64/${desc.filename}";
      sha256 = desc.sha256sum;
    };
  };
  packages = linkFarm repo (builtins.attrValues (builtins.mapAttrs
    (name: value:
      assert value == "directory";
      toDerivation (parseDesc (builtins.readFile "${db}/${name}/desc")))
    (builtins.readDir db)));
in
packages
