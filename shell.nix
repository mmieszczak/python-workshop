{ pkgs ? import <nixpkgs> }:

pkgs.mkShell {
  name = "python-workshop";
  nativeBuildInputs = [ pkgs.nodePackages.reveal-md ];
}
