# NixOS derivations demystified

## Summary

Derivations (the files) are build instructions for files that are stored in the nix store and end on ```.drv```.
We can:
-  display a derivation in human readable form using ```nix derivation show /path/to/derivation.drv --extra-experimental-features nix-command ```
- build a derivation using ```nix-store --realize /path/to/derivation.drv```.
- create a derivation by calling the in-built ```derivation``` function in a .nix file and running ```nix-instantiate /path/to/file.nix``` 
- directly build a derivation from a .nix file calling the ```derivation``` function using ```nix-build  /path/to/file.nix``` 
- drop into a shell that has all input derivations of a derivation built with ```nix-shell /path/to/file.nix```

A larger pratical example using all these features is contained in the ```rustEnv``` directory of this repo. It is described in the final section of this file.

## All About NixPkgs

NixOS comes with the Nix language.
We can enter a repl as follows:
```console
[jd@jd-nixos:~/nix-derivation-tutorial]$ nix repl
Welcome to Nix 2.18.1. Type :? for help.
```
The most important variable is ```<nixpkgs>```.
To understand what it is simply enter it into the repl:
```console
nix-repl> <nixpkgs>
/nix/var/nix/profiles/per-user/root/channels/nixos
```
Its just a "magic" link to our local nixpkgs repo.
We can import the default.nix file in this repo using the inbuilt ```import``` function.
That will evaluate to a function, which when called with no arguments, will
give us what we want:
```console
nix-repl> pkgs = import <nixpkgs> {}
```
Now ```pkgs``` is a set whose keys are (among other things) derivations for packages.
For example 
```console
nix-repl> pkgs.cowsay
«derivation /nix/store/mjdhnlbl9yrf34c96gn2zfby7ddpgy5i-cowsay-3.7.0.drv»
```
Is the derivation for the ```cowsay``` binary.

## How Derivations Work

A derivation is a essentially a build instruction for a file (or mutiple files etc.).
For example the above derivation is the build instruction for the cowsay binary.
We can look at a derivation in human readable form as follows (:q to exit the nix-repl):
```console
[jd@jd-nixos:~/nix-derivation-tutorial]$ nix derivation show /nix/store/mjdhnlbl9yrf34c96gn2zfby7ddpgy5i-cowsay-3.7.0.drv --extra-experimental-features nix-command
{
  "/nix/store/mjdhnlbl9yrf34c96gn2zfby7ddpgy5i-cowsay-3.7.0.drv": {
    "args": [
      "-e",
      "/nix/store/v6x3cs394jgqfbi0a42pam708flxaphh-default-builder.sh"
    ],
    "builder": "/nix/store/r9h133c9m8f6jnlsqzwf89zg9w0w78s8-bash-5.2-p15/bin/bash",
    "env": {
      "buildInputs": "/nix/store/rk5xpm1vmkqzk90wabxpjdq10l016bnv-perl-5.38.2",
      "builder": "/nix/store/r9h133c9m8f6jnlsqzwf89zg9w0w78s8-bash-5.2-p15/bin/bash",
      "makeFlags": "prefix=/1rz4g4znpzjwh1xymhjpm42vipw92pr73vdgl6xs1hycac8kf2n9",
      "man": "/nix/store/w8lb15ha4pddr3rzz3snqjzv7vm6jv30-cowsay-3.7.0-man",
      "name": "cowsay-3.7.0",
      "nativeBuildInputs": "/nix/store/ac91mg8lx6cwmljahajnq85khcy008wk-make-shell-wrapper-hook",
      "out": "/nix/store/pjaiq8m9rjgj9akjgmbzmz86cvxwsyqm-cowsay-3.7.0",
      "outputs": "out man",
      "patches": "/nix/store/2ph6g2p2r82ha64axqpw0pbclg5rq68m-9e129fa0933cf1837672c97f5ae5ad4a1a10ec11.patch",
      "pname": "cowsay",
      "postInstall": "wrapProgram $out/bin/cowsay \\\n  --suffix COWPATH : $out/share/cowsay/cows\n",
      "src": "/nix/store/njxi0sclvggsdw89kr861q1bd8w7l902-source",
      "stdenv": "/nix/store/10i1kjjq5szjn1gp6418x8bc1hswqc90-stdenv-linux",
      "strictDeps": "",
      "system": "x86_64-linux",
      "version": "3.7.0"
    },
    "inputDrvs": {
      "/nix/store/aw29hjg17vgjn8r9s6wl2qnhnm81w7gv-make-shell-wrapper-hook.drv": {
        "dynamicOutputs": {},
        "outputs": [
          "out"
        ]
      },
      "/nix/store/cwja8kdrqmwbmpalkq08pvaf0f1gbnzc-9e129fa0933cf1837672c97f5ae5ad4a1a10ec11.patch.drv": {
        "dynamicOutputs": {},
        "outputs": [
          "out"
        ]
      },
      "/nix/store/g37lkvk17pcql1f8kwd9d2qyf6mwcxfs-source.drv": {
        "dynamicOutputs": {},
        "outputs": [
          "out"
        ]
      },
      "/nix/store/hpkl2vyxiwf7rwvjh9lpij7swp7igilx-bash-5.2-p15.drv": {
        "dynamicOutputs": {},
        "outputs": [
          "out"
        ]
      },
      "/nix/store/rpil79dk26yj7kqm404gavw1qjz56430-perl-5.38.2.drv": {
        "dynamicOutputs": {},
        "outputs": [
          "out"
        ]
      },
      "/nix/store/wxki4wp3v7b8l36jgaf9k5ibiijbd2k1-stdenv-linux.drv": {
        "dynamicOutputs": {},
        "outputs": [
          "out"
        ]
      }
    },
    "inputSrcs": [
      "/nix/store/v6x3cs394jgqfbi0a42pam708flxaphh-default-builder.sh"
    ],
    "name": "cowsay-3.7.0",
    "outputs": {
      "man": {
        "path": "/nix/store/w8lb15ha4pddr3rzz3snqjzv7vm6jv30-cowsay-3.7.0-man"
      },
      "out": {
        "path": "/nix/store/pjaiq8m9rjgj9akjgmbzmz86cvxwsyqm-cowsay-3.7.0"
      }
    },
    "system": "x86_64-linux"
  }
}
```
We can see that this is essentially a python like dictionary.
The keys are relatively self-explanatory:

- "name" the name of what is derived
- "outputs" is another dictionary specifiying what will be output by the derivation, in this case "out" (which is the default) which will contain the actual cowsay binary and "man" which will contain the manual, the path has the obvious meaning
- "system" just specifies the system we are building on
- "inputDrvs" are the derivations whose outputs are needed to build the program (i.e. bash)
- "inputSrcs" are sourcefiles that are needed (in this case default-builder.sh)
- "builder" specifies the binary that will be run with args "args" to build the output (in this case bash)
- "env" are enviromental variables available during build (notice that both "outputs" and "inputSrcs" and the outputs of "inputDrvs" are referenced here)

Now to build the derivation we can use ```nix-store``` (or :b in the repl)
```console
[jd@jd-nixos:~/nix-derivation-tutorial]$ nix-store --realise /nix/store/mjdhnlbl9yrf34c96gn2zfby7ddpgy5i-cowsay-3.7.0.drv
warning: you did not specify '--add-root'; the result might be removed by the garbage collector
/nix/store/pjaiq8m9rjgj9akjgmbzmz86cvxwsyqm-cowsay-3.7.0
/nix/store/w8lb15ha4pddr3rzz3snqjzv7vm6jv30-cowsay-3.7.0-man-3.7.0.drv
```
Now the cowsay binary is built and we can run it:
```console
 [jd@jd-nixos:~/nix-derivation-tutorial]$ /nix/store/pjaiq8m9rjgj9akjgmbzmz86cvxwsyqm-cowsay-3.7.0/bin/cowsay "hello world"
 _____________
< hello world >
 -------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
## How to Create Derivations

Now that we have a rough understanding of how derivations work, lets create our own!
To this end we will use the inbuilt nix ```derivation``` function (see [here](https://nixos.org/manual/nix/stable/language/derivations.html)).
We create the following file, called ```myDerivation.nix```:
```nix
let pkgs = import <nixpkgs> {}; in
derivation {
  name = "hello";
  system = "x86_64-linux";
  builder = "${pkgs.bash}/bin/bash";
  args = [ "-c" "echo hello world > $out" ];
  outputs = ["out"];
  inputDrvs = [pkgs.bash];
}
```
Now the arguments of ```derivation``` (the function) are self-explanatory in view of our exploration of the cowsay derivation (the file) above.
The only thing (apart from the let in, which i will just assume we understand) interesting here is
```"${pkgs.bash}/bin/bash"```.
"${pkgs.bash}" is a string interpolation and will expand to the path of the default output ("out")
of the derivation $pkgs.bash (you can test this in the repl).
So in this case it will expand to the path of the bash binary.

Now back in the nix repl (or ```nix-instantiate myDerivation.nix```):
```console
nix-repl> d = import ./myDerivation.nix
nix-repl> d
«derivation /nix/store/lbg51ad23fp916qz2khbc786vj4yhpah-hello.drv»
```
Just as before we can look at the derivation:
```console
[jd@jd-nixos:~/nix-derivation-tutorial]$ nix derivation show /nix/store/lbg51ad23fp916qz2khbc786vj4yhpah-hello.drv --extra-experimental-features nix-command
warning: The interpretation of store paths arguments ending in `.drv` recently changed. If this command is now failing try again with '/nix/store/lbg51ad23fp916qz2khbc786vj4yhpah-hello.drv^*'
{
  "/nix/store/lbg51ad23fp916qz2khbc786vj4yhpah-hello.drv": {
    "args": [
      "-c",
      "echo hello world > $out"
    ],
    "builder": "/nix/store/r9h133c9m8f6jnlsqzwf89zg9w0w78s8-bash-5.2-p15/bin/bash",
    "env": {
      "builder": "/nix/store/r9h133c9m8f6jnlsqzwf89zg9w0w78s8-bash-5.2-p15/bin/bash",
      "inputDrvs": "/nix/store/r9h133c9m8f6jnlsqzwf89zg9w0w78s8-bash-5.2-p15",
      "name": "hello",
      "out": "/nix/store/a89s0rsafrdc037lha4jkd4dhbkdis0l-hello",
      "outputs": "out",
      "system": "x86_64-linux"
    },
    "inputDrvs": {
      "/nix/store/hpkl2vyxiwf7rwvjh9lpij7swp7igilx-bash-5.2-p15.drv": {
        "dynamicOutputs": {},
        "outputs": [
          "out"
        ]
      }
    },
    "inputSrcs": [],
    "name": "hello",
    "outputs": {
      "out": {
        "path": "/nix/store/a89s0rsafrdc037lha4jkd4dhbkdis0l-hello"
      }
    },
    "system": "x86_64-linux"
  }
}
```
Again we can build the derivation using ```nix-store```:
```console
[jd@jd-nixos:~/nix-derivation-tutorial]$ nix-store --realize /nix/store/lbg51ad23fp916qz2khbc786vj4yhpah-hello.drv
this derivation will be built:
  /nix/store/lbg51ad23fp916qz2khbc786vj4yhpah-hello.drv
building '/nix/store/lbg51ad23fp916qz2khbc786vj4yhpah-hello.drv'...
warning: you did not specify '--add-root'; the result might be removed by the garbage collector
/nix/store/a89s0rsafrdc037lha4jkd4dhbkdis0l-hello
```
If we print the content of the file:
```console
[jd@jd-nixos:~/nix-derivation-tutorial]$ cat /nix/store/a89s0rsafrdc037lha4jkd4dhbkdis0l-hello
hello world
```
Tip: We can also use ```nix-build``` directly on myDerivation.nix to build our derivation.

## Nix Shell

To quote [the Nix reference manual](https://nixos.org/manual/nix/stable/command-ref/nix-shell):
> The command nix-shell will build the dependencies of the specified derivation, but not the derivation itself. It will then start an interactive shell in which all environment variables defined by the derivation path have been set to their corresponding values, and the script $stdenv/setup has been sourced. This is useful for reproducing the environment of a derivation for development."

The ```nix-shell``` command can be both applied to a .drv file as well as a .nix file that calls the nix ```derivation``` function.

### Simple Example:
```console
[jd@jd-nixos:~/nix-derivation-tutorial]$ nix-shell myDerivation.nix

[nix-shell:~/nix-derivation-tutorial]$ echo $builder
/nix/store/r9h133c9m8f6jnlsqzwf89zg9w0w78s8-bash-5.2-p15/bin/bash

[nix-shell:~/nix-derivation-tutorial]$ echo $inputDrvs
/nix/store/r9h133c9m8f6jnlsqzwf89zg9w0w78s8-bash-5.2-p15

[nix-shell:~/nix-derivation-tutorial]$ echo $name
hello

[nix-shell:~/nix-derivation-tutorial]$ echo $out
/nix/store/a89s0rsafrdc037lha4jkd4dhbkdis0l-hello

[nix-shell:~/nix-derivation-tutorial]$ echo $system
x86_64-linux

[nix-shell:~/nix-derivation-tutorial]$ $builder

\[\][\[\]jd@jd-nixos:~/nix-derivation-tutorial]$\[\] echo weirdshell
weirdshell
```
As you can see we can now access all the variables defined in the "env" key of the derivation file.
Including execution of the builder (bash).

# Putting It All Together

Consider the ```rustEnv``` directory.
The file ```rustShell.nix``` is a derivation to compile a rust programm (hello world).
It has the following content:
```nix
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
```
Now the paths we pass here for args, setup and stdenv as well as src are not actual paths (which would be passed as a string).
These mean that those files will be put into the nix store and then the actual path to those store items will be used as the arguments.

Now the builder is bash and will simply run ```builder.sh```.
```builder.sh``` has the following contents:
```bash
source $setup
cd $src
cargo build --target-dir $out
```
and ```setup.sh`` (which is what is being sourced here) has the content:
```bash
unset PATH
for p in $inputDrvs; do
  export PATH=$p/bin${PATH:+:}$PATH
done
```
This simply deleted the path and adds all the binaries from the built ```inputDrvs``` to the path.
This is why we can run ```cargo``` using the ```cargo```command in ```builder.sh```.

We can also use ```rustShell.nix``` to get into a shell will all the ```inputDrvs``` binaries on the path and nothing else by using ```nix-shell```.
Before giving us the shell ```nix-shell``` will run build the input derivations and
source ```$stdenv/setup```.
Now the file ```myStdEnv/setup``` is simply:
```bash
source $setup
echo "stdenv setup sourced"
```
So
```console
[jd@jd-nixos:~/nix-derivation-tutorial/rustEnv]$ nix-shell rustShell.nix
stdenv setup sourced
```
will drop us into a shell that has  all the (specific) ```inputDrvs``` binaries on path and nothing else! Perfect for development even when we dont want to build our app with Nix.
