{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs_20
    nodePackages.npm
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.eslint
    nodePackages.prettier
  ];
  shellHook = ''
    echo "[shell.nix] Legacy shell for TypeScript dev. Use 'nix develop' for full flake support."
  '';
}
