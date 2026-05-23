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
            static = haskell.lib.justStaticExecutables
              (pkgsStatic.haskellPackages.callPackage ./default.nix { });
            dynamic = haskell.lib.justStaticExecutables
              (haskellPackages.callPackage ./default.nix { });
            default = static;
            site = callPackage ./site.nix { builder = default; };
          };
          devShells = {
            dynamic = dynamic.env;
            static = static.env;
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
