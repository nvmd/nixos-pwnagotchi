{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hatchling
, hatch-fancy-pypi-readme
, libgpiod
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "gpiodevice";
  version = "0.0.5";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchPypi { # https://pypi.org/project/gpiodevice/
    inherit pname version;
    hash  = "sha256-zKAf9DGeC6kG/0bcuBE9jVMrP17gPWg9ihEDfI6JFAw=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    libgpiod  # https://pypi.org/project/gpiod
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  meta = with lib; {
    homepage = "https://github.com/pimoroni/gpiodevice-python";
    license = licenses.mit;
    maintainers = with maintainers; [ kazenyuk ];
  };
}