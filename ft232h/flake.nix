{
  description = "Nix flake: Adafruit FT232H dev environment for CircuitPython Blinka (I2C/SPI/GPIO over USB)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      nixpkgs,
      flake-utils,
    }:
    {
      templates.default = {
        path = ./.;
        description = "CircuitPython Blinka with FT232H (USB→I2C/SPI/GPIO)";
        welcomeText = ''
          FT232H Blinka environment created.

          Quick start:
            nix develop
            make venv install          # create .venv and install deps
            make scan-i2c              # run I2C bus scan example

          Notes:
            - Exports BLINKA_FT232H=1 in shell
            - Includes libusb/libftdi; add udev rule if needed (see README)
        '';
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python3;
        py = pkgs.python3Packages;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            python
            py.virtualenv
            py.pip
            py.setuptools
            py.wheel
            py.black
            py.pyftdi
            py.numpy
            libftdi1
            libusb1
            pkg-config
            git
            gnumake
          ];

          # Convenience env vars for Blinka FT232H
          shellHook = ''
            # Initialize git repository if not already present
            if [ ! -d .git ]; then
              git init
              echo "✓ Initialized git repository"
            fi

            export BLINKA_FT232H=1
            echo "FT232H Blinka environment loaded"
            echo "  python: $(python --version)"
            echo "  BLINKA_FT232H=1"
            echo "Run: make venv install && make scan-i2c"
            echo "If permissions fail, add udev rule from README (11-ftdi.rules)."
          '';
        };

        packages.default = pkgs.writeShellScriptBin "ft232h-helper" ''
                    #!/usr/bin/env bash
                    set -euo pipefail
                    cat <<'EOF'
          FT232H helper
          -------------
          Commands:
            nix develop
            make venv install   # create .venv and install blinka + pyftdi
            make scan-i2c       # run I2C bus scan example
            make gpio           # toggle D0

          Permissions:
            Add udev rule (Linux) if needed:
              sudo tee /etc/udev/rules.d/11-ftdi.rules >/dev/null <<'RULES'
              SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6001", GROUP="plugdev", MODE="0666"
              SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6011", GROUP="plugdev", MODE="0666"
              SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", GROUP="plugdev", MODE="0666"
              SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6014", GROUP="plugdev", MODE="0666"
              SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6015", GROUP="plugdev", MODE="0666"
              RULES
              sudo udevadm control --reload-rules && sudo udevadm trigger
          EOF
        '';
      }
    );
}
