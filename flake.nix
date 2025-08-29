{
  description = "Hakyll-based web site for blog.neil.mayhew.name";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        with import nixpkgs { inherit system; };
        with self.packages.${system};
        {
          packages = {
            default = haskell.lib.justStaticExecutables (pkgsStatic.haskellPackages.callPackage ./default.nix { });
            site = callPackage ./site.nix { builder = default; };
          };
          apps = {
            default = flake-utils.lib.mkApp { drv = default; };
          };
          devShells = {
            default = default.env;
          };
        }
      );

  nixConfig = {
    extra-substituters = [
      "https://neil-mayhew.cachix.org"
    ];
    extra-trusted-public-keys = [
      "neil-mayhew.cachix.org-1:mxrzBmebKDFyT7RzZom+8uhFochoTk6BL/1UTBU64eY="
    ];
  };
}
