{ stdenv, lib, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation (finalAttrs: {
  pname = "nexmon-kmod";
  version = "unstable-2024-06-03";

  src = fetchFromGitHub {
    owner = "DrSchottky";
    repo = "nexmon";
    rev = "bb9ce8c78840315a21519dec9534f2886cb36002";
    sha256 = "sha256-i72b+7OzU7glmJtNkfD741mvyDoUFgWuIFTr+OZzAqs=";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  configurePhase = ''
    export NEXMON_ROOT=$(pwd)
    export KERNEL_MODULE_SRC=$NEXMON_ROOT/patches/driver/brcmfmac_${lib.versions.majorMinor kernel.modDirVersion}.y-nexmon
  '';

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];
  KSRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  buildPhase = ''
    make $makeFlags -C ${finalAttrs.KSRC} M="$KERNEL_MODULE_SRC"
  '';

  installPhase = ''
    runHook preInstall
    install -vD "$KERNEL_MODULE_SRC/brcmfmac.ko" -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Nexmon kernel module - patched brcmfmac driver";
    homepage = "https://github.com/DrSchottky/nexmon.git";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kazenyuk ];
    platforms = platforms.linux;
  };
})