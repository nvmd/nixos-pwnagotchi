{ lib, fetchFromGitHub, buildPythonApplication, pythonOlder
# build-system
, setuptools
# dependencies
, dbus-python
, file-read-backwards
, flask
, flask-cors
, flask-wtf
, gast
, gpiozero
, inky  # https://pypi.org/project/inky/
, pillow # Pillow
, pycryptodome
, pydrive2
, python-dateutil
, pyyaml # PyYAML
, requests
, rpi_hardware_pwm  # https://pypi.org/project/rpi-hardware-pwm/
, rpi_lgpio # rpi.lgpio # https://pypi.org/project/rpi-lgpio/
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
# , smbus
}:

buildPythonApplication rec {
  pname = "pwnagotchi";
  version = "2.9.3";

  disabled = pythonOlder "3.11";

  pyproject = true;

  src = fetchFromGitHub { # https://github.com/nvmd/pwnagotchi/
    owner = "nvmd";
    repo = pname;
    rev = "ad96cd41aedeeb2f0c4ae9bc586c697430c1e5bc"; # yesai
    sha256 = "sha256-aSjiQZvZmPAGNoHoKkc1t5Y82aMnzBC5NJENqHf3oCk=";
  };

  # src = fetchFromGitHub { # https://github.com/jayofelony/pwnagotchi/
  #   owner = "jayofelony";
  #   repo = pname;
  #   rev = "v${version}";  # version = "2.8.9";
  #   sha256 = "sha256-eNbQSjTx0eO4hUi8eJWIU/U9UBsKLk+yfF0iwhceVsk=";
  # };

  patchPhase = ''
    # remove smbus, because smbus2 should be enough
    substituteInPlace pyproject.toml \
      --replace "\"smbus\"," " "
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    dbus-python
    file-read-backwards
    flask
    flask-cors
    flask-wtf
    gast
    gpiozero
    inky  # https://pypi.org/project/inky/
    pillow # Pillow
    pycryptodome
    pydrive2
    python-dateutil
    pyyaml # PyYAML
    requests
    rpi_hardware_pwm  # https://pypi.org/project/rpi-hardware-pwm/
    rpi_lgpio # rpi.lgpio # https://pypi.org/project/rpi-lgpio/
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