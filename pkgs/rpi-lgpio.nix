{ lib, buildPythonPackage, pythonOlder, fetchPypi
, setuptools
, lgpio
}:

buildPythonPackage rec {
  pname = "rpi_lgpio";
  version = "0.6";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash  = "sha256-hFebEdVDu4q93cHhD81r3CgZ5Yl75y1pSaKwRNcftz4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    lgpio # https://pypi.org/project/lgpio
  ];

  meta = with lib; {
    platforms = platforms.linux;
  };
}