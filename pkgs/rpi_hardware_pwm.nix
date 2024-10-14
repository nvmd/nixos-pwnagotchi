{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "rpi_hardware_pwm";
  version = "0.2.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Pioreactor";
    repo = pname;
    rev = "${version}";
    hash = "sha256-CbvN6IudpaqTgZhw9CrDgrt/makBlNrAPAfG2yBi3bk=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];
}