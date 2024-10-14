{ lib, python3Packages, pythonOlder, fetchPypi }:

python3Packages.buildPythonPackage rec {
  pname = "stable_baselines3";
  version = "2.3.2";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash  = "sha256-L4GIkW5gdXHEwk+Iqf9vhO2vss8i1dJPnBmVY8Ev8Wg=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    gymnasium
    numpy
    torch
    cloudpickle
    pandas
    matplotlib
  ];
}