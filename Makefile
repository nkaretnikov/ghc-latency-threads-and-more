.PHONY: nix_files shell build test clean tags

# Generate .nix files from a .cabal file.
nix_files:
	cabal2nix ./. > default.nix
	cabal2nix --shell ./. > shell.nix

# Create a shell with dependencies.
shell:
	nix-shell

build:
	cabal build

test:
	cabal test

clean:
	cabal clean

tags:
	hasktags -c src
