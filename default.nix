{ mkDerivation, base, ghc-events, network, stdenv, time }:
mkDerivation {
  pname = "ghc-latency-threads-and-more";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base ghc-events network time ];
  license = stdenv.lib.licenses.publicDomain;
}
