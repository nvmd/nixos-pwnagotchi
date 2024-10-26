# https://github.com/NixOS/nixpkgs/blob/4db088d36ac05da15348ffd56b3e90c3169d4bba/pkgs/development/libraries/libpcap/default.nix
{ lib, stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation rec {
  pname = "libpcap";
  version = "1.9.1";

  src = fetchurl {
    url = "https://www.tcpdump.org/release/${pname}-${version}.tar.gz";
    hash = "sha256-Y1I3Y3xbYZvM66kZAGZrZNVuy3vmPymPYB7Hhs4IcJQ=";
  };

  nativeBuildInputs = [ flex bison ];

  # We need to force the autodetection because detection doesn't
  # work in pure build enviroments.
  configureFlags = [
    "--with-pcap=${if stdenv.hostPlatform.isLinux then "linux" else "bpf"}"
  ] ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
    "ac_cv_linux_vers=2"
  ];

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace " -arch i386" ""
  '';

  meta = with lib; {
    homepage = "https://www.tcpdump.org";
    description = "Packet Capture Library";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.bsd3;
  };
}
