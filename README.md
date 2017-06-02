# Haskell Shell Helpers

Sure, this could also be done with a simple bash alias.

But is your bash alias type-checked?

## Building and Running

```bash
stack build && stack exec hsh
```

## Build the Executable using Stack within Docker

```bash
$ docker run -v ${HOME}/.stack:/root/.stack -v ${HOME}/.local/bin:/root/.local/bin -v /path/to/repo/dir/hsh:/hsh  -it --rm haskell:7.10.3 /bin/bash
$ cd /hsh
$ stack config set system-ghc --global true
$ stack install
```

This will copy the `hsh` executable to `~/.local/bin`
