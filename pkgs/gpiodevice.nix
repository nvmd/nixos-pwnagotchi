{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonPackage rec {
  pname = "gpiodevice";
  version = "0.0.5";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash  = "sha256-Yugm/Lc8lXggnHiNz1hXZE894scHQ/+5H3/oaRI+KJ0=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    libgpiod  # https://pypi.org/project/gpiod
  ];
}