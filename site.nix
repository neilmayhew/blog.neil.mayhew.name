{ stdenv, lib, glibcLocales, builder }:

stdenv.mkDerivation {

  name = "blog.neil.mayhew.name";

  src = lib.cleanSource ./.;

  nativeBuildInputs = [ glibcLocales ];

  installPhase = ''
    export LANG=en_US.UTF-8
    ${builder}/bin/site rebuild
    mv _site $out
  '';

  meta = with lib; {
    homepage = "https://blog.neil.mayhew.name/";
    description = "An occasional glimpse into my world";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ neilmayhew ];
  };
}
