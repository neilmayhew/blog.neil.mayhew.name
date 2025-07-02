{ mkDerivation, base, hakyll, lib }:
mkDerivation {
  pname = "blog-neil-mayhew-name";
  version = "0.1.0.0";
  src = lib.sourceFilesBySuffices ./. ["cabal" "hs"];
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base hakyll ];
  homepage = "https://github.com/neilmayhew/blog.neil.mayhew.name/";
  description = "A Haskyll-based builder for https://blog.neil.mayhew.name";
  license = "MIT-0";
  mainProgram = "site";
}
