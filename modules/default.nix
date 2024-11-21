{ config, lib, pkgs, ... }:

{
  # https://github.com/jayofelony/pwnagotchi/blob/master/builder/raspberrypi64.yml
  # https://raw.githubusercontent.com/jayofelony/pwnagotchi/refs/heads/master/builder/raspberrypi64.yml


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

  environment.systemPackages = with pkgs; [
    pwnagotchi
    pwngrid

    bettercap
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


    # nexmon
    # Installing nexmon
    # - name: clone nexmon repository
    #   git:
    #     repo: https://github.com/DrSchottky/nexmon.git
    #     dest: /usr/local/src/nexmon

    hcxtools
    ### https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/security/hcxtools/default.nix#L22
    # install latest hcxtools
    # - name: clone hcxtools
    #   git:
    #     repo: https://github.com/ZerBea/hcxtools.git
    #     dest: /usr/local/src/hcxtools

    # - name: install hcxtools
    #   shell: "make && make install"
    #   args:
    #     executable: /bin/bash
    #     chdir: /usr/local/src/hcxtools
  ];
}