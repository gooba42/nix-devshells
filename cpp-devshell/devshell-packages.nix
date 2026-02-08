{
  pkgs ? import <nixpkgs> { system = builtins.currentSystem; },
}:
# Shared C++ development environment packages for reuse in flakes
with pkgs;
[
  clang
  clang-tools
  cmake
  codespell
  conan
  cppcheck
  doxygen
  gtest
  lcov
  git
  gnumake
  # vcpkg and vcpkg-tool removed due to build failures in nixpkgs
  # Add more shared C++ tools here
]
++ (if stdenv.isDarwin then [ ] else [ gdb ])
