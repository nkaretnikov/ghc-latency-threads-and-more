FILE=
.PHONY: nix_files shell build test clean tags

# Generate .nix files from a .cabal file.
nix_files:
	cabal2nix ./. > default.nix
	cabal2nix --shell ./. > shell.nix

# Create a shell with dependencies.
shell:
	nix-shell

build:
	cabal configure
	cabal build

build_eventlog:
	cabal configure -f eventlog
	cabal build

run:
	dist/build/${FILE}/${FILE} +RTS -N2

run_eventlog:
	dist/build/${FILE}/${FILE} +RTS -N2 -la

test:
	cabal test

clean:
	cabal clean

tags:
	hasktags -c src
