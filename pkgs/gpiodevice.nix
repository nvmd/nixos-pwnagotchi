{ lib, python3Packages, pythonOlder, fetchPypi }:

python3Packages.buildPythonPackage rec {
  pname = "gpiodevice";
  version = "0.0.5";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchPypi { # https://pypi.org/project/gpiodevice/
    inherit pname version;
    hash  = "sha256-zKAf9DGeC6kG/0bcuBE9jVMrP17gPWg9ihEDfI6JFAw=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = with python3Packages; [
    libgpiod  # https://pypi.org/project/gpiod
  ];

  meta = with lib; {
    homepage = "https://github.com/pimoroni/gpiodevice-python";
    license = licenses.mit;
    maintainers = with maintainers; [ kazenyuk ];
  };
}