{
  description = "A Nix-flake-based Java development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    inputs@{ self, ... }:
    let
      javaVersion = 21; # Change this value to update the whole stack (using LTS version)

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ inputs.self.overlays.default ];
            };
          }
        );
    in
    {
      templates = {
        default = {
          path = ./.;
          description = "Java dev environment with Gradle/Maven; includes a skeletal project and packaged helper app";
        };
      };

      overlays.default =
        _final: prev:
        let
          jdk = prev."jdk${toString javaVersion}";
        in
        {
          inherit jdk;
          maven = prev.maven.override { jdk_headless = jdk; };
          gradle = prev.gradle.override { java = jdk; };
          lombok = prev.lombok.override { inherit jdk; };
        };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              gcc
              git
              gradle
              jdk
              maven
              ncurses
              patchelf
              zlib
            ];
            shellHook = ''
              # Initialize git repository if not already present
              if [ ! -d .git ]; then
                git init
                echo "✓ Initialized git repository"
              fi
            '';
            shellHook =
              let
                loadLombok = "-javaagent:${pkgs.lombok}/share/java/lombok.jar";
                prev = "\${JAVA_TOOL_OPTIONS:+ $JAVA_TOOL_OPTIONS}";
              in
              ''
                export JAVA_TOOL_OPTIONS="${loadLombok}${prev}"
              '';
          };
        }
      );

      packages = forEachSupportedSystem (
        { pkgs }:
        {
          # Build the skeletal Gradle app and install the launcher
          default = pkgs.stdenv.mkDerivation {
            pname = "sample-java-app";
            version = "0.1.0";
            src = ./.;
            buildInputs = [
              pkgs.jdk
              pkgs.gradle
            ];
            buildPhase = "gradle installDist";
            installPhase = ''
              mkdir -p $out
              cp -r build/install/sample-java-app/* $out/
            '';
            meta.mainProgram = "sample-java-app";
          };

          dev-helper = pkgs.writeShellScriptBin "dev-helper" ''
            echo "Java dev environment (JDK and build tools):"
            command -v java >/dev/null 2>&1 && java -version || true
            command -v mvn >/dev/null 2>&1 && mvn -v || true
            command -v gradle >/dev/null 2>&1 && gradle -v || true
            echo "This binary is built by Nix (packages.dev-helper)."
          '';
        }
      );

      apps = forEachSupportedSystem (
        { pkgs }:
        {
          default = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.default;
          };
          dev-helper = {
            type = "app";
            program = pkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.dev-helper;
          };
        }
      );
    };
}
