# Haskell Shell Helpers

Sure, this could also be done with a simple bash alias.

But is your bash alias type-checked?

## Building and Running

```bash
stack build && stack exec hsh
```

## Build the Executable using Stack within Docker

```bash
$ docker run -v ~/.stack:/root/.stack -v ~/.local/bin:/root/.local/bin -v /path/to/hsh:/hsh -it --rm haskell:8.0.1 /bin/bash
$ cd /hsh
$ stack config set system-ghc --global true
$ stack install --allow-different-user
```

This will copy the `hsh` executable to `~/.local/bin`
