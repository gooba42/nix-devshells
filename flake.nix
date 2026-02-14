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
          welcomeText = ''
            Welcome to the Arduino template.
            - Start: nix develop
            - Next:  Open README.md for board setup
          '';
          path = ./arduino;
        };
        c = {
          description = "C development environment with build tools";
          welcomeText = ''
            Welcome to the C template.
            - Start: nix develop
            - Next:  Open README.md for build instructions
          '';
          path = ./c;
        };
        circuitpython = {
          description = "CircuitPython development for RP2040, ESP32-S2/S3, SAMD, nRF52, STM32";
          welcomeText = ''
            Welcome to the CircuitPython template.
            - Start: nix develop
            - Next:  Open README.md for flashing steps
          '';
          path = ./circuitpython;
        };
        cpp-devshell = {
          description = "C++ development shell with build tools";
          welcomeText = ''
            Welcome to the C++ template.
            - Start: nix develop
            - Next:  Open README.md for build instructions
          '';
          path = ./cpp-devshell;
        };
        dotnet = {
          description = ".NET dev environment (FHS) with SDK, EF Core, and optional Rider support";
          welcomeText = ''
            Welcome to the .NET template.
            .NET skeletal project created.
            - Build:   dotnet build
            - Run:     dotnet run
            - Rider:   rider . (inside nix develop)
          '';
          path = ./dotnet;
        };
        embedded-rust = {
          description = "Rust embedded development environment";
          welcomeText = ''
            Welcome to the Embedded Rust template.
            - Start: nix develop
            - Next:  Open README.md for target setup
          '';
          path = ./embedded-rust;
        };
        ft232h = {
          description = "FT232H USB serial interface development environment";
          welcomeText = ''
            Welcome to the FT232H template.
            - Start: nix develop
            - Next:  Open README.md for udev rules and usage
          '';
          path = ./ft232h;
        };
        golang = {
          description = "Go development environment";
          welcomeText = ''
            Welcome to the Go template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./golang;
        };
        java = {
          description = "Java development environment";
          welcomeText = ''
            Welcome to the Java template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./java;
        };
        jupyter = {
          description = "Jupyter notebook development environment";
          welcomeText = ''
            Welcome to the Jupyter template.
            - Start: nix develop
            - Next:  Open README.md to launch JupyterLab
          '';
          path = ./jupyter;
        };
        micropython = {
          description = "MicroPython development for ESP32, ESP8266, RP2040, STM32";
          welcomeText = ''
            Welcome to the MicroPython template.
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
            Welcome to the .NET nanoFramework template.
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
            Welcome to the OpenSCAD template.
            OpenSCAD project initialized.
            - View:    openscad src/example.scad
            - Render:  make render (outputs STL for 3D printing)
            - Export:  make png (creates preview image)
          '';
          path = ./openscad-dev;
        };
        python = {
          description = "Python development environment with venv, pip, and reusable devShell";
          welcomeText = ''
            Welcome to the Python template.
            - Start: nix develop
            - Next:  Open README.md for venv setup
          '';
          path = ./python;
        };
        rust = {
          description = "Rust development environment";
          welcomeText = ''
            Welcome to the Rust template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./rust;
        };
        typescript = {
          description = "TypeScript development environment with Node.js, esbuild, and full tooling";
          welcomeText = ''
            Welcome to the TypeScript template.
            - Start: nix develop
            - Next:  Open README.md for development setup
          '';
          path = ./typescript;
        };
        haskell-dev = {
          description = "Haskell development environment with GHC and Cabal";
          welcomeText = ''
            Welcome to the Haskell template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./haskell-dev;
        };
        tinygo = {
          description = "TinyGo microcontroller development environment";
          welcomeText = ''
            Welcome to the TinyGo template.
            - Start: nix develop
            - Next:  Open README.md for flashing steps
          '';
          path = ./tinygo;
        };
        ada-dev = {
          description = "Ada development environment";
          welcomeText = ''
            Welcome to the Ada template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./ada-dev;
        };
        cl-dev = {
          description = "Common Lisp development environment";
          welcomeText = ''
            Welcome to the Common Lisp template.
            - Start: nix develop
            - Next:  Open README.md for SBCL usage
          '';
          path = ./cl-dev;
        };
        clojure-dev = {
          description = "Clojure development environment";
          welcomeText = ''
            Welcome to the Clojure template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./clojure-dev;
        };
        cobol-dev = {
          description = "COBOL development environment";
          welcomeText = ''
            Welcome to the COBOL template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./cobol-dev;
        };
        erlang-dev = {
          description = "Erlang development environment";
          welcomeText = ''
            Welcome to the Erlang template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./erlang-dev;
        };
        forth-dev = {
          description = "Forth development environment";
          welcomeText = ''
            Welcome to the Forth template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./forth-dev;
        };
        freebasic-dev = {
          description = "FreeBASIC development environment";
          welcomeText = ''
            Welcome to the FreeBASIC template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./freebasic-dev;
        };
        fsharp-dev = {
          description = "F# development environment";
          welcomeText = ''
            Welcome to the F# template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./fsharp-dev;
        };
        kdeqt6-dev = {
          description = "KDE/Qt6 development environment";
          welcomeText = ''
            Welcome to the KDE/Qt6 template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./kdeqt6-dev;
        };
        lua-dev = {
          description = "Lua development environment";
          welcomeText = ''
            Welcome to the Lua template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./lua-dev;
        };
        pascal-dev = {
          description = "Pascal development environment";
          welcomeText = ''
            Welcome to the Pascal template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./pascal-dev;
        };
        prolog-dev = {
          description = "Prolog development environment";
          welcomeText = ''
            Welcome to the Prolog template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./prolog-dev;
        };
        racket-dev = {
          description = "Racket development environment";
          welcomeText = ''
            Welcome to the Racket template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./racket-dev;
        };
        scala-dev = {
          description = "Scala development environment";
          welcomeText = ''
            Welcome to the Scala template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./scala-dev;
        };
        scheme-dev = {
          description = "Scheme development environment";
          welcomeText = ''
            Welcome to the Scheme template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./scheme-dev;
        };
        tcltk-dev = {
          description = "Tcl/Tk development environment";
          welcomeText = ''
            Welcome to the Tcl/Tk template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
          path = ./tcltk-dev;
        };
        zig-dev = {
          description = "Zig development environment";
          welcomeText = ''
            Welcome to the Zig template.
            - Start: nix develop
            - Next:  Open README.md for build/run steps
          '';
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
