{ lib, python3Packages, pythonOlder, fetchPypi, pytestCheckHook }:

python3Packages.buildPythonPackage rec {
  pname = "inky";
  version = "2.0.0";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash  = "sha256-Yugm/Lc8lXggnHiNz1hXZE894scHQ/+5H3/oaRI+KJU=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-fancy-pypi-readme
    hatch-requirements-txt
  ];

  dependencies = with python3Packages; [
    numpy
    pillow
    smbus2
    spidev
    gpiodevice  # >=0.0.3 https://pypi.org/project/gpiodevice/
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
}