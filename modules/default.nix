{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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