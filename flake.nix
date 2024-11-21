{
  description = "Declarative pwnagotchi built with NixOS";

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
    connect-timeout = 5;
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";
  };

  outputs = { self, nixpkgs, nixos-raspberrypi, ... }@inputs: let
    # rpiSystems = [ "aarch64-linux" "armv7l-linux" "armv6l-linux" ];
    allSystems = nixpkgs.lib.systems.flakeExposed;
    forSystems = systems: f: nixpkgs.lib.genAttrs systems (system: f system);
  in {

    devShells = forSystems allSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        name = "nixos-pwnagotchi";
        nativeBuildInputs = with pkgs; [
          nil # lsp language server for nix
          nixpkgs-fmt
          nix-output-monitor
          bash-language-server
          shellcheck
        ];
      };
    });

    nixosModules = {
      default = import ./modules/default.nix;
    };

    nixosConfigurations = let
      system = "aarch64-linux";
    in {
      pwnagotchi = nixos-raspberrypi.inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs // { inherit system; };
        modules = [
          ({ config, pkgs, ... }: {
            hardware.raspberry-pi.config.pi02 = {
              # https://github.com/NixOS/nixpkgs/issues/216886#issuecomment-1435758905
              # Give up VRAM for more Free System Memory
              options = {
                # - Disable camera which automatically reserves 128MB VRAM
                start_x = {
                  enable = true;
                  value = 0;
                };
                # - Reduce allocation of VRAM to 16MB minimum for non-rotated (32MB for rotated)
                gpu_mem = {
                  enable = true;
                  value = 0;
                };
              };
            };
          })
          ({ config, pkgs, ... }: { # ethernet "gadget" mode
            boot.kernel.sysctl = {
              # In case networkd/... won't remove the gadget route when it isn't connected
              # https://github.com/charkster/rpi_gadget_mode
              # https://www.marcusfolkesson.se/til/ignore_routes_with_linkdown/
              "net.ipv4.conf.all.ignore_routes_with_linkdown" = 1;
            };
            networking.interfaces.usb0.ipv4.addresses = [ {
              address = "10.0.0.2";
              prefixLength = 24;
            } ];
            boot.kernelModules = [ "dwc2" "g_ether" ];  # modules-load=dwc2,g_ether
            hardware.raspberry-pi.config.all.dt-overlays = {
              dwc2 = {
                enable = true;
                params = {};
              };
            };
          })

          ({ config, pkgs, lib, ... }: {
            nixpkgs.overlays = [ self.overlays.default ];

            networking.hostName = "pwnagotchi";
            boot.loader.grub.enable = false;
          })
          self.nixosModules.default

          nixos-raspberrypi.lib.inject-overlays-global
          nixos-raspberrypi.lib.inject-overlays
        ] ++ (with nixos-raspberrypi.nixosModules; [
          raspberry-pi-4.base
          sd-image
        ]);
      };
    };

    overlays = {
      default = import ./overlays/default.nix;
    };

    packages = forSystems allSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nixos-raspberrypi.overlays.vendor-firmware
          nixos-raspberrypi.overlays.vendor-kernel

          nixos-raspberrypi.overlays.kernel-and-firmware

          self.overlays.default
        ];
      };
    in {

      bettercap = pkgs.bettercap;
      libpcap = pkgs.libpcap;

      pwngrid = pkgs.pwngrid;
      pwnagotchi = pkgs.pwnagotchi;

      lgpio = pkgs.lgpio;

      nexmon = pkgs.nexmon;
      nexmon-kmod = let
        targetKernel = pkgs.linux_rpi4_v6_6_51;
      in (pkgs.linuxPackagesFor targetKernel).callPackage ./pkgs/nexmon-kmod.nix {};

    });

  };
}
