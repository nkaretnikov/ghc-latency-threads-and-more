FILE=
EVENTLOG=0


.PHONY: nix_files shell build run test clean tags

# Generate .nix files from a .cabal file.
nix_files:
	cabal2nix ./. > default.nix
	cabal2nix --shell ./. > shell.nix

# Create a shell with dependencies.
shell:
	nix-shell

build:
ifeq ("${EVENTLOG}","1")
	cabal configure -f eventlog
else
	cabal configure
endif
	cabal build

run:
ifeq ("${EVENTLOG}","1")
	dist/build/${FILE}/${FILE} +RTS -N2 -la
else
	dist/build/${FILE}/${FILE} +RTS -N2
endif

test:
	cabal test

clean:
	cabal clean

tags:
	hasktags -c src
