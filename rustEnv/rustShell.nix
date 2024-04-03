let pkgs = import <nixpkgs> {}; in
derivation {
  name = "rust-env";
  system = "x86_64-linux";
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./builder.sh ];
  outputs = ["out"];
  setup = ./setup.sh;
  stdenv = ./myStdEnv;
  src = ./helloworld;
  inputDrvs = [pkgs.bash pkgs.rustc pkgs.cargo pkgs.coreutils pkgs.gcc];
}
