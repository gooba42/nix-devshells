{
  description = "A stable of Nix flakes with direnv support and reusable project templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = _: {
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
  };
}
