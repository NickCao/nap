{ lib, fetchzip }:
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
  packages = builtins.mapAttrs
    (name: value:
      assert value == "directory";
      parseDesc (builtins.readFile "${db}/${name}/desc"))
    (builtins.readDir db);
in
packages
