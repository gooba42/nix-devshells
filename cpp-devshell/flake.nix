{
  description = "Shared C++ devShell for flake inheritance";

  outputs = {}: {
    defaultNix = import ./default.nix;
  };
}
