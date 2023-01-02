{
  description = "Python workshop presentation";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.simpleFlake {
    inherit self nixpkgs;
    name = "python-workshop";
    shell = ./shell.nix;
  };
}
