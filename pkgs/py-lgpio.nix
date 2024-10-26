{ lib
, python3Packages
, fetchPypi
, swig
, pkgsLibgpio
}:

python3Packages.buildPythonPackage rec {
  pname = "lgpio";
  version = "0.2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash  = "sha256-ETcuZTsgD3ags++KI6BzXIXsZ4qfhVC5iTFR7Q+GP/8=";
  };

  build-system = with python3Packages; [
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