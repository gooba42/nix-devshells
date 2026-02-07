# flakes/kdeqt6-dev/flake.nix — KDE/Qt6 dev flake (Wayland)
{
  description = "Dev shell and template for KDE/Qt6 (Wayland) projects";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs =
    { self, nixpkgs }:
    {
      devShells.x86_64-linux.default =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; };
        in
        pkgs.mkShell {
          buildInputs = [
            pkgs.cmake
            pkgs.ninja
            pkgs.gcc
            pkgs.pkg-config
            pkgs.git
            pkgs.qt6.full
            pkgs.qt6.qtwayland
            pkgs.kdePackages.kf6
            pkgs.kdePackages.extra-cmake-modules
            pkgs.kdePackages.kio
            pkgs.kdePackages.kxmlgui
            pkgs.wayland
            pkgs.plasma-wayland-protocols
            pkgs.dbus
            pkgs.gdb
            pkgs.valgrind
            pkgs.clang-tools
            pkgs.nix
            pkgs.alejandra
            pkgs.statix
            pkgs.deadnix
            pkgs.nix-init
            pkgs.nix-update
            pkgs.nix-output-monitor
            pkgs.nix-tree
            pkgs.nvd
            pkgs.git
          ];
          shellHook = ''
            export QT_QPA_PLATFORM=wayland
            export XDG_DATA_DIRS=$XDG_DATA_DIRS:${pkgs.qt6.full}/share:${pkgs.kdePackages.kf6}/share
          '';
        };
      templates.default = {
        path = ./template;
        description = "Minimal KDE/Qt6 (Wayland) CMake project with main window and menus";
      };
    };
}
