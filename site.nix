{ stdenv, lib, glibcLocales, builder }:

stdenv.mkDerivation {

  pname = "blog.neil.mayhew.name";
  version = "1.0";

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
    license = licenses.gpl3;
    maintainers = with maintainers; [ neilmayhew ];
  };
}
