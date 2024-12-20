{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, swig
, pkgsLibgpio
}:

buildPythonPackage rec {
  pname = "lgpio";
  version = "0.2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash  = "sha256-ETcuZTsgD3ags++KI6BzXIXsZ4qfhVC5iTFR7Q+GP/8=";
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [ swig ];
  buildInputs = [ pkgsLibgpio ];

  propagatedBuildInputs = [
    pkgsLibgpio
  ];

  meta = with lib; {
    platforms = platforms.linux;
  };
}