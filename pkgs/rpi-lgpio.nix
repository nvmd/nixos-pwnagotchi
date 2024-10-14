{ lib, python3Packages, pythonOlder, fetchPypi }:

python3Packages.buildPythonPackage rec {
  pname = "rpi_lgpio";
  version = "0.6";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash  = "sha256-hFebEdVDu4q93cHhD81r3CgZ5Yl75y1pSaKwRNcftz4=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    lgpio # https://pypi.org/project/lgpio
  ];

  meta = with lib; {
    platforms = platforms.linux;
  };
}