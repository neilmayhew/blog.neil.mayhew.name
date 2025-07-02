{ lib, busybox, glibcLocalesUtf8, builder, system }:

let
  src = lib.cleanSource ./.;
in

derivation {

  name = "blog.neil.mayhew.name";

  builder = "${busybox}/bin/sh";

  args = [
    "-ec"
    ''
      export LOCALE_ARCHIVE=${glibcLocalesUtf8}/lib/locale/locale-archive
      export LANG=en_US.UTF-8
      PATH=${busybox}/bin:$PATH
      cp -r ${src} src
      chmod +w src
      cd src
      ${builder}/bin/site rebuild
      mv _site $out
    ''
  ];

  inherit system;
}
