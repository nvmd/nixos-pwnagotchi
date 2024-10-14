self: super: { # final: prev:

  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (python-self: python-super: {
      gpiodevice = python-self.callPackage ../pkgs/gpiodevice.nix {};
      inky = python-self.callPackage ../pkgs/inky.nix {};
      lgpio = python-self.callPackage ../pkgs/lgpio.nix {};
      rpi_lgpio = python-self.callPackage ../pkgs/rpi-lgpio.nix {};
      rpi_hardware_pwm = python-self.callPackage ../pkgs/rpi_hardware_pwm.nix {};
      stable_baselines3 = python-self.callPackage ../pkgs/stable_baselines3.nix {};

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

  python3 = let
    mypython = super.python3.override {
      # enableOptimizations = true;
      # reproducibleBuild = false;
      self = mypython;
    };
  in mypython;


  # https://github.com/jayofelony/pwnagotchi/blob/master/builder/raspberrypi64.yml
  # https://raw.githubusercontent.com/jayofelony/pwnagotchi/refs/heads/master/builder/raspberrypi64.yml



  ### about caplets in a comment: https://github.com/NixOS/nixpkgs/pull/120150#pullrequestreview-641957684
  # packages:
  #     caplets:
  #       source: "https://github.com/jayofelony/caplets.git"
  #       branch: "lite" # or master
    # - name: clone bettercap caplets
    #   git:
    #     repo: "{{ packages.caplets.source }}"
    #     version: "{{ packages.caplets.branch }}"
    #     dest: /tmp/caplets
    #   register: capletsgit

    # - name: install bettercap caplets
    #   make:
    #     chdir: /tmp/caplets
    #     target: install
    #   when: capletsgit.changed


  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/security/bettercap/default.nix#L31
  bettercap = super.bettercap.overrideAttrs (old: rec {
    pname = old.pname + "-pwn";
    version = "2.32.4";
    src = super.fetchFromGitHub { # https://github.com/jayofelony/bettercap.git
      owner = "jayofelony";
      repo = old.pname;
      rev = "v${version}";  # or follow `branch: "lite" # or master`?
      sha256 = "sha256-bup6f0VljnqZkYBzDUzN9Xm0OA3b7/+bd383HT6vT7M=";
    };

    vendorHash = "sha256-M6tgjYE5xF5uykCVyg7F6xKTvF0hdfJYic+xej98mpM=";
  });


  pwngrid = super.callPackage ../pkgs/pwngrid.nix {};

  pwnagotchi = super.callPackage ../pkgs/pwnagotchi.nix {};

  ### https://github.com/jayofelony/pwnagotchi/tree/master/pwnagotchi
  # pwnagotchi
  # - name: create /etc/pwnagotchi folder
  #   file:
  #     path: /etc/pwnagotchi
  #     state: directory

  # - name: check if user configuration exists
  #   stat:
  #     path: /etc/pwnagotchi/config.toml
  #   register: user_config

  # - name: create /etc/pwnagotchi/config.toml
  #   copy:
  #     dest: /etc/pwnagotchi/config.toml
  #     content: |
  #       # Add your configuration overrides on this file any configuration changes done to default.toml will be lost!
  #       # Example:
  #       # ui.display.enabled = true
  #       # ui.display.type = "waveshare_4"
  #   when: not user_config.stat.exists
  # - name: Create custom config directory
  #     file:
  #       path: /etc/pwnagotchi/conf.d/
  #       state: directory

  #   - name: create /usr/local/share/pwnagotchi/ folder
  #     file:
  #       path: /usr/local/share/pwnagotchi/
  #       state: directory

  #   - name: Create custom plugin directory
  #     file:
  #       path: /usr/local/share/pwnagotchi/custom-plugins/
  #       state: directory
  

  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/libraries/libpcap/default.nix#L65
  libpcap = super.libpcap.overrideAttrs (old: rec {
    version = "1.9.1";
    src = super.fetchurl {
      url = "https://www.tcpdump.org/release/${old.pname}-${version}.tar.gz";
      hash = "sha256-Y1I3Y3xbYZvM66kZAGZrZNVuy3vmPymPYB7Hhs4IcJQ=";
    };
  });
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



  # Installing nexmon
  # - name: clone nexmon repository
  #   git:
  #     repo: https://github.com/DrSchottky/nexmon.git
  #     dest: /usr/local/src/nexmon

}