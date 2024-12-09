{ lib, stdenv
, fetchFromGitHub
, gmp
, xxd
, bison
, flex
, coreutils
, bash
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nexmon";
  version = "unstable-2024-06-03";

  src = fetchFromGitHub { # https://github.com/DrSchottky/nexmon.git
    owner = "DrSchottky";
    repo = "nexmon";
    rev = "bb9ce8c78840315a21519dec9534f2886cb36002";
    sha256 = "sha256-i72b+7OzU7glmJtNkfD741mvyDoUFgWuIFTr+OZzAqs=";
  };

  nativeBuildInputs = [
    xxd
    bison
    coreutils # /bin/true
  ];
  buildInputs = [
    flex
    gmp
  ];

  makeFlags = [
    "GIT_VERSION=${builtins.substring 0 7 finalAttrs.src.rev}"
  ];

  patchPhase = ''
    substituteInPlace setup_env.sh \
      --replace-quiet "export CC=arm-none-eabi-" "export CC="
    substituteInPlace \
      buildtools/gcc-nexmon-plugin/Makefile \
      buildtools/gcc-nexmon-plugin-arm/Makefile \
      --replace-quiet "arm-none-eabi-g++" "g++"

    find . -type f -name 'Makefile' \
      -exec sed -i 's#-mthumb# #' {} \;

    substituteInPlace \
      buildtools/b43/assembler/Makefile \
      --replace-warn "LDFLAGS		+= -ll" "LDFLAGS		+= -lfl"


    # GIT_VERSION := $(shell git describe --abbrev=4 --dirty --always --tags)
    # substituteInPlace Makefile.am \
    #   --replace 'GIT_VERSION :=' 'GIT_VERSION ?='

    find . -type f -exec sed -i 's#$(shell git describe --abbrev=4 --dirty --always --tags)#${builtins.substring 0 7 finalAttrs.src.rev}#' {} \;

    find . -type f -name 'Makefile' \
      -exec sed -i 's#/bin/true#${coreutils}/bin/true#' {} \;
    find . -type f -name 'Makefile' \
      -exec sed -i 's#/bin/bash#${bash}/bin/bash#' {} \;
    find . -type f -name 'Makefile' \
      -exec sed -i 's#\$(shell which bash)#${bash}/bin/bash#' {} \;
  '';

  # postPatch = ''
  #   patchShebangs .
  #   substituteInPlace Makefile --replace 'SHELL=/bin/bash' 'SHELL=${builtins.getEnv "SHELL"}'
  # '';

  buildPhase = ''
    export NEXMON_ROOT=$(pwd)

    source setup_env.sh
    make V=1

    declare -a fws=(
      # Raspberry Pi 3 and Zero W, Raspbian Stretch
      # "bcm43430a1/7_45_41_46"

      # Raspberry Pi B3+/B4, Raspberry Pi OS Kernel 5.4
      # PWN: RPi4, RPi5
      # "bcm43455c0/7_45_206"

      # Raspberry Pi B3+/B4/5, Raspberry Pi OS
      # "bcm43455c0/7_45_234_4ca95bb_CY"

      # Raspberry Pi Zero 2 W, Raspberry Pi OS Kernel 5.10
      # PWN: RPi02, RPi3
      "bcm43436b0/9_88_4_65"

      # Raspberry Pi Pico W, Pico SDK
      # "bcm43439a0/7_95_49_2271bb6"
    )

    for fw in "''${fws[@]}"; do
      echo Building $fw...

      cd "$NEXMON_ROOT"/patches/"$fw"/nexmon
      make V=1

      local target=$out/firmware/brcm/"$fw"
      mkdir -p $target
      cp ./*.bin $target || true
      cp ./*.h $target || true
    done
  '';

  installPhase = ''
    runHook preInstall

    # make install-firmware

    runHook postInstall
  '';

  meta = with lib; {
    description = "";
    homepage = "https://github.com/DrSchottky/nexmon.git";
    license = licenses.gpl3Only;
    # platforms = platforms.linux;
    maintainers = with maintainers; [ kazenyuk ];
  };
})