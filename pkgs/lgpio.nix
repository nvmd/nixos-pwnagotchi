{ lib
, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation {
  pname = "lgpio";
  version = "0.2.2.0";

  src = fetchurl {
    url = "http://abyz.me.uk/lg/lg.zip";
    hash = "sha256-uzHGAxtjKRGky70dR+oybxJJufnv4VBOyoPR4O8DlK8=";
  };

  nativeBuildInputs = [ unzip ];

  makeFlags = [
    "prefix=/"
    "DESTDIR=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://abyz.me.uk/lg/index.html";
    description = "an archive of programs for Linux Single Board Computers which allows control of the General Purpose Input Outputs.";
    platforms = platforms.linux;
    maintainers = with maintainers; [ kazenyuk ];
    license = licenses.unlicense;
  };
}
