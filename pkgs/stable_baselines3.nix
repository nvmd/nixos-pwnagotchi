{ lib
, python3Packages
, pythonOlder
, fetchPypi
, pytestCheckHook
# test dependencies
, tqdm
, rich 
}:

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

  nativeCheckInputs = [
    pytestCheckHook
    tqdm
    rich
  ];

  disabledTestPaths = [
    # test_load_invalid_object needs to write to filesystem
    # Failed: DID NOT WARN. No warnings of type (<class 'UserWarning'>,) were emitted.
    "tests/test_save_load.py"
    # depends on atari rom files (AutoROM.accept-rom-license)
    "tests/test_utils.py"
  ];
}