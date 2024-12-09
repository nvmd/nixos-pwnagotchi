{ lib, fetchFromGitHub, buildPythonApplication, pythonOlder
# build-system
, setuptools
# dependencies
, pillow # Pillow
, pyyaml # PyYAML
, rpi_lgpio # rpi.lgpio # https://pypi.org/project/rpi-lgpio/
, dbus-python
, file-read-backwards
, flask
, flask-cors
, flask-wtf
, gast
, gpiozero
, inky  # https://pypi.org/project/inky/
, pycryptodome
, pydrive2
, python-dateutil
, requests
, rpi_hardware_pwm  # https://pypi.org/project/rpi-hardware-pwm/
, scapy
, shimmy
, smbus2
, spidev
, stable-baselines3 # https://pypi.org/project/stable-baselines3/
, toml
, torch
, torchvision
, tweepy
, websockets
# pythonRuntimeDepsCheck
, gym
, rpi-gpio
# # smbus
}:

buildPythonApplication rec {
  pname = "pwnagotchi";
  version = "2.9.2";

  disabled = pythonOlder "3.11";

  # https://github.com/jayofelony/pwnagotchi/blob/master/pyproject.toml
  pyproject = true;

  src = fetchFromGitHub { # https://github.com/jayofelony/pwnagotchi/
    owner = "nvmd";
    repo = pname;
    # rev = "v${version}";
    rev = "ad96cd41aedeeb2f0c4ae9bc586c697430c1e5bc";
    sha256 = "sha256-aSjiQZvZmPAGNoHoKkc1t5Y82aMnzBC5NJENqHf3oCk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pillow # Pillow
    pyyaml # PyYAML
    rpi_lgpio # rpi.lgpio # https://pypi.org/project/rpi-lgpio/
    dbus-python
    file-read-backwards
    flask
    flask-cors
    flask-wtf
    gast
    gpiozero
    inky  # https://pypi.org/project/inky/
    pycryptodome
    pydrive2
    python-dateutil
    requests
    rpi_hardware_pwm  # https://pypi.org/project/rpi-hardware-pwm/
    scapy
    shimmy
    smbus2
    spidev
    stable-baselines3 # https://pypi.org/project/stable-baselines3/
    toml
    torch
    torchvision
    tweepy
    websockets

    # pythonRuntimeDepsCheck
    gym
    rpi-gpio
    # smbus
  ];

  meta = with lib; {
    description = "pwnagotchi, (⌐■_■) - Deep Reinforcement Learning instrumenting bettercap for WiFI pwning";
    mainProgram = "pwnagotchi";
    homepage = "https://github.com/jayofelony/pwnagotchi";
    changelog = "https://github.com/jayofelony/pwnagotchi/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kazenyuk ];
    platforms = platforms.linux;
  };
}