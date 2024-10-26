{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "pwnagotchi";
  version = "2.8.9";

  disabled = python3Packages.pythonOlder "3.10";

  # https://github.com/jayofelony/pwnagotchi/blob/master/pyproject.toml
  pyproject = true;

  src = fetchFromGitHub { # https://github.com/jayofelony/pwnagotchi/
    owner = "jayofelony";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eNbQSjTx0eO4hUi8eJWIU/U9UBsKLk+yfF0iwhceVsk=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
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
    stable_baselines3 # https://pypi.org/project/stable-baselines3/
    toml
    torch
    torchvision
    tweepy
    websockets

    # pythonRuntimeDepsCheck
    gym
    rpi-gpio
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