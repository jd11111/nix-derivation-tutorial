let pkgs = import <nixpkgs> {}; in
derivation {
  name = "hello";
  system = "x86_64-linux";
  builder = "${pkgs.bash}/bin/bash";
  args = [ "-c" "echo hello world > $out" ];
  outputs = ["out"];
  inputDrvs = [pkgs.bash];
}
