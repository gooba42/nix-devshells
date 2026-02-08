{
  description = "Shared C++ devShell for flake inheritance";

  outputs =
    { }:
    {
      defaultNix = import ./devshell-packages.nix;
    };
}
