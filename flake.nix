{
  description = "A stable of Nix flakes with direnv support and reusable project templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            inherit system;
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      templates = {
        arduino = {
          description = "Arduino development environment with embedded toolchain";
          path = ./arduino;
        };
        c = {
          description = "C development environment with build tools";
          path = ./c;
        };
        circuitpython = {
          description = "CircuitPython development for RP2040, ESP32-S2/S3, SAMD, nRF52, STM32";
          path = ./circuitpython;
        };
        cpp-devshell = {
          description = "C++ development shell with build tools";
          path = ./cpp-devshell;
        };
        dotnet = {
          description = ".NET dev environment (FHS) with SDK, EF Core, and optional Rider support";
          welcomeText = ''
            .NET skeletal project created.
            - Build:   dotnet build
            - Run:     dotnet run
            - Rider:   rider . (inside nix develop)
          '';
          path = ./dotnet;
        };
        embedded-rust = {
          description = "Rust embedded development environment";
          path = ./embedded-rust;
        };
        ft232h = {
          description = "FT232H USB serial interface development environment";
          path = ./ft232h;
        };
        golang = {
          description = "Go development environment";
          path = ./golang;
        };
        java = {
          description = "Java development environment";
          path = ./java;
        };
        jupyter = {
          description = "Jupyter notebook development environment";
          path = ./jupyter;
        };
        micropython = {
          description = "MicroPython development for ESP32, ESP8266, RP2040, STM32";
          welcomeText = ''
            MicroPython project initialized.
            - Flash:  esptool.py --port /dev/ttyUSB0 write_flash -z 0x1000 firmware.bin
            - Upload: ampy --port /dev/ttyUSB0 put main.py
            - REPL:   screen /dev/ttyUSB0 115200
          '';
          path = ./micropython;
        };
        nanoframework = {
          description = ".NET nanoFramework embedded C# environment for microcontrollers";
          welcomeText = ''
            .NET nanoFramework project initialized.
            Supported boards: ESP32, ESP8266, RP Pico, STM32
            - Build:   dotnet build
            - Flash:   nanoff --platform esp32 --serialport /dev/ttyUSB0 --update
            - Deploy:  dotnet build && dotnet run
          '';
          path = ./nanoframework;
        };
        openscad-dev = {
          description = "OpenSCAD 3D CAD modeling environment for parametric design and 3D printing";
          welcomeText = ''
            OpenSCAD project initialized.
            - View:    openscad src/example.scad
            - Render:  make render (outputs STL for 3D printing)
            - Export:  make png (creates preview image)
          '';
          path = ./openscad-dev;
        };
        python = {
          description = "Python development environment with venv, pip, and reusable devShell";
          path = ./python;
        };
        rust = {
          description = "Rust development environment";
          path = ./rust;
        };
        haskell-dev = {
          description = "Haskell development environment with GHC and Cabal";
          path = ./haskell-dev;
        };
        tinygo = {
          description = "TinyGo microcontroller development environment";
          path = ./tinygo;
        };
        ada-dev = {
          description = "Ada development environment";
          path = ./ada-dev;
        };
        cl-dev = {
          description = "Common Lisp development environment";
          path = ./cl-dev;
        };
        clojure-dev = {
          description = "Clojure development environment";
          path = ./clojure-dev;
        };
        cobol-dev = {
          description = "COBOL development environment";
          path = ./cobol-dev;
        };
        erlang-dev = {
          description = "Erlang development environment";
          path = ./erlang-dev;
        };
        forth-dev = {
          description = "Forth development environment";
          path = ./forth-dev;
        };
        freebasic-dev = {
          description = "FreeBASIC development environment";
          path = ./freebasic-dev;
        };
        fsharp-dev = {
          description = "F# development environment";
          path = ./fsharp-dev;
        };
        kdeqt6-dev = {
          description = "KDE/Qt6 development environment";
          path = ./kdeqt6-dev;
        };
        lua-dev = {
          description = "Lua development environment";
          path = ./lua-dev;
        };
        pascal-dev = {
          description = "Pascal development environment";
          path = ./pascal-dev;
        };
        prolog-dev = {
          description = "Prolog development environment";
          path = ./prolog-dev;
        };
        racket-dev = {
          description = "Racket development environment";
          path = ./racket-dev;
        };
        scala-dev = {
          description = "Scala development environment";
          path = ./scala-dev;
        };
        scheme-dev = {
          description = "Scheme development environment";
          path = ./scheme-dev;
        };
        tcltk-dev = {
          description = "Tcl/Tk development environment";
          path = ./tcltk-dev;
        };
        zig-dev = {
          description = "Zig development environment";
          path = ./zig-dev;
        };
      };

      # Checks to verify templates and devShells build correctly
      checks = forEachSystem (
        { system, pkgs }:
        let
          # Verify key templates have required files and structure
          checkTemplate =
            name: requiredFiles:
            pkgs.runCommand "check-template-${name}" { } ''
              echo "Checking template: ${name}"
              cd ${self}/${name}

              # Check for required files
              ${nixpkgs.lib.concatMapStringsSep "\n" (file: ''
                if [ ! -f "${file}" ]; then
                  echo "ERROR: Missing required file: ${file}" >&2
                  exit 1
                fi
              '') requiredFiles}

              # Verify flake.nix is valid Nix syntax
              if [ -f "flake.nix" ]; then
                ${pkgs.nix}/bin/nix flake check --no-build ${self}/${name} || exit 1
              fi

              mkdir -p $out
              echo "✓ Template ${name} structure validated" > $out/result
            '';

          # Check templates with Makefiles have gnumake
          checkMakefile =
            name:
            pkgs.runCommand "check-makefile-${name}" { } ''
              cd ${self}/${name}

              if [ -f "Makefile" ]; then
                if [ -f "flake.nix" ]; then
                  if ! grep -q "gnumake" flake.nix 2>/dev/null; then
                    echo "ERROR: ${name} has Makefile but doesn't include gnumake" >&2
                    exit 1
                  fi
                fi
                if [ -f "default.nix" ]; then
                  if ! grep -q "gnumake" default.nix 2>/dev/null; then
                    echo "ERROR: ${name} has Makefile but doesn't include gnumake in default.nix" >&2
                    exit 1
                  fi
                fi
              fi

              mkdir -p $out
              echo "✓ Makefile check passed for ${name}" > $out/result
            '';

          # Check that git is included in all templates
          checkGit =
            name:
            pkgs.runCommand "check-git-${name}" { } ''
              cd ${self}/${name}

              HAS_GIT=0
              if [ -f "flake.nix" ] && grep -q "git" flake.nix; then
                HAS_GIT=1
              fi
              if [ -f "default.nix" ] && grep -q "git" default.nix; then
                HAS_GIT=1
              fi

              if [ $HAS_GIT -eq 0 ]; then
                echo "ERROR: ${name} doesn't include git" >&2
                exit 1
              fi

              mkdir -p $out
              echo "✓ Git included in ${name}" > $out/result
            '';

        in
        {
          # Template structure checks
          arduino-structure = checkTemplate "arduino" [
            "flake.nix"
            "Makefile"
            "platformio.ini"
          ];
          circuitpython-structure = checkTemplate "circuitpython" [
            "flake.nix"
            "Makefile"
            "firmware/.gitkeep"
          ];
          micropython-structure = checkTemplate "micropython" [
            "flake.nix"
            "Makefile"
            "firmware/.gitkeep"
          ];
          python-structure = checkTemplate "python" [
            "flake.nix"
            "pyproject.toml"
          ];
          rust-structure = checkTemplate "rust" [
            "flake.nix"
            "Cargo.toml"
          ];
          golang-structure = checkTemplate "golang" [ "flake.nix" ];

          # Makefile checks for key templates
          arduino-makefile = checkMakefile "arduino";
          circuitpython-makefile = checkMakefile "circuitpython";
          micropython-makefile = checkMakefile "micropython";
          c-makefile = checkMakefile "c";
          rust-makefile = checkMakefile "rust";

          # Git inclusion checks for key templates
          arduino-git = checkGit "arduino";
          circuitpython-git = checkGit "circuitpython";
          micropython-git = checkGit "micropython";
          python-git = checkGit "python";
          rust-git = checkGit "rust";
          golang-git = checkGit "golang";
          java-git = checkGit "java";
        }
      );
    };
}
