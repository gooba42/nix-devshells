{ pkgs }:
let
  lib = pkgs.lib;
  templateName = builtins.baseNameOf (toString ./.);
in
{
  ${templateName} = pkgs.stdenvNoCC.mkDerivation {
    pname = templateName;
    version = "0.1.0";
    src = ./.;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/${templateName}
      if [ -d src ]; then
        cp -r src $out/share/${templateName}/
      fi
      for f in README.md project.toml flake.nix default.nix shell.nix Makefile .editorconfig .gitignore; do
        if [ -f "$f" ]; then
          cp "$f" $out/share/${templateName}/
        fi
      done
    '';
    meta = with lib; {
      description = "Template project: ${templateName}";
      license = licenses.unfreeRedistributable;
      platforms = platforms.all;
    };
  };
}
