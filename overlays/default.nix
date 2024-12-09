self: super: { # final: prev:

  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/security/bettercap/default.nix#L31
  # bettercap = super.bettercap.overrideAttrs (old: rec {
  #   pname = old.pname + "-pwn";
  #   version = "2.32.4";
  #   src = super.fetchFromGitHub { # https://github.com/jayofelony/bettercap.git
  #     owner = "jayofelony";
  #     repo = old.pname;
  #     rev = "v${version}";  # or follow `branch: "lite" # or master`?
  #     sha256 = "sha256-bup6f0VljnqZkYBzDUzN9Xm0OA3b7/+bd383HT6vT7M=";
  #   };

  #   vendorHash = "sha256-M6tgjYE5xF5uykCVyg7F6xKTvF0hdfJYic+xej98mpM=";
  # });

  bettercap = super.bettercap.overrideAttrs (old: rec {
    version = "2.40.0";
    src = super.fetchFromGitHub { # https://github.com/bettercap/bettercap
      owner = "bettercap";
      repo = old.pname;
      fetchSubmodules = true;
      rev = "v${version}";
      sha256 = "sha256-w08+KmEJrlnfn14sszHo6essekti4fRc04uI5VnG4Kw=";
    };

    vendorHash = "sha256-3pPINT1rDvjSXqIX37YW50x650BuKtvwS1ufkXKM/64=";
  });

  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/libraries/libpcap/default.nix#L65
  # libpcap = super.libpcap.overrideAttrs (old: rec {
  #   version = "1.9.1";
  #   src = super.fetchurl {
  #     url = "https://www.tcpdump.org/release/${old.pname}-${version}.tar.gz";
  #     hash = "sha256-Y1I3Y3xbYZvM66kZAGZrZNVuy3vmPymPYB7Hhs4IcJQ=";
  #   };
  #   # preBuild = ''
  #   #   makeFlagsArray+=(
  #   #     INCLUDE=$(pkg-config --cflags libnl-genl-3.0)
  #   #   )
  #   # '';
  #   patchPhase = ''
  #     substituteInPlace CMakeLists.txt \
  #       --replace "include_directories("/usr/include/libnl3")" \
  #                 "kdfjkdjf"
  #   '';
  #   buildInputs = old.buildInputs
  #     ++ super.lib.optionals super.stdenv.hostPlatform.isLinux [
  #       # self.libnfnetlink
  #       # self.libnetfilter_queue
  #       self.libnl.dev
  #       # self.libnftnl
  #     ];
  # });
  # libpcap = super.callPackage ../pkgs/libpcap-1.9.1.nix {};
  # install libpcap before bettercap and pwngrid, so they use it
  # - name: clone libpcap v1.9 from github
  #   git:
  #     repo: 'https://github.com/the-tcpdump-group/libpcap.git'
  #     dest: /usr/local/src/libpcap
  #     version: libpcap-1.9
  # - name: build and install libpcap into /usr/local/lib
  #   shell: "./configure && make && make install"
  #   args:
  #     executable: /bin/bash
  #     chdir: /usr/local/src/libpcap
  # - name: create symlink /usr/local/lib/libpcap.so.1.9.1
  #   file:
  #     src: /usr/local/lib/libpcap.so.1.9.1
  #     dest: /usr/local/lib/libpcap.so.0.8
  #     state: link

  lgpio = super.callPackage ../pkgs/lgpio.nix {};

  nexmon = super.callPackage ../pkgs/nexmon.nix {};

  pwngrid = super.callPackage ../pkgs/pwngrid.nix {};

  pwnagotchi = super.python311.pkgs.callPackage ../pkgs/pwnagotchi.nix {};

  # python3Packages = self.python3.pkgs;
  # python3 = let
  #   mypython = self.python311.override {
  #     # enableOptimizations = true;
  #     # reproducibleBuild = false;
  #     self = mypython;
  #   };
  # in mypython;

  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (python-self: python-super: {
      gpiodevice = python-self.callPackage ../pkgs/gpiodevice.nix {};
      inky = python-self.callPackage ../pkgs/inky.nix {};
      lgpio = python-self.callPackage ../pkgs/py-lgpio.nix {
        pkgsLibgpio = self.lgpio; # Needs the C library
      };
      rpi_lgpio = python-self.callPackage ../pkgs/rpi-lgpio.nix {};
      rpi_hardware_pwm = python-self.callPackage ../pkgs/rpi_hardware_pwm.nix {};

      rlcard = python-super.rlcard.overridePythonAttrs (oldAttrs: {
        # https://github.com/datamllab/rlcard/pull/323
        patchPhase = ''
          substituteInPlace rlcard/agents/__init__.py \
            --replace "from distutils.version import LooseVersion" " "
        '';
        meta.broken = false;
      });
    })
  ];

}