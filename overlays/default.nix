self: super: { # final: prev:
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

  ### https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/security/bettercap/default.nix#L31
  #     bettercap:
  #       source: "https://github.com/jayofelony/bettercap.git"
  #       url: "https://github.com/jayofelony/bettercap/releases/download/2.32.4/bettercap-2.32.4.zip"
  #       branch: "lite" # or master
  # - name: download bettercap
  #   git:
  #     repo: "{{ packages.bettercap.source }}"
  #     version: "{{ packages.bettercap.branch }}"
  #     dest: /usr/local/src/bettercap

  # - name: install bettercap 2.32.4
  #   shell: "export GOPATH=$HOME/go && export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin && go mod tidy && make && make install"
  #   args:
  #     executable: /bin/bash
  #     chdir: /usr/local/src/bettercap

  # - name: remove bettercap folder
  #   file:
  #     state: absent
  #     path: /usr/local/src/bettercap

  # #- name: download and install bettercap
  # #  unarchive:
  # #    src: "{{ packages.bettercap.url }}"
  # #    dest: /usr/local/bin
  # #    remote_src: yes
  # #    exclude:
  # #      - README.md
  # #      - LICENSE.md
  # #    mode: 0755



  pwngrid = super.callPackage ../pkgs/pwngrid.nix {};



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
  


  ### https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/libraries/libpcap/default.nix#L65
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

  # - name: remove libpcap build folder
  #   file:
  #     state: absent
  #     path: /usr/local/src/libpcap

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