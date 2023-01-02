{ pkgs ? import <nixpkgs> }:

let
  pythonPackages = pkgs.python310Packages;
in
pkgs.mkShell {
  name = "python-workshop";
  nativeBuildInputs = [
    pythonPackages.python
    pythonPackages.mypy

    pkgs.nodePackages.pyright
    pkgs.nodePackages.reveal-md
  ];
}
