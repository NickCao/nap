{ lib, fetchzip, fetchurl, linkFarm }:
let
  db = fetchzip {
    url = "https://arch-archive.tuna.tsinghua.edu.cn/2023/02-06/core/os/x86_64/core.db.tar.gz";
    stripRoot = false;
    hash = "sha256-a9B0GC8/j3JM+eewBDuH0C/zxoGGEX8hyHRjGZvlbog=";
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
      url = "https://arch-archive.tuna.tsinghua.edu.cn/2023/02-06/core/os/x86_64/${desc.filename}";
      sha256 = desc.sha256sum;
    };
  };
  packages = linkFarm "core" (builtins.attrValues (builtins.mapAttrs
    (name: value:
      assert value == "directory";
      toDerivation (parseDesc (builtins.readFile "${db}/${name}/desc")))
    (builtins.readDir db)));
in
packages
