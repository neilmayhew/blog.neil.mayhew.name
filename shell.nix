{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  builder = haskellPackages.callPackage ./default.nix {};
  site = pkgs.callPackage ./site.nix { inherit builder; };

in

  if pkgs.lib.inNixShell then builder.env else { inherit builder site; }
