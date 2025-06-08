{ mkDerivation, base, hakyll, lib }:
mkDerivation {
  pname = "blog-neil-mayhew-name";
  version = "0.1.0.0";
  src = lib.cleanSource ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base hakyll ];
  license = "unknown";
  mainProgram = "site";
}
